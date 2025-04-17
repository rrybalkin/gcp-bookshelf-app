#!/usr/bin/env sh

ARTIFACT_NAME="bookshelf-app"
ARTIFACT_VERSION="latest"
ARTIFACT_REGISTRY="europe-north2-docker.pkg.dev/cloudx-gcp-developer-rrybalkin/bookshelf-registry"
IMAGE_URL=${ARTIFACT_REGISTRY}/${ARTIFACT_NAME}:${ARTIFACT_VERSION}
REGION="europe-north2"
GOOGLE_CLOUD_PROJECT=$(gcloud config get project)

gcloud run deploy ${ARTIFACT_NAME} \
  --image ${IMAGE_URL} \
  --platform managed \
  --region ${REGION} \
  --allow-unauthenticated \
  --update-env-vars=GOOGLE_CLOUD_PROJECT="${GOOGLE_CLOUD_PROJECT}" \
  --service-account=bookshelf-sa@cloudx-gcp-developer-rrybalkin.iam.gserviceaccount.com
