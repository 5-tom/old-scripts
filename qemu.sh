#!/bin/bash
set -e
cd $HOME

sudo apt install -y bridge-utils qemu-system vde2 virt-manager virt-viewer
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
sudo sed -i 's/#unix_sock_group/unix_sock_group/' /etc/libvirt/libvirtd.conf
sudo sed -i 's/#unix_sock_ro_perms/unix_sock_ro_perms/' /etc/libvirt/libvirtd.conf
sudo sed -i 's/#unix_sock_rw_perms/unix_sock_rw_perms/' /etc/libvirt/libvirtd.conf
sudo adduser tom libvirt
sudo systemctl restart libvirtd
