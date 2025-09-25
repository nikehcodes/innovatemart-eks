#!/bin/bash

# Update kubeconfig
aws eks update-kubeconfig --region us-west-2 --name innovatemart-eks

# Apply RBAC
kubectl apply -f k8s-manifests/rbac/

# Deploy retail store application
kubectl apply -f k8s-manifests/retail-store-app/

# Wait for deployment
kubectl rollout status deployment/ui -n default
kubectl rollout status deployment/catalog -n default
kubectl rollout status deployment/orders -n default
kubectl rollout status deployment/carts -n default

echo "Application deployed successfully!"
echo "Access the application:"
echo "kubectl port-forward svc/ui 8080:80"
