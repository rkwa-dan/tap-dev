#!/bin/bash

yum -y install nvme-cli lvm2

fdisk /dev/nvme1n1 << EOF
n
p
1


t
8e
w

EOF 

pvcreate /dev/nvme1n1p1
vgcreate cmc-vg /dev/nvme1n1p1
lvcreate -l 100%FREE -n lv cmc-vg
mkfs /dev/cmc-vg/lv
mkdir -p /opt/cmc/vol
echo "/dev/cmc-vg/lv /opt/cmc/vol ext4 defaults 0 2" >> /etc/fstab
mount /dev/cmc-vg/lv
