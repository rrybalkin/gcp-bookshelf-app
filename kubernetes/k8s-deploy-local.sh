
IMAGE_NAME="europe-north2-docker.pkg.dev/cloudx-gcp-developer-rrybalkin/bookshelf-registry/bookshelf-app"
IMAGE_TAG="latest"
NAMESPACE="local-dev"
DEPLOYMENT_NAME="bookshelf-app"
PROJECT_ID="$(gcloud config get project)"

# Deploy docker image into k8s
kubectl --namespace ${NAMESPACE} create deployment ${DEPLOYMENT_NAME} --image=${IMAGE_NAME}:${IMAGE_TAG}
kubectl --namespace ${NAMESPACE} set env deployment/${DEPLOYMENT_NAME} PORT=80
kubectl --namespace ${NAMESPACE} set env deployment/${DEPLOYMENT_NAME} GOOGLE_CLOUD_PROJECT=${PROJECT_ID}
kubectl --namespace ${NAMESPACE} set env deployment/${DEPLOYMENT_NAME} DAO_TYPE="cloudsql"

# Create a service account in k8s
kubectl --namespace ${NAMESPACE} create serviceaccount ${DEPLOYMENT_NAME}-sa
kubectl --namespace ${NAMESPACE} annotate serviceaccount ${DEPLOYMENT_NAME}-sa iam.gke.io/gcp-service-account=bookshelf-sa@${PROJECT_ID}.iam.gserviceaccount.com

gcloud iam service-accounts add-iam-policy-binding \
    bookshelf-sa@${PROJECT_ID}.iam.gserviceaccount.com \
    --member="serviceAccount:${PROJECT_ID}.svc.id.goog[$NAMESPACE/${DEPLOYMENT_NAME}-sa]" \
    --role="roles/iam.workloadIdentityUser"

# Update deployment to assign SA
kubectl patch deployment ${DEPLOYMENT_NAME} \
  --namespace=${NAMESPACE} \
  --type=json \
  --patch='[{"op": "replace", "path": "/spec/template/spec/serviceAccountName", "value": "${DEPLOYMENT_NAME}-sa"}]'

echo "Deployment bookshelf-app created in k8s, pod is starting..."
kubectl get pod --namespace ${NAMESPACE}
