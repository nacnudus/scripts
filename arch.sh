# To verify the torrent download, you need to import the key.
gpg --keyserver pgpkeys.mit.edu --recv-key 9741E8AC
gpg --verify archlinux-2015.08.01-dual.iso.sig

# Do the beginners' guide.

# If grub-install complains about EFI, then force it to use BIOS by specifying --target-i386-pc

# The wireless network device is called something like wlp2s0

# After following the beginners' guide, if it doesn't boot, then try this from 
# http://unix.stackexchange.com/a/152277/46012

# "I ran across the same issue just now, and found another workaround. Basically, it involves making the hosts /run directory available to the guest.

# First, we mount /run where it can be accessed by the guest. I will assume that your install partition is mounted at /mnt

mkdir /mnt/hostrun
mount --bind /run /mnt/hostrun

# Then, we chroot into the guest, and mount our host's /run/lvm in the guest's /run

arch-chroot /mnt /bin/bash
mkdir /run/lvm
mount --bind /hostrun/lvm /run/lvm

# You can then run grub-mkconfig and grub-install without any LVM errors. This also makes the commands behave if you are installing with LVM, for what it's worth.
# When done, remember to umount /run/lvm before exiting the chroot."



# Create a user
useradd -m -G wheel nacnudus
chfn nacnudus
passwd nacnudus

# Install sudo
pacman -S sudo
visudo
# add the line
nacnudus ALL=(ALL) ALL
exit
# login as nacnudus

# Allow colour in pacman
sudo vi /etc/pacman.conf
# and uncomment the 'Color' line

# Install virtualbox guest additions (if a guest in a virtualbox host)
sudo pacman -S virtualbox-guest-utils
# Choose the default mesa library at the prompt
sudo systemctl enable vboxservice

# Install X, i3, and gnome-terminal (TODO: video acceleration? mesa-vdpau and libva-mesa-driver)
sudo pacman -S xorg-server
# That doesn't seem to be necessary if you have already installed virtualbox
sudo pacman -S xorg-xinit
sudo pacman -S i3
# Accept all defaults
sudo pacman -S dmenu
sudo pacman -S gnome-terminal 
cp /etc/X11/xinit/xinitrc ~/.xinitrc 
# Comment out the lines from twm onwards, then add
exec i3
# Unless in virtualbox, in which case
# create ~/.xinitrc with the following lines
#! /bin/bash
/usr/sbin/VBoxClient-all
exec i3
# Accept all defaults
startx
# if the screen is tiny, do
xrandr 1024x768
# or some other mode listed by xrandr
# Make the changes in visudo suggested in ~/.i3/config

# Install python (note, python3 by default, otherwise use python2)
sudo pacman -S python python-virtualenv python-virtualenvwrapper python-pip python2 python2-pip
# Change the line in .zshrc to
source /usr/bin/virtualenvwrapper.sh

# Install zsh
sudo pacman -S zsh
chsh -l
chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# Link to the dotfiles version of .zshrc
mv .zshrc .zshrc~
ln -s dotfiles/.zshrc .zshrc

# mount ntfs
sudo pacman -S ntfs-3g

# battery life (conflicst with pm-utils)
# sudo pacman -S tlp
# sudo tlp start
# sudo systemctl enable tlp.service
# sudo systemctl enable tlp-sleep.service

# yaourt for unofficial packages
# commented lines don't seem to work, or be necessary
sudo pacman -S wget
wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
wget https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
tar xvf package-query.tar.gz
cd package-query
makepkg -sri
# sudo pacman -U package-query
tar xvf yaourt.tar.gz
cd yaourt
makepkg -sri
# sudo pacman -U yaourt

# install chruby
yaourt -S chruby
# Change the lines in zshrc to
source /usr/share/chruby/chruby.sh
source /usr/share/chruby/auto.sh

# Google Chrome
yaourt -S google-chrome
# I selected 6 for droid ttf
sudo pacman -S ttf-liberation
# Fix for no sound
sudo pacman -S pulseaudio-alsa

# Firefox
sudo pacman -S firefox

# git
sudo pacman -S git

