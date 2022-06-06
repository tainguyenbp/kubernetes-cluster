# Remove /home partition and merge to / Centos 7 LVM Volume

Backup /home
```
mkdir /tmp/home.bk
cp -a /home /tmp/home.bk
```
Unmount /home
```
umount -fl /home
```
Check LVM Volume
```
lvs
lvdisplay
vgdisplay
```
Remove home volume
```
lvremove /dev/centos/home
```
Noter erro:  Logical volume centos/home contains a filesystem in use. You have to use console VM
Extend root volume
```
lvextend -L+100%FREE /dev/centos/root
lvextend -l +100%FREE /dev/centos/root
lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
resize2fs /dev/ubuntu-vg/ubuntu-lv
```
Resize the partition 
```
xfs_growfs /dev/centos/root
dracut --regenerate-all --force
```
merge the partition lvm
```
https://gist.github.com/rafaeltuelho/1af483cb37e74889e3ff
```

