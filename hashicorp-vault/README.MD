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
  tls_cert_file = "/opt/vault/tls/vautl.tainn.local.crt"
  tls_key_file  = "/opt/vault/tls/vautl.tainn.local.key"
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
```

### Initialize vault to get the keys.
```
vault operator init
```
### You can also access the vault UI on port 8200 of your vault server. Login with token root key which we created with init.
```
http://127.0.0.1:8200/ui/
http://127.0.0.1:8200/ui/
```

# Reference:
```
https://learn.hashicorp.com/tutorials/vault/raft-storage
https://www.digitalonus.com/how-to-set-up-a-hashicorp-vault-cluster-in-15-minutes/
https://learn.hashicorp.com/tutorials/vault/ha-with-consul

```