# Vim
sudo pacman -S gvim
# This comes with dependencies for python2 and lua .  Plain vim doesn't come
# with clientserver support (no --servername argument for vim-R-plugin or atp),
# and while you could compile it yourself using the --with-x=yes flag, it's
# easier just to install gvim.  You can still do `vim` in the terminal, and you
# won't notice the difference.
# If there's a problem with missing help files or syntax, try reinstalling
# the vim-runtime package.
# Start vim, and do :PlugInstall
# Now you need fonts for powerline
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
# And restart the terminal

# Shared folders
sudo gpasswd -a $USER vboxsf
# now you find it in /media/sf_share

# Install R stats
sudo pacman -S tmux
yaourt -s gdal
yaourt -s openblas
# I chose option 3 aur/openblas
yaourt -s intel-mkl
sudo pacman -S r-mkl
ln -s dotfiles/.Rprofile .Rprofile
# Inside R
install.packages("devtools")
install.packages("setwidth")
devtools::install_github("jalvesaq/VimCom")
devtools::install_github("jalvesaq/colorout")
devtools::install_github("Data-Camp/Rdocumentation")
install.packages("rgdal")
# Rstudo
yaourt -S rstudio-desktop-bin
# RODBC
sudo pacman -S unixodbc
# in R
install.packages("RODBC")
# V8 (use version 3.15 because nothing works with newer ones)
yaourt -S v8-3.15 
# yaourt -S v8
# gem install libv8 
gem install libv8 -- --with-system-v8

# Install ag
sudo pacman -S the_silver_searcher

# Install TexLive for LaTeX
sudo mkdir -p /media/iso
sudo mkdir scripts 
sudo mount -t iso9660 -o ro,loop,noauto ~/installables/texlive2015-20150523.iso /media/iso
sudo /media/iso/install-tl --profile=~/scripts/texlive.profile
export PATH=$PATH:/usr/local/texlive/2015/bin/x86_64-linux
export MANPATH=$MANPATH:/usr/local/texlive/2015/texmf-dist/doc/man
export INFOPATH=$INFOPATH:/usr/local/texlive/2015/texmf-dist/doc/info
sudo umount /media/iso
sudo tlmgr option repository http://mirror.ctan.org/systems/texlive/tlnet
sudo tlmgr update --self
sudo tlmgr update --all
# and for atp-plugin, you need psutil from python
sudo pip install psutil

# Install bluetooth (No, don't! It interferes with wifi, apparently.)
# sudo pacman -S bluez bluez-utils
# sudo modprobe btusb
# sudo systemctl enable bluetooth.service
# Follow further instructions

# Install mouse
sudo pacman -S xf86-input-synaptics
sudo cp /usr/share/X11/xorg.conf.d/50-synaptics.conf /etc/X11/xorg.conf.d
# Edit the file and write with :w!! for sudo permissions, using settings
# suggested in the Arch wiki for synaptics.

# Install fonts
# Take your pick from ttf-anything
sudo pacman -S ttf-

# Dim backlight
sudo pacman -S xorg-xbacklight
sudo pacman -S xf86-video-intel
# Create file /etc/X11/xorg.conf.d/20-intel.conf with the following lines:
Section "Device"
        Identifier  "card0"
        Driver      "intel"
        Option      "Backlight"  "intel_backlight"
        BusID       "PCI:0:2:0"
EndSection


# Directory sizes
sudo pacman -S baobab

# Backups (back in time)
gpg --keyserver pgp.mit.edu --recv-key 944B4826
yaourt -S backintime
# Run with
sudo backintime-qt4

# xrandr
sudo pacman -S xorg-xrandr

# sound
sudo pacman -S alsa-utils
# Create ~/.asoundrc with the lines
defaults.ctl.card 1
defaults.pcm.card 1
# Check with
speaker-check

# vlc
sudo pacman -S vlc

# sleep and hibernate
sudo pacman -S pm-utils

# blacklist bluetooth to attempt to fix wifi drops
# create a file /etc/modprobe.d/bluetooth.conf
blacklist btusb
blacklist bluetooth

# Let arch devs know about your packages
sudo pacman -S pkgstats

# Virtualbox
sudo pacman -S virtualbox virtualbox-guest-utils net-tools
# Create the file /etc/modules-load.d/virtualbox.conf with the line
vboxdrv
vboxnetadp
vboxnetflt
vboxpci
# For usb sharing, use this:
sudo gpasswd -a $USER vboxusers
# For webcam etc.
yaourt -S virtualbox-ext-oracle

