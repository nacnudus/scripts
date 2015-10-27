sudo cp /etc/samba/smb.conf.default /etc/samba/smb.conf
# And change the workgroup to WORKGROUP for Windows

# Mount shared folder on Windows guest
sudo systemctl stop nmbd.service
sudo systemctl stop smbd.service
sudo systemctl start nmbd.service
sudo systemctl start smbd.service

# # Once-off
# sudo useradd samba
# sudo pdbedit -a -u samba
# # To change the password
# smbpasswd samba

# Check config
testparm -s

# Set Windows guest to use a host-only network.
# Use ipconfig in the Windows command line to find the ip address
# Share the folder
# Turn off password-protected sharing

# Find shares
# sudo pacman -S nmap
nmblookup -A 192.168.56.101 
smbclient -L \\DESKTOP-ETEMMPD -U nacnu%thepassword
smbclient -L \\DESKTOP-ETEMMPD -U mbie%mbie

# Mount shared MBIE flash drive (alias 'mbie' in .zshrc)
sudo mount -t cifs //192.168.56.101/h /home/nacnudus/winshare -o user=mbie,password=mbie,rw,gid=1000,uid=1000

# Mount Windows C drive
sudo mount -t cifs //192.168.56.101/c /home/nacnudus/windows -o user=nacnu,rw,gid=1000,uid=1000

