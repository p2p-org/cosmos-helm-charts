#!/bin/bash

NAMESPACE="namada-indexer"
RELEASE_NAME="namada-indexer"

echo "🗑️  Cleaning up resources in namespace: $NAMESPACE"

# Delete Helm release
echo "Removing Helm release..."
helm uninstall $RELEASE_NAME -n $NAMESPACE

# Delete PostgreSQL resources
echo "Removing PostgreSQL resources..."
kubectl delete postgresql -n $NAMESPACE --all
kubectl delete deployment -n $NAMESPACE -l application=db-connection-pooler
kubectl delete statefulset -n $NAMESPACE --all

# Delete PostgreSQL Services
echo "Removing PostgreSQL Services..."
kubectl delete svc -n $NAMESPACE \
  namada-indexer-db \
  namada-indexer-db-config \
  namada-indexer-db-repl \
  namada-indexer-db-pooler \
  namada-indexer-db-repl-pooler \
  namada-indexer-db-pooler-repl

# Delete Other Services
echo "Removing Other Services..."
kubectl delete svc -n $NAMESPACE -l app.kubernetes.io/instance=$RELEASE_NAME

# Delete PVCs
echo "Removing PVCs..."
kubectl delete pvc -n $NAMESPACE --all

# Delete ConfigMaps
echo "Removing ConfigMaps..."
kubectl delete configmap -n $NAMESPACE -l app.kubernetes.io/instance=$RELEASE_NAME

# Delete PostgreSQL Operator Secrets
echo "Removing PostgreSQL Operator Secrets..."
kubectl delete secret -n $NAMESPACE \
  namada.namada-indexer-db.credentials.postgresql.acid.zalan.do \
  pooler.namada-indexer-db.credentials.postgresql.acid.zalan.do \
  postgres.namada-indexer-db.credentials.postgresql.acid.zalan.do \
  standby.namada-indexer-db.credentials.postgresql.acid.zalan.do

# Delete Other Secrets
echo "Removing Other Secrets..."
kubectl delete secret -n $NAMESPACE -l app.kubernetes.io/instance=$RELEASE_NAME

# Delete Ingress
echo "Removing Ingress..."
kubectl delete ingress -n $NAMESPACE -l app.kubernetes.io/instance=$RELEASE_NAME

# Optional: Delete the namespace itself (uncomment if needed)
# echo "Removing namespace..."
# kubectl delete namespace $NAMESPACE

echo "✅ Cleanup completed!"
