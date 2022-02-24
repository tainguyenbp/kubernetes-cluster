### Development installation
```
Run sudo sysctl -w vm.max_map_count=262144
To make it permanent, modify the variable in /etc/sysctl.conf
```

### Line endings
```
git config --global core.autocrlf input
```
### Add all line to file vim ~/.bashrc 
```
export MINDSROOT=/path/to/minds

alias minds=$MINDSROOT/local/local
alias minds-front-build=$MINDSROOT/local/front-build
alias minds-ssr-build=$MINDSROOT/local/ssr-build
alias minds-ssr-serve=$MINDSROOT/local/ssr-serve
```
### vim /etc/sysctl.conf
```
net.ipv4.ip_forward=1
systemctl restart network
sysctl net.ipv4.ip_forward
```
### create minds dicrectory 
```
mkdir -p /home/minds
```
###  Clone repository Minds and build
```
cd /home/minds
git clone --recurse-submodules --remote-submodules https://gitlab.com/minds/minds.git
cd minds 
git checkout master
docker-compose up --build 
```
