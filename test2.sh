kubectl get pods -n production | grep Pending | awk '{print $1}' | xargs kubectl delete pod -n production  --force
