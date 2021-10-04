import hvac
vault_url = 'https://<vault url>:8200/'
vault_token = '<vault token>'
ca_path = '/run/secrets/kubernetes.io/serviceaccount/ca.crt'  
secret_path = '<secret path in vault>'

client = hvac.Client(url=vault_url,token=vault_token,verify= ca_path)
client.is_authenticated()

read_secret_result = client.read(secret_path)
print(read_secret_result)
print(read_secret_result['data']['username'])
print(read_secret_result['data']['password'])
