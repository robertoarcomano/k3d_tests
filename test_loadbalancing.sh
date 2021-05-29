#!/bin/bash
# C. Constant
CLUSTER=dockerlemp
DOCKERLEMP_WEB=robertoarcomano/dockerlemp_web
DOCKERLEMP_DB=robertoarcomano/dockerlemp_db

# 0. Delete old cluster
k3d cluster delete $CLUSTER

# 1. Create cluster $CLUSTER, redirecting port 80 to 8081
k3d cluster create $CLUSTER --port 8081:80@loadbalancer --api-port 6443 --servers 1 --agents 1

# 2. Create deployments db + service 3306
kubectl create deployment dockerlempdb --image=$DOCKERLEMP_DB
kubectl create service clusterip dockerlempdb --tcp=3306:3306

# 4. Create deployments web + service 80
kubectl create deployment dockerlempweb --image=$DOCKERLEMP_WEB
kubectl create service clusterip dockerlempweb --tcp=80:80

# 5. Wait until web is available
while [ "$(kubectl get pods| grep -c ContainerCreating)" -gt 0 ]; do sleep 1; done

# 6. Create ingress
kubectl apply -f ingress.yaml

# 7. Wait for a while
sleep 60

# 8. Test singole session
wget http://localhost:8081/ -O -

# 9. Scale to 9 replicas and wait to seattle down
kubectl scale deployment dockerlempweb --replicas 9
while [ "$(kubectl get pods| grep -c ContainerCreating)" -gt 0 ]; do sleep 1; done

# 10. Install apache bench tool and use it to test the load balancing server
sudo apt-get install -y apache2-utils
ab -n 1000 -c 9 http://localhost:8081/
