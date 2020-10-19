
# customisable env vars
export FUNCTION_NAME=SourcesExampleTrigger
export FUNCTIONS_REGION=europe-west1
export FUNCTION_LOWERCASE=`echo $FUNCTION_NAME | tr '[:upper:]' '[:lower:]'`
export PUBSUB_ALLOWED_REGIONS=europe-west1,europe-west2,europe-west3
export SERVICE_ACCOUNT=pubsub-triggers-srvacct
export TOPIC_NAME=sourcesExampleTopic

#####################################################################################################

# gcloud pubsub topics create TOPIC [TOPIC ...] [--labels=[KEY=VALUE,...]]
#    [--message-storage-policy-allowed-regions=[REGION,...]]
#    [--topic-encryption-key=TOPIC_ENCRYPTION_KEY
#        : --topic-encryption-key-keyring=TOPIC_ENCRYPTION_KEY_KEYRING
#        --topic-encryption-key-location=TOPIC_ENCRYPTION_KEY_LOCATION
#        --topic-encryption-key-project=TOPIC_ENCRYPTION_KEY_PROJECT]
    

gcloud pubsub topics create ${TOPIC_NAME} --message-storage-policy-allowed-regions=${PUBSUB_ALLOWED_REGIONS}

# gcloud pubsub topics delete ${TOPIC_NAME} 
# gcloud pubsub topics describe ${TOPIC_NAME} 
# 
# messageStoragePolicy:
#   allowedPersistenceRegions:vi 
#   - europe-west1
#   - europe-west2
#   - europe-west3
# name: projects/apiv01/topics/sourcesTopic


# TODO *** service accounts need tightening up ***

gcloud iam service-accounts create ${SERVICE_ACCOUNT} --description="Service account for all pubsub triggers" --display-name="${SERVICE_ACCOUNT}"

gcloud projects add-iam-policy-binding ${GCP_PROJECT} \
   --member "serviceAccount:${SERVICE_ACCOUNT}@${GCP_PROJECT}.iam.gserviceaccount.com" --role "roles/datastore.owner"

gcloud projects add-iam-policy-binding ${GCP_PROJECT} \
   --member "serviceAccount:${SERVICE_ACCOUNT}@${GCP_PROJECT}.iam.gserviceaccount.com" --role "roles/pubsub.admin"

gcloud iam service-accounts keys create ${GOOGLE_APPLICATION_CREDENTIALS} --iam-account "${SERVICE_ACCOUNT}@${GCP_PROJECT}.iam.gserviceaccount.com"


gcloud functions deploy ${FUNCTION_NAME} \
 --entry-point ${FUNCTION_NAME} \
 --runtime go113 \
 --trigger-topic ${TOPIC_NAME} \
 --region ${FUNCTIONS_REGION} \
 --service-account ${SERVICE_ACCOUNT}@${GCP_PROJECT}.iam.gserviceaccount.com \
 --clear-labels  \
 --update-labels env=smoketest,version=0_1 \
 --set-env-vars GCP_PROJECT=${GCP_PROJECT},CLOUDEVENT_DOMAIN=${CLOUDEVENT_DOMAIN},USE_FIRESTORE=true,USE_PUBSUB=true,USE_CQRS=false,DEBUG=true \
 --quiet

gcloud pubsub topics list
gcloud pubsub subscriptions list
gcloud iam service-accounts list

# export SUBSCRIPTION_NAME=my-sub
#
# gcloud pubsub topics update ${TOPIC_NAME} --message-storage-policy-allowed-regions=us-central1,us-east1
#
# ## create
# gcloud pubsub subscriptions create ${SUBSCRIPTION_NAME} --topic=${TOPIC_NAME}
#
# ## publish
# gcloud pubsub topics publish ${TOPIC_NAME} --message="hello"
#
# ## consume
# gcloud pubsub subscriptions pull ${SUBSCRIPTION_NAME} --auto-ack
#
# ## clean up
# gcloud pubsub subscriptions delete ${SUBSCRIPTION_NAME}
# gcloud pubsub topics delete ${TOPIC_NAME}







