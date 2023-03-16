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

sudo mount /dev/sdc1 /mnt/tainn-sre02

sudo blkid

sudo vim /etc/fstab

UUID=33333333-3b3b-3c3c-3d3d-3e3e3e3e3e3e   /mnt/tainn-sre02   xfs   defaults,nofail   1   2

mount -a
umount /mnt/tainn-sre02

Some Linux kernels support TRIM/UNMAP operations to discard unused blocks on the disk. This feature is primarily useful in standard storage to inform Azure that deleted pages are no longer valid and can be discarded, and can save money if you create large files and then delete them.

There are two ways to enable TRIM support in your Linux VM. As usual, consult your distribution for the recommended approach:

Ubuntu
sudo apt-get install util-linux
sudo fstrim /mnt/tainn-sre02

RHEL/CentOS
sudo yum install util-linux
sudo fstrim /mnt/tainn-sre02

```

### 2. Set Up a NFS Server on Debian 10
```
sudo apt install nfs-kernel-server

chown nobody:nogroup /mnt/tainn-sre02
chmod 755 /mnt/tainn-sre02

vim /etc/exports
Add the following line:

/mnt/tainn-sre02   nfs-client-ip(rw,sync,no_subtree_check)
/mnt/tainn-sre02   nfs-client-ip(rw,sync,no_subtree_check)
```
# test
```
  461  fdisk -l /dev/sda
  462  lsblk
  463  fdisk -l /dev/sdc
  464  df -Th
  465  sudo resize2fs /dev/sdc1
  466  lsblk
  467  growpart /dev/sdc1
  468  resize2fs /dev/sdc1
  469  sudo resize2fs /dev/sdc1
  470  vgdisplay
  471  sudo parted /dev/sdc
  472  history
  473  fdisk /dev/sdc
  474  xfs_growfs /dev/sdc1
  475  df =h
  476  df -h
  477  vgdisplay
  478  lsblk
  479  lsblk -l
  480  lsblk -ll
  481  fdisk -l
  482  lvextend -l +100%FREE  /dev/sdc1
  483  xfs_growfs /dev/sdc1
  484  umount -a
  485  xfs_growfs /dev/sdc1
  486  mount -a
  487  xfs_growfs /dev/sdc1
  488  df -h
  489  df -Th
  490  mkfs.xfs /dev/sdc1
  491  df -h
  492  umount -a
  493  mkfs.xfs /dev/sdc1
  494  mount -a
  495  df -h
  496  df -h
  497  cd /lcs/crm
  498  docker-compose down
  499  docker-compose up -d
  500   fdisk /dev/sdc
  501  ll
  502  df -h
  503  xfs_growfs -d /dev/sdc1
  504  fdisk -l
  505  sudo fdisk /dev/sdc
  506  resize2fs /dev/sdc1
  507  sudo partprobe /dev/sdc1
  508  df -h
  509  sudo mkfs.xfs /dev/sdc1
  510  sudo parted /dev/sdc --script mklabel gpt mkpart xfspart xfs 0% 100%
  511  sudo apt-get install xfsprogs
  512  sudo parted /dev/sdc --script mklabel gpt mkpart xfspart xfs 0% 100%
  513  sudo parted /dev/sdc1 --script mklabel gpt mkpart xfspart xfs 0% 100%
  514  blkid
  515  sudo apt-get install xfsprogs
  516  growpart /dev/sdc 1
  517  df -h
  518  growpart /dev/sdc 1
  519  growpart /dev/sdc1
  520  fdisk -l
  521  resize2fs /dev/sdc1
  522  sudo fdisk /dev/sdc
  523  resize2fs /dev/sdc1
  524  sudo fdisk /dev/sdc
  525  df -h
  526  umount -a
  527  mount -a
  528  df -h
  529  sudo fstrim /srv/powerlaw-nfs01
  530  sudo resize2fs /dev/sdc1
  531  lsblk
  532  df -h
  533  lsblk
  534  gfdisk
  535  lsblk
  536  resize2fs /dev/sdc1
  537  growpart /dev/sdc 1
  538  sudo resize2fs /dev/sdc1
  539  sudo parted /dev/sdc --script mklabel gpt mkpart xfspart xfs 0% 100%
  540  sudo resize2fs /dev/sdc1
  541  df -Th
  542  sudo resize2fs /dev/sdc1
  543  xfs_growfs /dev/sdc1
```

### resize disk on azure
```
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda       8:0    0   64G  0 disk
|-sda1    8:1    0 63.9G  0 part /
|-sda14   8:14   0    3M  0 part
`-sda15   8:15   0  124M  0 part /boot/efi
sdb       8:16   0   32G  0 disk
`-sdb1    8:17   0   32G  0 part /mnt
sdc       8:32   0    3T  0 disk
`-sdc1    8:33   0    3T  0 part /srv/tainnsre-nfs01

growpart /dev/sdc 1
xfs_growfs /dev/sdc1
```
Port 111 (TCP and UDP) and 2049 (TCP and UDP) for the NFS server.

```
### 3. Set Up a minio
```
version: '3.9'

services:
  minio:
    container_name: minio
    command: server /data --console-address ":9001"
    environment:
      - MINIO_ROOT_USER=tainnsre
      - MINIO_ROOT_PASSWORD=N5QvGNaXXCbrPENM44ziXFMTsDy9XtWa
    image: quay.io/minio/minio:latest
    ports:
      - '9000:9000'
      - '9001:9001'
    volumes:
      - /data/minio:/data
    restart: unless-stopped
```
