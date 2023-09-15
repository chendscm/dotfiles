;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
 	     (gnu packages)
	     (gnu packages chromium)
	     (gnu packages compression)
	     (gnu services)
	     (gnu services base)
	     (gnu services networking)
	     (gnu system)
	     (gnu system locale)
	     (guix packages)
	     (nongnu packages linux)
	     (nongnu packages compression)
	     (nongnu system linux-initrd)
	     )
(use-package-modules docker fonts)
(use-service-modules cups desktop docker networking ssh xorg)

(operating-system
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list linux-firmware))

 (timezone "Asia/Shanghai")
 (keyboard-layout (keyboard-layout "us"))
 (host-name "gpd")

 (locale "en_US.utf8")
 (locale-definitions
  (cons* (locale-definition
	  (name "zh_CN.UTF-8")
	  (source "zh_CN"))
	 (locale-definition
	  (name "zh_CN.GB2312")
	  (source "zh_CN"))
	 (locale-definition
	  (name "zh_CN.GBK")
	  (source "zh_CN"))
	 (locale-definition
	  (name "zh_CN.GB18030")
	  (source "zh_CN"))
	 (locale-definition
	  (name "zh_CN.BIG5")
	  (source "zh_TW"))
	 (locale-definition
	  (name "zh_TW.UTF-8")
	  (source "zh_TW"))
	 %default-locale-definitions))

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "chend")
                  (comment "Chend")
                  (group "users")
                  (home-directory "/home/chend")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (list (specification->package "emacs")
                          (specification->package "emacs-exwm")
                          (specification->package
                           "emacs-desktop-environment")
                          (specification->package "nss-certs")
                          (specification->package "docker")
                          (specification->package "git")

			  ;; amdgpu
			  (specification->package "mesa")

			  ;; basic
			  (specification->package "cmake")
			  (specification->package "glibc-locales")
			  (specification->package "wmctrl")
			  ;(specification->package "libtool-bin")

			  ;; audio
			  (specification->package "alsa-utils")

			  ;; desktop
			  (specification->package "sway")
			  (specification->package "xrandr")

			  ;; net
	                  (specification->package "iwd")

			  ;; python
			  (specification->package "python")
			  ;; scheme
			  (specification->package "chez-scheme")

			  ;; Virtual
			  (specification->package "qemu")
			  
			  ;; browser
                          (specification->package "surf")
			  (specification->package "firefox")
			  ;; terminal
	                  (specification->package "st")
			  (specification->package "alacritty")
			  (specification->package "libvterm")
			  ;; desktop
			  (specification->package "sway")
			  (specification->package "swaylock")
			  (specification->package "swayidle")
			  (specification->package "swaybg")
			  (specification->package "waybar")
			  (specification->package "dmenu")
			  (specification->package "polkit")
			  ;;
			  (specification->package "dwl")
			  
			  ;;misc
	                  (specification->package "sdcv")

			  ;; compression
			  (specification->package "zip")
  			  (specification->package "unzip")
 			  (specification->package "pigz")
  			  (specification->package "unrar")
			  ;; bluetooth
  			  (specification->package "bluez")

			  ;; fcitx
			  (specification->package "fcitx5")
  			  (specification->package "fcitx5-gtk")
 			  (specification->package "fcitx5-qt")
  			  (specification->package "fcitx5-configtool")
  			  (specification->package "fcitx5-rime")
  			  (specification->package "librime")

			  ;; fonts
			  (specification->package "fontconfig")
			  (specification->package "font-wqy-zenhei")
			  (specification->package "font-wqy-microhei")
			  )
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list

                 ;; To configure OpenSSH, pass an 'openssh-configuration'
                 ;; record as a second argument to 'service' below.
                 (service openssh-service-type)
                 (service cups-service-type)
		 (service docker-service-type)
		 (service bluetooth-service-type)
                 (set-xorg-configuration
                  (xorg-configuration (keyboard-layout keyboard-layout))))

           ;; This is the default list of services we
           ;; are appending to.
           %desktop-services)

;   (modify-services %desktop-services
;		    (guix-service-type
;		     config => (guix-configuration
;				(inherit config)
;				(substitute-urls '("https://mirror.sjtu.edu.cn/guix/"
;						   "https://ci.guix.gnu.org")))))
   )

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (swap-devices (list (swap-space
                        (target (uuid
                                 "464b6986-cb0e-4e77-a0e5-6bacc5270e04")))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device (uuid
                                  "fdf4930d-bfcd-44d2-a3aa-473c04e08507"
                                  'btrfs))
                         (type "btrfs"))
                       (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "CABE-D7C2"
                                       'fat32))
                         (type "vfat")) %base-file-systems)))
