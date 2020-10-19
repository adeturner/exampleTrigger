
# generates a uuid based source and publishes so you can confirm if the trigger has picked it up

export LOG_ENABLED=true 
export LOG_LEVEL=INFO # DEBUG, INFO, WARN, ERROR
export USE_FIRESTORE=true
export USE_PUBSUB=true
export USE_CQRS=false

go run cmd/main.go

# export SUBSCRIPTION_NAME=localtest
# export TOPIC_NAME=sourcesTopic

# gcloud pubsub subscriptions create ${SUBSCRIPTION_NAME} --topic=${TOPIC_NAME}

# gcloud pubsub subscriptions pull ${SUBSCRIPTION_NAME} --auto-ack --limit=5

# gcloud pubsub subscriptions delete ${SUBSCRIPTION_NAME}
