BASEDIR := $(shell pwd)

create: 
	qemu-img create -f qcow2 endeavouros.qcow2 150G

install:
	qemu-system-x86_64 \
	-cdrom /home/chend/data/iso/Endeavouros_Cassini_Nova-03-2023_R3.iso \
	-boot order=d \
	-accel kvm \
	-smp 4 \
	-m 8G \
	-machine usb=on -device usb-tablet \
	-drive file=/home/chend/git/dotfiles/qemu-vm/endeavouros/endeavouros.qcow2,format=qcow2

run:
	qemu-system-x86_64 \
	-accel kvm \
	-smp 4  \
	-m 8G \
	-vga qxl \
	-machine usb=on -device usb-tablet \
	-nic user,hostfwd=tcp::60022-:22 \
	/home/chend/git/dotfiles/qemu-vm/endeavouros/endeavouros.qcow2

.PHONY: create install run
