BASEDIR := $(shell pwd)

create: 
	qemu-img create -f qcow2 win10.qcow2 100G

install:
	qemu-system-x86_64 \
	-cdrom /home/chend/data/iso/cn_windows_10_business_editions_version_1909_updated_jan_2020_x64_dvd_b3e1f3a6.iso \
	-boot order=d \
	-accel kvm \
	-smp 4 \
	-m 8G \
	-machine usb=on -device usb-tablet \
	-drive file=/home/chend/git/dotfiles/qemu-vm/win10/win10.qcow2,format=qcow2

run:
	qemu-system-x86_64 \
	-accel kvm \
	-smp 4  \
	-m 8G \
	-vga std \
	-machine usb=on -device usb-tablet \
	-nic user,hostfwd=tcp::60022-:22 \
	/home/chend/git/dotfiles/qemu-vm/win10/win10.qcow2

.PHONY: create install run
