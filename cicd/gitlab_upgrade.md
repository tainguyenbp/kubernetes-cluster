```
Upgrade GitLab version 13.10.3 to GitLab version 13.12.15
https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/bionic/gitlab-ce_13.11.3-ce.0_amd64.deb
https://packages.gitlab.com/app/gitlab/gitlab-ce

gitlabCE upgrade version:

current version to 13.10.3: install package

sudo gitlab-ctl reconfigure
13.10.3 to 13.12.15: upgrade psql, install package
dpkg -i gitlab-ce_13.11.3-ce.0_amd64.deb
sudo gitlab-ctl reconfigure
13.12.15 to 14.0.12: upgrade psql, install package

sudo gitlab-ctl pg-upgrade
sudo gitlab-ctl reconfigure
14.0.12 to 14.3.6: install package

sudo gitlab-ctl reconfigure
if error, refer to https://forum.gitlab.com/t/500-error-and-internal-server-error/58918/15 to resolve
14.3.6 to 14.6.2: install package

sudo gitlab-ctl reconfigure
14.6.2 to 14.9.5: install package

sudo gitlab-ctl reconfigure
14.9.5 to 14.10.5: install package

sudo gitlab-ctl reconfigure
14.10.5 to 15.0.2: install package, upgrade psql

sudo gitlab-ctl reconfigure
sudo gitlab-ctl pg-upgrade -V 13
15.0.2 to 15.1.0: install package

sudo gitlab-ctl reconfigure
```
