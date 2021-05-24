#!/bin/bash
# 0. Delete old cluster
k3d cluster delete dev

# 1. Create cluster dev, redirecting port 80 to 81
k3d cluster create dev --port 8081:80@loadbalancer --port 8443:443@loadbalancer --api-port 6443 --servers 1 --agents 1

# 2. Create deployment dockerlemp
kubectl create deployment dockerlemp --image=robertoarcomano/dockerlemp

# 3. Create service from port 80 to port 80
kubectl create service clusterip dockerlemp --tcp=80:80

# 4. Create ingress
kubectl apply -f ingress.yaml

# 5. Scale to 3 replicas
kubectl scale deployment dockerlemp --replicas 3
