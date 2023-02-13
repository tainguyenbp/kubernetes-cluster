```
gitlab:

current version to 13.12.15: install package

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

Upgrade GitLab version 13.2.1 to GitLab version 13.11.3
https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/bionic/gitlab-ce_13.11.3-ce.0_amd64.deb

1. Tải package version 13.11.3: gitlab-ce_13.11.3-ce.0_amd64.deb

2. Upgrade package: dpkg -i gitlab-ce_13.11.3-ce.0_amd64.deb

3. Run command: sudo gitlab-ctl reconfigure

4. Check version: 

cat /opt/gitlab/version-manifest.txt |grep gitlab-ce|awk '{print $2}'
sudo gitlab-rake gitlab:env:info
=> Kiểm tra upgrade GitLabCE version 13.11.3

Upgrade GitLab version 13.11.3 to GitLab version 14.6.x
Take a backup of your data folder or snapshot
upgrade to 13.12.15-ce (the last minor of your current major release)
https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/bionic/gitlab-ce_13.12.15-ce.0_amd64.deb
dpkg -i gitlab-ce_13.12.15-ce.0_amd64.deb
sudo gitlab-ctl reconfigure
upgrade to 14.0.12-ce (the first minor of the new major release)
https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/bionic/gitlab-ce_14.0.12-ce.0_amd64.deb
sudo gitlab-ctl pg-upgrade
dpkg -i gitlab-ce_14.0.12-ce.0_amd64.deb
sudo gitlab-ctl reconfigure
upgrade to 14.6.x-ce (your target, i.e. the last minor of the new major release
https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/bionic/gitlab-ce_14.6.7-ce.0_amd64.deb
dpkg -i
sudo gitlab-ctl reconfigure


wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/focal/gitlab-ce_14.0.12-ce.0_amd64.deb/download.deb


wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/focal/gitlab-ce_14.3.6-ce.0_amd64.deb/download.deb


https://packages.gitlab.com/app/gitlab/gitlab-ce


https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/focal/gitlab-ce_15.1.3-ce.0_amd64.deb


15.1.3 -> 15.1.6 => 15.2.5 => 15.3.5 => 15.4.6 => 15.5.9 => 15.6.7 => 15.7.6 => 15.8.1

wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/focal/gitlab-ce_15.1.6-ce.0_amd64.deb/download.deb

wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/focal/gitlab-ce_15.2.5-ce.0_amd64.deb/download.deb

wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/focal/gitlab-ce_15.3.5-ce.0_amd64.deb/download.deb

wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/focal/gitlab-ce_15.4.6-ce.0_amd64.deb/download.deb

wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/focal/gitlab-ce_15.5.9-ce.0_amd64.deb/download.deb

wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/focal/gitlab-ce_15.6.7-ce.0_amd64.deb/download.deb

wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/focal/gitlab-ce_15.7.6-ce.0_amd64.deb/download.deb

wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/focal/gitlab-ce_15.8.1-ce.0_amd64.deb/download.deb



```
