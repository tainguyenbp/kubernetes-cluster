### Install java
```
sudo yum install java-1.8.0-openjdk-devel
```

### Install java
```
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
```

### add the repository
```
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key

```

### install the latest stable version of Jenkins by typing:
```
sudo yum install jenkins
```

### Start jenkin
```
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins
```

### Allow firewalld jenkin
```
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --reload
```

### get password
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### access jenkins
```
http://your_ip_or_domain:8080
```
