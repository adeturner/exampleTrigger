# Defaults that are expected to be overridden
export GCP_PROJECT=myproject
export SECRETS_DIR=~/secrets
export CLOUDEVENT_DOMAIN=mydomain.com
export GOOGLE_APPLICATION_CREDENTIALS=${SECRETS_DIR}/${GCP_PROJECT}-persistenceServices.json  


echo REMEMBER: gcloud auth login
