# Get Password from CyberArk
```
Get account details from CyberArk:

$ curl -sSf --cacert "{{CACert}}" --cert "{{Cert}}" --key "{{Key}}" \
  '{{BaseURL}}/AIMWebService/api/Accounts?AppID={{AppID}}&Safe={{Safe}}&Folder={{Folder}}&Object={{ObjectName}}' \
  -H 'Content-Type: application/json'
  
Get password value only:

$ curl -sSf --cacert "{{CACert}}" --cert "{{Cert}}" --key "{{Key}}" \
  '{{BaseURL}}/AIMWebService/api/Accounts?AppID={{AppID}}&Safe={{Safe}}&Folder={{Folder}}&Object={{ObjectName}}' \
  -H 'Content-Type: application/json' | grep -Po '"Content":"\K[^"]+'
  
  
AppID	The unique ID of the application issuing the password request
Safe	The name of the Safe where the password is stored
Folder	The name of the folder where the password is stored (default: Root)
Object	The name of the password object to retrieve
```
