# Install vault
### Step 1. 
```
sudo mkdir -p /opt/vault/{logs,bin,data,tls}

```

### Step 1. 
```
wget https://releases.hashicorp.com/vault/1.8.2/vault_1.8.2_linux_amd64.zip
unzip vault_1.8.2_linux_amd64.zip -d /opt/vault/bin
chmod +x /opt/vault/bin/vault
```

### Step 1. 
```
sudo mkdir /etc/vault
sudo touch /etc/vault/config.json

```

### Step 1. vim /etc/vault/config.json http
```
  "listener": [{
    "tcp": {
      "address" : "0.0.0.0:8200",
      "tls_disable" : 1
    }
  }],
  "api_addr": "http://127.0.0.1:8200",
  "storage": {
     "file": {
       "path" : "/opt/vault/data"
     }
  },
  "max_lease_ttl": "10h",
  "default_lease_ttl": "10h",
  "ui":true
 }
```

### Step 1. vim /etc/vault/config.json https
```
{
  "listener": [{
    "tcp": {
      "address" : "0.0.0.0:8200",
      "tls_cert_file" : "/opt/vault/tls/vault.tainguyenbp.local.crt",
      "tls_key_file" : "/opt/vault/tls/vault.tainguyenbp.local.key"
    }
  }],
  "api_addr": "http://127.0.0.1:8200",
  "storage": {
     "file": {
       "path" : "/opt/vault/data"
     }
  },
  "max_lease_ttl": "10h",
  "default_lease_ttl": "10h",
  "ui":true
 }
```

### Step 1. Script generate tls
```

#!/bin/bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PATH_TLS='/opt/vault/tls/'

name='vault'
domain_cert_ssl=""$name".tainguyenbp.local"
email_cert_ssl=""$name".tainguyenbp.local"

openssl req -new -newkey rsa:4096 -sha256 -days 1095 -nodes -x509 -keyout "$PATH_TLS$domain_cert_ssl".key -out "$PATH_TLS$domain_cert_ssl".crt \
                -subj "/C=VN/ST=HCM/L=HCM/O=DR/OU=DR/CN=$domain_cert_ssl/emailAddress=$email_cert_ssl"

openssl x509 -in "$PATH_TLS$domain_cert_ssl".crt -text
chown -R vault:vault $PATH_TLS
```
### Step 1. vim /etc/vault/vault.hcl
```
ui = true

#mlock = true
#disable_mlock = true

storage "file" {
  path = "/opt/vault/data"
}

#storage "consul" {
#  address = "127.0.0.1:8500"
#  path    = "vault"
#}

# HTTP listener
#listener "tcp" {
#  address = "127.0.0.1:8200"
#  tls_disable = 1
#}

# HTTPS listener
listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_cert_file = "/opt/vault/tls/vault.tainn.local.crt"
  tls_key_file  = "/opt/vault/tls/vault.tainn.local.key"
}


      ui = true

      api_addr = "https://127.0.0.1:8200" # Unsure if this is correct

      storage "dynamodb" {
        ha_enabled = "true"
        region     = "eu-west-2"
        table      = "global-vault-data"
        access_key = "KEY"
        secret_key = "SECRET"
      }

      # listener "tcp" {
      #     address = "0.0.0.0:8200"
      #     tls_disable = "true"
      # }

      listener "tcp" {
        address = "0.0.0.0:8200"
        cluster_address = "0.0.0.0:8201"
        tls_cert_file = "/vault/userconfig/vault-server-tls/vault.crt"
        tls_key_file  = "/vault/userconfig/vault-server-tls/vault.key"
        tls_client_ca_file = "/vault/userconfig/vault-server-tls/vault.ca"
      }

      seal "awskms" {
        region     = "eu-west-2"
        access_key = "KEY"
        secret_key = "SECRET"
        kms_key_id = "ID"
      }
```

### Step 1. vim /etc/systemd/system/vault.service
```
[Unit]
Description=vault service
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault/config.json

[Service]
User=vault
Group=vault
EnvironmentFile=-/etc/sysconfig/vault
Environment=GOMAXPROCS=2
Restart=on-failure
ExecStart=/opt/vault/bin/vault server -config=/etc/vault/config.json
StandardOutput=/opt/vault/logs/output.log
StandardError=/opt/vault/logs/error.log
LimitMEMLOCK=infinity
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM

[Install]
WantedBy=multi-user.target
```



### Step 1. 
```
sudo useradd -r vault

sudo chown -R vault:vault /opt/vault

chown -R vault:vault /etc/vault
```

### Step 1. 
```
systemctl start vault
systemctl status vault
```

