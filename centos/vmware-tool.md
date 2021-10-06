# How To Install Vmware Tools On Linux
#  Guest > Install/Upgrade VMware Tools.
mkdir /mnt/cdrom
mount /dev/cdrom /mnt/cdrom
cp /mnt/cdrom/VMwareTools-version.tar.gz /tmp/
cd /tmp tar -zxvf VMwareTools-version.tar.gz
cd vmware-tools-distrib ./vmware-install.pl
