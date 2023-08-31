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
	     (gnu services)
	     (gnu services base)
	     (gnu services networking)
	     (nongnu packages linux)
	     (nongnu system linux-initrd)
	     )
(use-service-modules cups desktop networking ssh xorg)

(define substitute-urls
  (list "https://mirror.sjtu.edu.cn/guix/"
	"https://ci.guix.gnu.org"))

(operating-system
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list linux-firmware))
 
  (locale "en_HK.utf8")
  (timezone "Asia/Shanghai")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "gpd")

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
	                  (specification->package "alacritty")
			  ;; net
	                  (specification->package "iwd")
			  ;; apps
;			  (sepcification->package "ungoogled-chromium")
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
;		 (service docker-service-type)
                 (set-xorg-configuration
                  (xorg-configuration (keyboard-layout keyboard-layout))))

           ;; This is the default list of services we
           ;; are appending to.
           %desktop-services)
   )
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (swap-devices (list (swap-space
                        (target (uuid
                                 "3681f1b0-8265-4a17-b065-69d4181fdfa1")))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device (uuid
                                  "b0491151-d18c-4104-8f5b-5d53e8386c81"
                                  'btrfs))
                         (type "btrfs"))
                       (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "C56E-953B"
                                       'fat32))
                         (type "vfat")) %base-file-systems)))
