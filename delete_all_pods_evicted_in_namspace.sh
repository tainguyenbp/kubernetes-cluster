kubectl get pod -n tainguyenbp | grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n tainguyenbp