### Step 1. Add the Vault bin directory to your PATH environment variable.
```
export PATH=$PATH:/opt/vault/bin
echo "export PATH=$PATH:/opt/vault/bin" >> ~/.bashrc
```

### Step 1. Set environment variables for Vault
```
export VAULT_ADDRESS='http://127.0.0.1:8200'

echo "export VAULT_ADDR=http://127.0.0.1:8200" >> ~/.bashrc

export VAULT_ADDR='https://127.0.0.1:8200'
export VAULT_ADDRESS='https://127.0.0.1:8200'
echo "export VAULT_ADDR=https://127.0.0.1:8200" >> ~/.bashrc


export VAULT_TOKEN=""
export VAULT_ADDR='http://127.0.0.1:8200'
```

### Initialize vault to get the keys. Initialize and Unseal your Vault
```
vault operator init

vault operator unseal aUEvSKm/O9CQhQspwNFcHYuabF1uD1m7FpMmo7f5AVau
vault operator unseal EjLBTmuaeZgEl8kGWJIuJhhWYNVCLEEqKEA7I6i4FjpF
vault operator unseal tVSkHbcUqhLzOlKbwWWJkoLDPemZNoDWXrXbPIU3Zfad
```
### To check the status
```
vault status

```

### You can also access the vault UI on port 8200 of your vault server. Login with token root key which we created with init.
```
http://127.0.0.1:8200/ui/
http://127.0.0.1:8200/ui/
```
### To enable API access you will use the vault auth enable command
```

vault auth enable approle
Success! Enabled approle auth method at: approle/

# vault auth enable kubernetes
Success! Enabled kubernetes auth method at: kubernetes/

# vault auth enable userpass
Success! Enabled userpass auth method at: userpass/

# vault auth enable ldap
 Success! Enabled ldap auth met
 
```

### must enable the secrets feature
```
vault secrets enable -version=2 -path=secret kv
```

### test vault
```
vault auth list

vault secrets list

vault kv put secret/databases/db1 username=tainn

vault kv put secret/databases/db1 password=passw0rd

```
### Version 1: 
```
vault kv get -version=1 secret/databases/db1
vault kv get secret/databases/db1 

vault kv get -format=json secret/databases/db1

vault kv get -field=username  secret/databases/db1

vault kv delete secret/databases/db1

vault kv get secret/databases/db1
```
### Version 2: 
```
vault kv get -version=2 secret/databases/db1

Key metadata:
vault kv metadata get secret/databases/db1

Detele:
vault kv delete secret/databases/db1

Undeleted:
vault kv undelete -versions=2 secret/databases/db1

Destroying permanently:
vault kv destroy -versions=2 secret/databases/db1

Permanently delete all:
vault kv metadata delete secret/databases/db1
```

### Adding trusted root certificates to the server
```
Install the ca-certificates package: yum install ca-certificates
Enable the dynamic CA configuration feature: update-ca-trust force-enable
Add it as a new file to /etc/pki/ca-trust/source/anchors/: cp -r /opt/vault/tls/vault.tainn.local.crt /etc/pki/ca-trust/source/anchors/
Use command: update-ca-trust extract
/etc/pki/ca-trust/source/anchors/
update-ca-trust
```

### Noted: debug
```
curl -k -v https://127.0.0.1:8200/v1/sys/seal-status

curl -k --header "X-Vault-Token:$VAULT_TOKEN" https://127.0.0.1:8200/v1/sys/auth/approle
export VAULT_TOKEN=''

```
### CA
```
openssl genrsa -out ca.key 2048
openssl req -new -x509 -days 365 -key ca.key -subj "/C=CN/ST=GD/L=SZ/O=Acme, Inc./CN=Acme Root CA" -out ca.crt

openssl req -newkey rsa:2048 -nodes -keyout server.key -subj "/C=CN/ST=GD/L=SZ/O=Acme, Inc./CN=*.example.com" -out server.csr
openssl x509 -req -extfile <(printf "subjectAltName=DNS:example.com,DNS:www.example.com") -days 365 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt
```
### Issue 1: Solution export VAULT_TOKEN="s.Epg88vI8AayR2o7oNNohyS5Q", Initial Root Token: s.Epg88vI8AayR2o7oNNohyS5Q
```
Error enabling approle auth: Error making API request.

URL: POST http://127.0.0.1:8200/v1/sys/auth/approle
Code: 403. Errors:

* permission denied
```
# Reference:
```
https://learn.hashicorp.com/tutorials/vault/raft-storage
https://www.digitalonus.com/how-to-set-up-a-hashicorp-vault-cluster-in-15-minutes/
https://learn.hashicorp.com/tutorials/vault/ha-with-consul

```
