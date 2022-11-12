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


Port 111 (TCP and UDP) and 2049 (TCP and UDP) for the NFS server.

```
