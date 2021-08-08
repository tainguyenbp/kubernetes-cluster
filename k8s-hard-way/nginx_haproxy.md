# kubernetes the hard way ubuntu 
### LoadBlancer Kube API Server - Master Node
### Install Nginx proxy
```
apt-get install -y nginx

```

```
echo " 
stream{
  upstream kubernetes {
      server 192.168.1.10:6443;
  }
  server {
      listen 6443;
      proxy_pass kubernetes;
  }
}
" >> /etc/nginx/nginx.conf

```

```
systemctl enable --now nginx
systemctl status nginx

```

```
curl  https://192.168.1.14:6443/version -k

```
### Install HAproxy
```
sudo apt-get update && sudo apt-get install -y haproxy

```

```
cat <<EOF | sudo tee /etc/haproxy/haproxy.cfg 
frontend kubernetes
    bind 192.128.1.14:6443
    option tcplog
    mode tcp
    default_backend kubernetes-master-nodes

backend kubernetes-master-nodes
    mode tcp
    balance roundrobin
    option tcp-check
    server master01 192.168.1.10:6443 check fall 3 rise 2
EOF

```

```
systemctl enable --now haproxy
systemctl status haproxy

```

```
curl  https://192.168.1.14:6443/version -k

```
