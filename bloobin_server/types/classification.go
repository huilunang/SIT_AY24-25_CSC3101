package types

type Classification struct {
	Type    string `json:"type"`
	Subtype string `json:"subtype"`
	Points  int    `json:"points"`
}