# Map alt-key to right-click context menu
sudo pacman -S xorg-xmodmap
# use sudo showkey to find the keycode
xmodmap -pke > ~/.Xmodmap # warning, wipes file if it exists!
vim ~/.Xmodmap # and do, e.g.
keycode 100 = Menu NoSymbol Menu
# in ~/.xinitrc add
if [ -f $HOME/.Xmodmap  ]; then
    /usr/bin/xmodmap $HOME/.Xmodmap
fi

# Calibre ebook library
sudo pacman -S calibre

# Temporary keyboard layout
setxkbmap dvorak
setxkbmap us

# Ranger file chooser
sudo pacman -S ranger

# Okular
sudo pacman -S kdegraphics-okular
# Selecting 2, 2 gave the smallest install size

# Tmux fancy stuff
# see separate tmux file

# # Powerline (must be python2 if vim is for python2)
# Too slow, generally
# yaourt -S python-powerline
# # sudo pip install powerline-git-status
# # For configuration, powerline_rooto is /usr/lib/python3.4/site-packages/powerline/config_files/
# sudo pacman -S python-psutil
# sudo pacman -S python-pygit2

# x_x (command-line xlsx) 
# Doesn't handle multiple worksheets yet.
# sudo pip install x_x 
# (doesn't support worksheets)

# Printer and scanner
yaourt -S cnijfilter-mp280
yaourt -S scangearmp-mp280
sudo pacman -S simple-scan
sudo gpasswd -a [username] sys
sudo pacman -S cups ghostscript cups-pdf libcups
systemctl enable cups
systemctl start cups
# browse http://localhost:631
# Administration
# Add printer

# gksu (includes gksudo)
sudo pacman -S gksu

# Swap orientation
sudo pacman -S xorg-xinput

# Citrix
# Directly from Citrix, but follow these intructions:
# https://bbs.archlinux.org/viewtopic.php?id=195998
#
# "Firstly, enable the multilib repository by uncommenting the [multilib]
# section in /etc/pacman.conf as mentioned on this wiki page:
# https://wiki.archlinux.org/index.php/Multilib.  Then update the package list
# and upgrade with pacman -Syu.
#
# "Follow mostly the steps under "Manual Install" on this wiki page:
# https://wiki.archlinux.org/index.php/Citrix.  On Step 0, the package
# lib32-libpng12 is no longer in the official repository (it's in AUR).  I skipped it and also
# the four AUR packages (lib32-libxp, lib32-libxpm, lib32-libxaw,
# lib32-openmotif).  No issue so far."
# Run as root:
cd /opt/Citrix/ICAClient/keystore/cacerts/
sudo cp /etc/ssl/certs/ca-certificates.crt .
sudo awk 'BEGIN {c=0;} /BEGIN CERT/{c++} { print > "cert." c ".pem"}' < ca-certificates.crt
# Use like this:
/opt/Citrix/ICAClient/wfica ~/Downloads/launch.jsp

# Playonlinux
sudo pacman -S playonlinux

# axel
sudo pacman -S axel

# unrar
sudo pacman -S unrar

# crashplan backup
yaourt -S crashplan
# sudo systemctl enable crashplan.service
systemctl start crashplan.service
CrashPlanDesktop
systemctl stop crashplan.service

# get_iplayer
yaourt -S get_iplayer
sudo pacman -S perl-xml-simple
sudo pacman -S rtmpdump

# music audio player
sudo pacman -S cmus
man cmus-tutorial

# Youtube downloader
sudo pacman -S youtube-dl

# To increase the volume, copy the file 'louder' in this directory to 
# /etc/asound.conf
# from http://alien.slackbook.org/blog/adding-an-alsa-software-pre-amp-to-fix-low-sound-levels/
# and reboot.  This adds a pre-amp bar to alsamixer.

# Scraperwiki
# Databaker
sudo pip2.7 install databaker
# pdftables

# test fans
sudo pacman -S lm_sensors
sudo pacman -S gnuplot

# Microsoft fonts
yaourt -S ttf-vista-fonts
yaourt -S ttf-ms-fonts

# Consider:
# scim (spreadsheet)
# csvkit (obvious)
# fbterm (frame-buffer terminal)
# patool (untar everything)
# w3m (browser) or netsurf

# TODO:
# Cairo

# Update everything
yaourt -Syua
