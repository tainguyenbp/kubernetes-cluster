### Get infor vault
```
vault write ssh/creds/role ip=xxx.xxx.xxx.xxx
client = hvac.Client() # client is already authenticated
client.write("ssh/creeds/role", 30, {'ip':'xxx.xxx.xxx.xxx'})

```

### Get infor vault 1
```
root@lxd-home:/home/fakrul# vault kv get secret/meraki
====== Metadata ======
Key Value
--- -----
created_time 2020-06-05T15:13:18.320931138Z
deletion_time n/a
destroyed false
version 1
========== Data ==========
Key Value
--- -----
MERAKI_API_VALUE de300b8b9xxxxxxxxxxxxxxxxxxxxxxxxx40fb4391c

python3 -m pip hvac


import requests
import hvac
 
client = hvac.Client(url='http://192.168.99.252:8200')
read_response = client.secrets.kv.read_secret_version(path='meraki')
 
MERAKI_API_KEY = 'X-Cisco-Meraki-API-Key'
ORG_ID='123456'
MERAKI_API_VALUE = read_response['data']['data']['MERAKI_API_VALUE']
 
url = 'https://api.tainn.com/api/v0/organizations/{}/inventory'.format(ORG_ID)
 
response = requests.get(url=url,
           headers={MERAKI_API_KEY : MERAKI_API_VALUE,
                   'Content-type': 'application/json'})
 
switch_list = response.json()
 
switch_serial = []
for i in switch_list:
    if i['model'][:2] in ('MS') and i['networkId'] is not None:
    switch_serial.append(i['serial'])
 
print(switch_serial)
```
# Reference:
```
https://hvac.readthedocs.io/en/stable/overview.html#installation
https://fakrul.wordpress.com/2020/06/04/how-to-hide-password-api-key-in-python-script/
https://fakrul.wordpress.com/2020/06/06/python-script-credentials-stored-in-hashicorp-vault/
https://stackoverflow.com/questions/56502231/write-secrets-to-vault-using-python-hvac
https://stackoverflow.com/questions/68907482/vault-read-secrets-with-python
https://stackoverflow.com/questions/55030523/hashicorp-vault-python-hvac-read
```
