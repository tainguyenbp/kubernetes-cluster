### increase disk type disk more than 2Tb
```

sudo yum -y install cloud-utils-growpart gdisk

sudo parted -l /dev/sdb

sudo sfdisk -l /dev/sdb

sudo partprobe /dev/sdb

growpart /dev/sdb 1

sudo xfs_growfs /storage

```
### skill reboot server
```
reboot
```
