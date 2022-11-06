### 1. start rancher ui with docker compose
```
version: '3'

services:
  rancher-ui:
    image: rancher/rancher:v2.7-head
    restart: always
    container_name: rancher-ui
    ports:
    - "80:80/tcp"
    - "443:443/tcp"
    volumes:
    - "rancher-data:/var/lib/rancher"
    privileged: true

volumes:
  rancher-data
```
