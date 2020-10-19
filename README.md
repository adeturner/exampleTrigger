# exampleTrigger

Example of a cloud platform agnostic serverless event trigger

Currently the infra build is just GCP with Pubsub and Firestore database

The use of github.com/adeturner/persistenceServices means extension to other clouds should be simple

To add additional triggers into the project:

- use the sources*go files as boilerplate
- add additional build scripts

## Create a custom environment file

```bash
cat > somedir/myenv.sh << EOF
export GCP_PROJECT=myproject
export SECRETS_DIR=~/secrets
export CLOUDEVENT_DOMAIN=mydomain.com
export GOOGLE_APPLICATION_CREDENTIALS=${SECRETS_DIR}/${GCP_PROJECT}-persistenceServices.json  // if testing outside of GCP
EOF
```

## Deploy function

```bash
cd build

. 0_env.sh
. somedir/myenv.sh

1_build_pubsub_sources.sh
```

## run test

```bash
. somedir/myenv.sh
export LOG_ENABLED=true
export LOG_LEVEL=INFO # DEBUG, INFO, WARN, ERROR
export USE_FIRESTORE=true
export USE_PUBSUB=true
export USE_CQRS=false

go run cmd/main.go
```
