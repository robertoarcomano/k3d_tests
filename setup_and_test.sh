#!/bin/bash

# Constants
SERVERS=1
AGENTS=1
CLUSTER=cluster1

# 1. Create cluster
k3d cluster create $CLUSTER --servers $SERVERS --agents $AGENTS

# 2. Show nodes
kubectl get nodes

# 3. Test with busybox
OUTPUT=$(kubectl run -it busybox --image=busybox --restart=OnFailure -- busybox echo "45+64"|bc)
if [ $OUTPUT -eq 109 ]; then
  echo "Test ok"
else
  echo "Error"
fi

# 4. Remove cluster
k3d cluster delete $CLUSTER 2>/dev/null
