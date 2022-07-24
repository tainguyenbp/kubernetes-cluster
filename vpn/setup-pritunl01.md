### 1. Setup Pritunl
```
apt-get update -y
apt-get install curl gnupg2 wget unzip -y
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv E162F504A20CDF15827F718D4B7C549A058F8B6B
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
echo "deb http://repo.pritunl.com/stable/apt focal main" | tee /etc/apt/sources.list.d/pritunl.list
apt-get update -y
apt-get install pritunl -y
systemctl start pritunl
systemctl enable pritunl
systemctl status pritunl
ss -antpl | grep pritunl

```
### 2. Open limmit
```
sudo sh -c 'echo "* hard nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "* soft nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "root hard nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "root soft nofile 64000" >> /etc/security/limits.conf'
```
### 3. Setup MongoDB
```
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list

curl -fsSL https://www.mongodb.org/static/pgp/server-5.0.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/mongodb-5.gpg
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7AE645C0CF8E292A
sudo apt update

apt-get update -y
apt-get install mongodb-server -y
systemctl start mongodb
systemctl enable mongodb
systemctl status mongodb
ss -antpl | grep 27017
pritunl setup-key
pritunl setup-key

```
### 3. Setup Pritunl client
```
sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt $(lsb_release -cs) main
EOF

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7AE645C0CF8E292A
sudo apt update
sudo apt install pritunl-client-electron
```
