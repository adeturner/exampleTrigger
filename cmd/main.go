package main

import (
	"github.com/adeturner/exampleTrigger"
	"github.com/adeturner/persistenceServices"
	"github.com/google/uuid"
)

func main() {

	UUID := uuid.New().String()

	s := exampleTrigger.Source{Id: UUID, Name: UUID, Tag: UUID}
	// s.PublishPubsub(pubsubTriggers.EVENT_TYPE_CREATE, &s)

	s.PublishEvent(persistenceServices.EVENT_TYPE_CREATE, exampleTrigger.DOCUMENT_TYPE_SOURCES)

}
