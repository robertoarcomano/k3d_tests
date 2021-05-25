#!/bin/bash
# C. Constant
CLUSTER=dockerlemp
DOCKERLEMP_WEB=robertoarcomano/dockerlemp_web
DOCKERLEMP_DB=robertoarcomano/dockerlemp_db

# 0. Delete old cluster
k3d cluster delete $CLUSTER

# 1. Create cluster $CLUSTER, redirecting port 80 to 81
k3d cluster create $CLUSTER --port 8081:80@loadbalancer --port 13306:3306@loadbalancer --api-port 6443 --servers 1 --agents 3

# 2. Create service from port 80 to port 80
kubectl create service clusterip dockerlempweb --tcp=80:80
kubectl create service clusterip dockerlempdb --tcp=3306:3306

# 3. Create deployment dockerlemp
kubectl create deployment dockerlempweb --image=$DOCKERLEMP_WEB
kubectl create deployment dockerlempdb --image=$DOCKERLEMP_DB

# 4. Create ingress
kubectl apply -f ingress_web.yaml
kubectl apply -f ingress_db.yaml

# 5. Scale to 3 replicas
kubectl scale deployment dockerlempweb --replicas 2

# Wait until all the pods are ready
while [ $(kubectl get pods| grep -c ContainerCreating) -gt 0 ]; do sleep 1; done
# Restart PHP
kubectl get pods|grep ^dockerlempweb|awk '{print $1}'|while read H; do kubectl exec $H -- /etc/init.d/php7.4-fpm restart; done
