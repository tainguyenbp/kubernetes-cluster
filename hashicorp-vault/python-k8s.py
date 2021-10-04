import hvac

f = open('/var/run/secrets/kubernetes.io/serviceaccount/token')
jwt = f.read()
print("jwt:", jwt)
f.close()
client = hvac.Client(url='http://vault:8200', token='your_vault_token')
# res = client.auth_kubernetes("envelope-creator", jwt)
res = client.is_authenticated()
print("res:", res)
hvac_secrets_data_k8s = client.read('secret/data/compliance')
print("hvac_secrets_data_k8s:", hvac_secrets_data_k8s)
