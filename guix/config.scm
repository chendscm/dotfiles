;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
 	     (gnu packages)
	     (gnu packages compression)
	     (gnu services)
	     (gnu services base)
	     (gnu services networking)
	     (gnu system)
	     (gnu system locale)
	     (guix packages)
	     (nongnu packages linux)
	     (nongnu packages compression)
	     (nongnu system linux-initrd))
(use-package-modules docker fonts)
(use-service-modules cups desktop docker networking
		     pm ssh xorg)

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
                (supplementary-groups '("wheel" "netdev" "audio" "video" "kvm")))
               %base-user-accounts))

 ;; Packages installed system-wide.  Users can also install packages
 ;; under their own account: use 'guix search KEYWORD' to search
 ;; for packages and 'guix install PACKAGE' to install a package.
 (packages
  (append
   (map specification->package
	'(
	  ;; system
	  "mesa" "xrandr"
	  "iwd"
	  "nss-certs" "glibc-locales" "wmctrl"
	  "bluez"
	  "jq" 				; eaf-install deps
	  ;; audio
	  "alsa-utils"
	  ;; basic tools
	  "make"
	  "docker" "git" "aria2"
          ;; fonts
	  "font-gnu-unifont"
	  "fontconfig" "font-wqy-zenhei" "font-wqy-microhei"
	  ;; desktop
	  "sway" "swaylock" "swayidle" "swaybg"
	  "waybar" "dmenu" "polkit"
	  ;; input
	  "fcitx5" "fcitx5-gtk" "fcitx5-qt" "fcitx5-configtool"
	  "fcitx5-rime" "librime"
	  "ibus" "ibus-rime" "dconf"
	  ;; emacs
	  "emacs"
	  ;; "emacs-exwm" "emacs-desktop-environment" "emacs-vterm"
	  ;; python
	  "python" "python-ipython"
	  ;; scheme
	  "chez-scheme"
	  ;; Virtual
	  "qemu"
	  ;; browser
	  "surf" "firefox"
	  ;; terminal
	  "st" "alacritty" "libvterm"
	  ;; compression
	  "zip" "unzip" "pigz" "unrar"
	  ;; misc apps
	  "sdcv"
	  ;; laptop
	  "tlp"
	  ))
   %base-packages))

 (services
  (cons*
   (service openssh-service-type)
   (service cups-service-type)
   (service docker-service-type)
   (service bluetooth-service-type)
   (service tlp-service-type
	    (tlp-configuration
	     (cpu-scaling-governor-on-ac (list "performance"))
	     (sched-powersave-on-bat? #t)))
   (set-xorg-configuration
    (xorg-configuration (keyboard-layout keyboard-layout)))
   (modify-services %desktop-services
		    (guix-service-type
		     config => (guix-configuration
				(inherit config)
				(substitute-urls '("https://mirror.sjtu.edu.cn/guix/"
						   "https://ci.guix.gnu.org"))))
		    (gdm-service-type
		     config => (gdm-configuration
				(inherit config)
				(wayland? #t))))
   ))

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
