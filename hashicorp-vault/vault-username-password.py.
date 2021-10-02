```
import requests
import hvac
import os
import json

client = hvac.Client(
    url=os.environ['VAULT_ADDR'],
    token=os.environ['VAULT_TOKEN']
)
read_response = client.secrets.kv.v2.read_secret_version(path='databases/db1')
usernames = read_response.get('data', '').get('data', '').get('username', '')
passwords = read_response.get('data', '').get('data', '').get('password', '')

print(usernames)
print(passwords)
```
