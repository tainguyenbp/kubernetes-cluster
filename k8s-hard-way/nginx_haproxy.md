# kubernetes the hard way ubuntu 
### LoadBlancer Kube API Server - Master Node

```
yum install -y nginx

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
curl  https://192.168.1.10:6443/version -k

```
