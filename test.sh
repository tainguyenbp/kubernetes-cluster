kubectl get pods -n production | grep CrashLoopBackOff | awk '{print $1}' | xargs kubectl describe pod -n production  | grep event
