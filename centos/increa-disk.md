How to Increase the size of a Linux LVM by expanding the virtual machine disk


###  https://www.rootusers.com/how-to-increase-the-size-of-a-linux-lvm-by-expanding-the-virtual-machine-disk/

VM với Disk 20G cần tăng lên Disk 30G: thực hiện tunr off và tăng size của disk lên 30G sau đó thực hiện bước sau để centos nhận đủ 30G:

1. hiển thị thông tin hiện tại 
fdisk -l 
df -h 

2. edit vm setting để tăng disk size
3. chạy lệnh sau để scan các new disk space hoặc reboot máy

echo "- - -" > /sys/class/scsi_host/host0/scan


4. thực hienj phân vùng cho disk space mới vừa tăng

fdisk /dev/sda

==> nhần n để show all menu 
==> sau đó chọn p : để tạo primary partition 

tiếp đến chọn Partition number: ví dụ đã có sda2 thì chọn partition number tiếp theo là 3


sau đó để join partition mới này vào  Linux LVM ta chọn 8e 
==> sau đó chọn w dể write những thay đổi 

tiếp theo reboot hoặc chạy lệnh sau để máy nhận partition mới 
partx -a /dev/sda3



===> một new partition đã được tạo tương ứng với unallocated disk space của VM


5. Tăng  logical volume --> để OS nhận đúng size 

- tạo physical volume từ new partition vừa tạo: 

pvcreate /dev/sda3

--> nếu báo not found thì reboot 

- show các volume group :

vgdisplay

--> để ý VG Name: giả sử VG Name="Volume_Group"


==> thực hiện add physical volume /dev/sda3 vào Volume GRoup ở trên 

 vgextend Volume_Group /dev/sda3


 ==>   Volume group "Mega" successfully extended   = OK


 - scan all disks for physical volumes: 

 pvscan


- hiện thị logical volume : lvdisplay


--> thực hiện extended logical volume bằng câu lệnh :

lvextend /dev/Volume_Group/root /dev/sda3

lúc này logical volume root sẽ tăng thêm một size = size của sda3



Cuối cùng thực hiện resize the file system qua câu lệnh : 

resize2fs /dev/Volume_Group/root



==> sử dụng lại các lệnh  df, fdisk để thấy sự thay đổi: 
fdisk -l 
df -h 
