```
 growpart /dev/xvda 1
+ Filesystem xfs

# xfs_growfs /dev/xvda1
+ Filesystem ext4/ext3

# resize2fs /dev/xvda1
```
```
loop7         7:7    0 67.8M  1 loop /snap/lxd/22753
loop8         7:8    0   47M  1 loop /snap/snapd/16292
loop9         7:9    0   47M  1 loop /snap/snapd/16010
nvme0n1     259:0    0  100G  0 disk
└─nvme0n1p1 259:1    0  100G  0 part /

# lsblk
# growpart /dev/nvme0n1 1
# lsblk
# resize2fs /dev/nvme0n1p1
```
