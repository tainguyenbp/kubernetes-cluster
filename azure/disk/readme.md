###1. Create or extend disk for azure disk
```
root@vm-tainn-sre01:/home/tainnsre# lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda       8:0    0   30G  0 disk
|-sda1    8:1    0 29.9G  0 part /
|-sda14   8:14   0    3M  0 part
`-sda15   8:15   0  124M  0 part /boot/efi
sdb       8:16   0    8G  0 disk
`-sdb1    8:17   0    8G  0 part /mnt
sdc       8:32   0    1T  0 disk
root@vm-tainn-sre01:/home/tainnsre#

sudo apt-get install xfsprogs

sudo parted /dev/sdc --script mklabel gpt mkpart xfspart xfs 0% 100%

sudo mkfs.xfs /dev/sdc1

sudo partprobe /dev/sdc1

mkdir -p /mnt/tainn-sre02

```
