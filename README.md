# DISCLAIMER
-main.sh is meant to set up an arch linux vm on a linux host. This is not required to install arch linux using a script.  
-install.sh will install arch linux to a virtual machine, or to a host.  
-install.sh will only work with an empty GPT drive, if you have used the drive in the past, format it to gpt before running the script.  
-the install script will format and install onto /dev/sda by default, with a 512M efi partition, and the remainder as a linux filesystem on sda2. Adapt the script accordingly.
-Network connection is required before running install.sh. 
# Prerequisites  
-A working virtualbox (you should be able to launch VMs with no problem  
-The arch linux installation ISO - available from the archlinux.org  
-Virtualbox guest additions ISO  
-Virtualbox extension pack  
-Enough storage to install arch linux  
  
# Virtualbox instructions
On host system, start virtualbox  
  
Run main.sh script (through the terminall) ex. `/bin/bash main.sh`  
  
follow the prompts  
  
When specifying ISO locations, you must specify the entire path ex. `/home/ethannij/Desktop/ArchInstallation/GuestAdditions.iso`  
# Installation instructions  
When the arch linux installation starts type the following in the commandline of the guest -  
  
`curl -o- https://raw.githubusercontent.com/ethannij/Arch-Installer/master/install.sh type | 
bash`  
  
When the installion is complete, reboot the system.  
username: root  
password: root  
  
If the username or password do not work upon boot, you may have to set it manually from the arch live cd  

# After Installation  
Upon system startup, type:  
`$ systemctl start NetworkManager.service` and  
`$ systemctl enable NetworkManager.service`  
Congratulations you now have an arch linux virtual machine in less than 5 minutes.

# Notes  
/etc/hostname is set to "host" by default.

/etc/hosts includes: ```127.0.0.1 localhost  
::1 localhost  
127.0.1.1 host```
