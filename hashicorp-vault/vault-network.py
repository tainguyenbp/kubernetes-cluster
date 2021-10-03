import requests
import hvac
import os
import json
from netmiko import ConnectHandler
from getpass import getpass

# vault kv put secret/cisco/host host='192.168.1.1'
# vault kv put secret/cisco/username username=tainguyenbp
# vault kv put secret/cisco/password password=passw0rd
# vault kv put secret/cisco/port port=22
# vault kv put secret/cisco/secret secret=passw0rd

client = hvac.Client(url=os.environ['VAULT_ADDR'], token=os.environ['VAULT_TOKEN'])


read_response_host = client.secrets.kv.v2.read_secret_version(path='cisco/host')
read_response_username = client.secrets.kv.v2.read_secret_version(path='cisco/username')
read_response_password = client.secrets.kv.v2.read_secret_version(path='cisco/password')
read_response_port= client.secrets.kv.v2.read_secret_version(path='cisco/port')
read_response_secret= client.secrets.kv.v2.read_secret_version(path='cisco/secret')

host = read_response_host.get('data', '').get('data', '').get('host', '')
username = read_response_username.get('data', '').get('data', '').get('username', '')
password = read_response_password.get('data', '').get('data', '').get('password', '')
port = read_response_port.get('data', '').get('data', '').get('port', '')
secret = read_response_secret.get('data', '').get('data', '').get('secret', '')

print(host)
print(username)
print(password)
print(port)
print(secret)


cisco_ios = {
    'device_type': 'cisco_ios',
    'host': host,
    'username': username,
    'password': password,
    'port' : port,
    'secret': secret,
}  


net_connect = ConnectHandler(**cisco_ios)
print(net_connect.find_prompt())
net_connect.disconnect()
