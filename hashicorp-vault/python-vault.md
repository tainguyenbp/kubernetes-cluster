### Get infor vault
```
vault write ssh/creds/role ip=xxx.xxx.xxx.xxx
client = hvac.Client() # client is already authenticated
client.write("ssh/creeds/role", 30, {'ip':'xxx.xxx.xxx.xxx'})

```
