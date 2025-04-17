
NAMESPACE="local-dev"

echo "Deploying service into k8s namespace ${NAMESPACE}"

kubectl create namespace "$NAMESPACE" || echo "Namespace $NAMESPACE already exists."

# delete resources first
kubectl delete service bookshelf-app-service -n="$NAMESPACE"
kubectl delete serviceaccount bookshelf-app-sa -n="$NAMESPACE"
kubectl delete deployment bookshelf-app -n="$NAMESPACE"

# create new resources from configuration files
kubectl create -f sa.yaml -n="$NAMESPACE"
kubectl create -f deployment.yaml -n="$NAMESPACE"
kubectl create -f service.yaml -n="$NAMESPACE"

echo "Deployment succeeded."