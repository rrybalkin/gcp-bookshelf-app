#!/usr/bin/env sh

cd ..

# When running 1st time, need to login and get Artifact Registry credentials
# gcloud auth login
# gcloud auth configure-docker europe-north2-docker.pkg.dev

ARTIFACT_NAME="bookshelf-app"
ARTIFACT_REGISTRY="europe-north2-docker.pkg.dev/cloudx-gcp-developer-rrybalkin/bookshelf-registry"

# need to build with the target platform to be running in Cloud Run
docker build --platform=linux/amd64 -t ${ARTIFACT_NAME}:latest .

# tag and publish into GCP Artifact Registry
docker tag ${ARTIFACT_NAME}:latest ${ARTIFACT_REGISTRY}/${ARTIFACT_NAME}:latest
docker push ${ARTIFACT_REGISTRY}/${ARTIFACT_NAME}:latest
