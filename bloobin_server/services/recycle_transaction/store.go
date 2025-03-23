package recycletransaction

import (
	"database/sql"
	"fmt"

	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/utils"
)

type Store struct {
	Db *sql.DB
}

func NewStore(db *sql.DB) *Store {
	return &Store{Db: db}
}

// func (s *Store) GetRecycleTransactions(userId string) ([]types.RecycleTransaction, error) {
// 	query := `
// 	SELECT *
// 	FROM T_RECYCLE_TRANSACTION
// 	WHERE USER_ID = $1
// 	ORDER BY DATE DESC
// 	`
// 	stmt, err := s.prepareStmt(query)

// 	if err != nil {
// 		return nil, err
// 	}
// 	defer stmt.Close()

// 	rows, err := stmt.Query(userId)
// 	if err != nil {
// 		return nil, err
// 	}

// 	recycleTransactions := make([]types.RecycleTransaction, 0)
// 	for rows.Next() {
// 		recycleTransaction := new(types.RecycleTransaction)

// 		err = rows.Scan(
// 			&recycleTransaction.ID,
// 			&recycleTransaction.Type,
// 			&recycleTransaction.Subtype,
// 			&recycleTransaction.Image,
// 			&recycleTransaction.Description,
// 			&recycleTransaction.Date,
// 			&recycleTransaction.CreatedAt,
// 			&recycleTransaction.UserId,
// 		)
// 		if err != nil {
// 			return nil, err
// 		}

// 		recycleTransactions = append(recycleTransactions, *recycleTransaction)
// 	}

// 	return recycleTransactions, nil
// }

func (s *Store) CheckAvailablePoints(userId int, points int) (int, string, error) {
	const maxPoints = 5

	var totalRecyclablePoints int
	query := `
        SELECT COUNT(*)
        FROM T_RECYCLE_TRANSACTION
        WHERE USER_ID = $1 AND TYPE != 'non-recyclable' AND DATE = CURRENT_DATE
    `
	err := s.Db.QueryRow(query, userId).Scan(&totalRecyclablePoints)
	if err != nil {
		return 0, "", err
	}

	if totalRecyclablePoints >= maxPoints {
		return 0, fmt.Sprintf("Daily point limit reached (%d/%d).", maxPoints, maxPoints), nil
	}

	availablePoints := maxPoints - totalRecyclablePoints
	if points > availablePoints {
		points = availablePoints
	}

	remainingPoints := maxPoints - totalRecyclablePoints - points
	message := fmt.Sprintf(
		"%d/%d points earned today. %d point%s left.",
		totalRecyclablePoints+points, maxPoints, remainingPoints, utils.Pluralize(remainingPoints),
	)

	return availablePoints, message, nil
}

func (s *Store) SaveImage(image []byte) (int, error) {
	query := `
	INSERT INTO T_IMAGE (IMAGE)
	VALUES ($1)
	RETURNING ID
	`
	var imageId int

	err := s.Db.QueryRow(query, image).Scan(&imageId)
	if err != nil {
		return 0, err
	}

	return imageId, nil
}

func (s *Store) CreateRecycleTransaction(recycleTransaction types.RecycleTransaction, points int) error {
	tx, err := s.Db.Begin()
	if err != nil {
		return err
	}

	query := `
	INSERT INTO T_RECYCLE_TRANSACTION (TYPE, SUBTYPE, CONFIDENCE, DESCRIPTION, DATE, PREDICTION_ID, IMAGE_ID, USER_ID)
	VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
	`
	_, err = tx.Exec(query,
		recycleTransaction.Type,
		recycleTransaction.Subtype,
		recycleTransaction.Confidence,
		recycleTransaction.Description,
		recycleTransaction.Date,
		recycleTransaction.PredictionId,
		recycleTransaction.ImageId,
		recycleTransaction.UserId,
	)
	if err != nil {
		tx.Rollback()
		return err
	}

	query = `
	UPDATE T_USER
	SET POINTS = POINTS + $1 WHERE ID = $2
	`
	_, err = tx.Exec(query, points, recycleTransaction.UserId)
	if err != nil {
		tx.Rollback()
		return err
	}

	err = tx.Commit()
	if err != nil {
		return err
	}

	return nil
}

// func (s *Store) prepareStmt(q string) (*sql.Stmt, error) {
// 	stmt, err := s.Db.Prepare(q)

// 	if err != nil {
// 		return nil, err
// 	}

// 	return stmt, nil
// }
