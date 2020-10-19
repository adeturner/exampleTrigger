package exampleTrigger

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/adeturner/observability"
	"github.com/adeturner/persistenceServices"
	cloudevents "github.com/cloudevents/sdk-go/v2"
)

// https://cloudevents.github.io/sdk-go/

// PubSubMessage is the payload of a Pub/Sub event.
type PubSubMessage struct {
	Data []byte `json:"data"`
}

// SourcesPubsubTrigger -
// GCP function that consumes a Pub/Sub message
func SourcesExampleTrigger(ctx context.Context, m PubSubMessage) error {

	var source Source
	var persistenceLayer *persistenceServices.PersistenceLayer

	event := cloudevents.NewEvent()
	err := json.Unmarshal(m.Data, &event)

	if err != nil {
		observability.Logger("Error", fmt.Sprintf("Failed to receive from topic error=%v", err))
	} else {
		observability.Logger("Debug", fmt.Sprintf("Received event from %s type=%s myEvent=%v", event.Source(), event.Type(), string(event.Data())))
	}

	if err == nil {
		persistenceLayer, err = persistenceServices.GetPersistenceLayer(DOCUMENT_TYPE_SOURCES)

		if err != nil {
			observability.Logger("Error", fmt.Sprintf("Failed to get persistenceLayer error=%v", err))
		} else {
			observability.Logger("Debug", fmt.Sprintf("Successfully obtained persistenceLayer"))
		}
	}

	if err == nil {
		err = json.Unmarshal(event.Data(), &source)

		if err != nil {
			observability.Logger("Error", fmt.Sprintf("Failed to unmarshal cloudevent into Source Error: %v", err))
		} else {
			observability.Logger("Debug", fmt.Sprintf("Unmarshalled cloudevent Source=%v", source))
		}
	}

	if err == nil {

		switch event.Type() {
		case persistenceServices.EVENT_TYPE_CREATE.String():
			err = persistenceLayer.AddDocument(source.Id, source)
		case persistenceServices.EVENT_TYPE_UPDATE.String():
			err = persistenceLayer.UpdateDocument(source.Id, source)
		case persistenceServices.EVENT_TYPE_DELETE.String():
			err = persistenceLayer.DeleteDocument(source.Id, source)
		case persistenceServices.EVENT_TYPE_NOTIFICATION.String():
			observability.Logger("Error", "EVENT_TYPE_NOTIFICATION not implemented")
		case persistenceServices.EVENT_TYPE_ERROR.String():
			observability.Logger("Error", "EVENT_TYPE_ERROR not implemented")
		default:
			observability.Logger("Error", "Unknown event type")
		}

		if err != nil {
			observability.Logger("Error", fmt.Sprintf("SourcesPubsubTrigger: Failed to write to persistenceLayer: %v", err))
		}
	}

	return err
}

// PublishEvent - used for local testing only in cmd/main.go
func (s *Source) PublishEvent(eventType persistenceServices.EventType, docType DocType) error {

	// Producers MUST ensure that source + id is unique for each distinct event.
	// Consumers MAY assume that Events with identical source and id are duplicates.

	var err error

	var persistenceLayer *persistenceServices.PersistenceLayer

	if err == nil {
		persistenceLayer, err = persistenceServices.GetPersistenceLayer(docType)
		if err != nil {
			observability.Logger("Error", fmt.Sprintf("Failed to get persistenceLayer error=%v", err))
		} else {
			observability.Logger("Debug", fmt.Sprintf("Successfully obtained persistenceLayer"))

			err = persistenceLayer.Publish(eventType, s.Id, s)
		}
	}

	return err
}
