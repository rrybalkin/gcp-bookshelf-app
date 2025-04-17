
NAMESPACE=$1
if [ -z "$NAMESPACE" ]; then
  NAMESPACE="local-dev"
fi

# change to true in case of need deleting resources first
DELETE_BEFORE_DEPLOY=false

echo "Deploying service into k8s namespace ${NAMESPACE}"

kubectl create namespace "$NAMESPACE" || echo "Namespace $NAMESPACE already exists."

# optionally delete the existing resources
if [ $DELETE_BEFORE_DEPLOY ]; then
  echo "Deleting the existing resources..."
  kubectl delete service bookshelf-app-service -n="$NAMESPACE"
  kubectl delete serviceaccount bookshelf-app-sa -n="$NAMESPACE"
  kubectl delete deployment bookshelf-app -n="$NAMESPACE"
fi

# create new resources
# create a secret with DB credentials first, need to fetch secret data from GCP Secrets
export DB_USER=$(gcloud secrets versions access latest --secret=cloudsql-db-user | base64)
export DB_PASS=$(gcloud secrets versions access latest --secret=cloudsql-db-pass | base64)
envsubst < db-secret.yaml | kubectl -n="$NAMESPACE" apply -f -

# create the rest of resources
kubectl apply -f sa.yaml -n="$NAMESPACE"
kubectl apply -f deployment.yaml -n="$NAMESPACE"
kubectl apply -f service.yaml -n="$NAMESPACE"

echo "Deployment succeeded."
