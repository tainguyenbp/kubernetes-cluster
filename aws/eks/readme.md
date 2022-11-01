```
You could just:

Copy your kubeconfig to clipboard as base64 string:
cat ~/.kube/config | base64 | pbcopy

On your CI pipeline, create a environment variable kube_config and paste your base64 string

Encode your base64 variable back to kubeconfig environmental variable:
echo ${kube_config} | base64 -d > ${KUBECONFIG}

Set context with kubectl:
kubectl config use-context <name of your context>

Execute your commands

Done!
```
