# Install vault
### Step 1. 
```
sudo mkdir -p /opt/vault/{logs,bin,data}

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

### Step 1. vim /etc/vault/config.json
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
