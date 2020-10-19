package exampleTrigger

type DocType int

// below for compilation and local testing

const (
	DOCUMENT_TYPE_SOURCES DocType = iota
	DOCUMENT_TYPE_OTHERS
)

func (d DocType) String() string {
	return [...]string{
		"Sources",
		"Add other doc types...",
	}[d]
}

func (d DocType) Topic() string {
	return [...]string{
		"sourcesTopic",
		"Add other topic names...",
	}[d]
}
