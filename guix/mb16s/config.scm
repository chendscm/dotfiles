;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
	     (gnu services docker)
	     (gnu services pm)
	     (gnu services syncthing)
             (nongnu packages linux)
             (nongnu packages compression)
             (nongnu system linux-initrd))
(use-service-modules cups desktop networking ssh xorg)

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware sof-firmware))

  (locale "en_HK.utf8")
  (timezone "Asia/Shanghai")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "MB16s")

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
	   "intel-microcode"
	   "xf86-video-intel" "xf86-video-amdgpu"
	   "xorg-server-xwayland"
	   "make"
	   "tlp"
	   "bluez" "brightnessctl" "playerctl"
	   ;; alsa
	   "alsa-utils"
	   ;; fonts
	   "fontconfig" "font-gnu-unifont" "font-wqy-zenhei" "font-wqy-microhei"
	   ;; fcitx
	   "fcitx5" "fcitx5-gtk" "fcitx5-qt" "fcitx5-configtool"
	   "fcitx5-rime" "librime"
	   "dconf"
	   ;; tools
	   "git" "docker"
	   "zip" "unzip"
	   ;; edit
	   "emacs" "vim"
	   "emacs-exwm" "emacs-desktop-environment"
	   ;; sway
	   "sway" "swaylock" "swayidle" "swaybg" "waybar"
	   "wmenu" "polkit" "dconf-editor" "dmenu"
	   ;; terminal
	   "st" "alacritty"
	   ;; develop
	   "python" "python-ipython"
	   "python-numpy" "python-pandas" "python-dateutils"
	   "python-scipy"
	   ;; virtual
	   "qemu"
	   ;; browser
	   "torbrowser" "google-chrome-stable" "firefox" "ungoogled-chromium-wayland"
	   ))
    %base-packages))

  
  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (cons*
    (service openssh-service-type)
    (service cups-service-type)
    (service bluetooth-service-type)
    (service docker-service-type)
    (service tlp-service-type
	     (tlp-configuration
	      (cpu-scaling-governor-on-ac (list "performance"))
	      (sched-powersave-on-bat? #t)))
    (service syncthing-service-type
	     (syncthing-configuration (user "chend")))
    (service screen-locker-service-type
	     (screen-locker-configuration
	      (name "swaylock")
	      (program (file-append (specification->package "swaylock")
				    "/bin/swaylock"))
	      (allow-empty-password? #f)
	      (using-pam? #t)
	      (using-setuid? #f)))

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

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device (uuid
                                  "4b9d7958-3d39-4949-86d0-ca43c960ce0d"
                                  'ext4))
                         (type "ext4"))
                       (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "3E64-8F9A"
                                       'fat32))
                         (type "vfat")) %base-file-systems)))
