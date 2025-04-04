package types

type Classifier interface {
	ClassifyImage(image []byte) (*Classification, error)
}

type Classification struct {
	Type          []string `json:"type"`
	Subtype       []string `json:"subtype"`
	Confidence    []string `json:"confidence"`
	Points        int      `json:"points"`
	NonRecyclable []string `json:"non_recyclable"`
	Image         string   `json:"image"`
}
