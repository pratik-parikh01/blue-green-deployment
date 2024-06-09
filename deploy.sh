
# create assignment namespace if not exists
kubectl create namespace assignment --dry-run=client -o yaml | kubectl apply -f -

# create the required components
kubectl -n assignment apply -f ./manifests
