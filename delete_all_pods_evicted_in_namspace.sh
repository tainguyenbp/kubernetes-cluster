#!/bin/bash
NAMESPACE='tainguyenbp'
kubectl get pod -n $NAMESPACE | grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n $NAMESPACE
