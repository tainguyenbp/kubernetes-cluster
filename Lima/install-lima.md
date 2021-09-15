### install lima macos
```
brew install lima
```
### Start Lima macos
```
limactl start
lima uname -a
```
### Use lima nerdctl build and run a container
```
mkdir -p ~/lima/
```
### touch ~/lima/Dockerfile
```
FROM nginx
RUN  echo "hello tainn" > /usr/share/nginx/html/index.html
```

### build lima
```
lima nerdctl build -t lima-tainn:v1.0 ~/lima
lima nerdctl run -d -p 127.0.0.1:8080:80 lima-tainn:v1.0
```

### Run nginx container inside Lima VM
```
lima nerdctl run -d --name nginx -p 127.0.0.1:8080:80 nginx:alpine

curl -I http://localhost:8080
```

#### Use alias docker for lima nerdctl:
```
lima nerdctl ps
alias docker="lima nerdctl"
docker ps
```
