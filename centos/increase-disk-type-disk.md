### increase disk type disk more than 2Tb
```

[root@srv-tainnsre ~]# lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
fd0               2:0    1    4K  0 disk
sda               8:0    0  150G  0 disk
|-sda1            8:1    0    1G  0 part /boot
`-sda2            8:2    0  149G  0 part
  |-centos-root 253:0    0   50G  0 lvm  /
  |-centos-swap 253:1    0  7.9G  0 lvm  [SWAP]
  `-centos-home 253:2    0 91.1G  0 lvm  /home
sdb               8:16   0    4T  0 disk /storage
sr0              11:0    1 1024M  0 rom

echo 1 > /sys/block/sda/device/rescan

sudo fdisk -l /dev/sdb

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
