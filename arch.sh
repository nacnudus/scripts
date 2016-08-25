# To verify the torrent download, you need to import the key.
gpg --keyserver pgpkeys.mit.edu --recv-key 9741E8AC
gpg --verify archlinux-2015.08.01-dual.iso.sig

# Do the beginners' guide.

# If grub-install complains about EFI, then force it to use BIOS by specifying --target=i386-pc

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

# # Auto-connect to wifi and ethernet
# I'm pretty sure we do need to copy a template from /etc/netctl/examples
sudo cp /etc/netctl/examples/ethernet-dhcp /etc/netctl/eno1
# And then change the interface name in the file to 'eno1'.
# This delays boot:
# sudo systemctl enable dhcpcd@eno1.service
sudo pacman -S wpa_actiond
sudo systemctl enable netctl-auto@wlp2s0.service
# Do we need?
sudo pacman -S ifplugd
sudo systemctl enable netctl-ifplugd@eno1.service

# # For wifi, I now (no longer) follow the instructions on the Arch wiki for wicd
# sudo pacman -S wicd
# sudo systemctl stop and disable all net* services
# sudo systemctl enable wicd
# sudo systemctl start wicd
# gpasswd -a nacnudus users
# wicd-curses

# Allow colour in pacman
sudo vi /etc/pacman.conf
# and uncomment the 'Color' line
Color=auto

# Install virtualbox guest additions (if a guest in a virtualbox host)
sudo pacman -S virtualbox-guest-utils
# Choose the default mesa library at the prompt
sudo systemctl enable vboxservice

# Android file transfer
# sudo pacman -S libmtp ?? Necessary?
sudo pacman -S android-file-transfer
# Then aft-mtp-mount ~/android
# Unmount with fusermount -u ~/android

# Install X, i3, and gnome-terminal (TODO: video acceleration? mesa-vdpau and libva-mesa-driver)
sudo pacman -S xorg-server
# That doesn't seem to be necessary if you have already installed virtualbox
sudo pacman -S xorg-xinit
sudo pacman -S i3
# Accept all defaults
sudo pacman -S dmenu
sudo pacman -S gnome-terminal 
cp /etc/X11/xinit/xinitrc ~/.xinitrc 
# If you want .Xresources to work, then you also need to do
sudo pacman -S xorg-xrdb
# But it doesn't work, so to set the desktop background, you need this for the
# command in .i3/config
sudo pacman -S xorg-xsetroot
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
# If output doesn't appear in the terminal immediately, try putting/changing
Section "Device"
        Option      "AccelMethod" "uxa"
EndSection
# in /etc/X11/xorg.conf.d/20-intel.conf

# Install python (note, python3 by default, otherwise use python2)
sudo pacman -S python python-virtualenv python-virtualenvwrapper python-pip python2 python2-pip ipython ipython2
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

# Enable the multilib repository by uncommenting the [multilib]
# section in /etc/pacman.conf as mentioned on this wiki page:
# https://wiki.archlinux.org/index.php/Multilib.  Then update the package list
# and upgrade with pacman -Syu.

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

# install ruby, gems and chruby
sudo pacman -S ruby
yaourt -S chruby
# Change the lines in zshrc to
source /usr/share/chruby/chruby.sh
source /usr/share/chruby/auto.sh

# Google Chrome
yaourt -S google-chrome
# I selected 6 for droid ttf
sudo pacman -S ttf-liberation
# For java, you need icedtea-web
sudo pacman -S icedtea-web

# Firefox
sudo pacman -S firefox

# Limit journal directory size
# Edit /etc/systemd/journald.conf
# Uncomment SystemMaxUse and set it equal to 16M
# From time to time check for corrupted files hanging around, and vacuum
sudo systemctl --vacuum-size=16M

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

# NeoVim
sudo pacman -S neovim python2-neovim python-neovim xclip
# In R
devtools::install_github("jalvesaq/nvimcom")
# For clang completion
sudo pacman -S clang
cd ~/Downloads
git clone https://github.com/Rip-Rip/clang_complete
cd clang_complete
# Edit the makefile to use nvim instead of vim
sudo make install
# In nvim
:help clang
# For tags config, ~/.nvim is in fact .config/nvim/plugged/Nvim-R
# You will need ctags
sudo pacman -S ctags
# For latex, you need nvim-remote
mkdir ~/bin
curl -Lo ~/bin/nvr https://raw.githubusercontent.com/mhinz/neovim-remote/master/nvr
chmod 700 ~/bin/nvr

# Install R stats
sudo pacman -S gcc-fortran
sudo pacman -S tmux
yaourt -S gdal
yaourt -S openblas-lapack
# I chose option 3 aur/openblas
# Install intel-mkl by downloading the AUR tarball, extracting it, finding out
# what the huge intel gz download is, downloading it manually into the extracted
# AUR directory, and running makepkg as suggested, and if it automatically
# installs more than merely intel-mkl, then uninstally those other bits, except
# for intel-compiler-base
# (to remove it, do
# yaourt -R intel-advisor-xe intel-compiler-base intel-fortran-compiler intel-inspector-xe intel-ipp intel-mkl intel-openmp intel-sourcechecker intel-tbb_psxe intel-vtune-amplifier-xe
# )
# Another way, suggested in the PKGBUILD is to download the tarball from the
# AUR, extract it, and do makepkg -sri intel-mkl
# Come back later to find it has failed without sudo, and do sudo pacman -U intel-mkl...pkg.tar.gz
yaourt -S r-mkl
# Edit the PKGBUILD, using the following paths
    source /opt/intel/compilers_and_libraries_2016.3.210/linux/mkl/bin/mklvars.sh ${_intel_arch}
    source /opt/intel/composerxe-2016/linux/bin/compilervars.sh ${_intel_arch}
# Wouldn't work, try downloading AUR tarball, extract it, cd into it, fix
# PKGBUILD as above, and also change `make check-recommended` into `make check`
# to avoid mgcv failure.  Then:
makepkg -sri r-mkl
sudo pacman -U r-mkl-3.3.0-1-x86_64.pkg.tar.xz

ln -s dotfiles/.Rprofile .Rprofile
# Inside R
install.packages("devtools")
# install.packages("setwidth")
# devtools::install_github("jalvesaq/VimCom")
# devtools::install_github("jalvesaq/colorout")
# devtools::install_github("Data-Camp/Rdocumentation")
# install.packages("rgdal")
# Rstudio
yaourt -S rstudio-desktop-bin
# RODBC
sudo pacman -S unixodbc
# in R
install.packages("RODBC")
# General package dependencies
sudo pacman -S pandoc pandoc-citeproc

# V8 just doesn't bloody work, so copy it from a backup
/usr/lib/libv8.so
/usr/include/v8*.h
# and optionally
/usr/lib/pkgconfig/libv8.pc
# which is
prefix=/usr
exec_prefix=${prefix}
libdir=/usr/lib
includedir=${prefix}/include

Name: v8
Description: V8 JavaScript Engine
Version: @VERSION@
Libs: -L${libdir} -lv8 -pthread
Cflags: -I${includedir}
# That's all

# rocker (R docker)
sudo pacman -S docker
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo gpasswd -a nacnudus docker
newgrp docker
docker run --rm -ti rocker/r-devel
# docker run --user docker -p 8000:8000 -ti rocker/r-base bash
apt-get update
apt-get install -y libv8-dev libcurl4-openssl-dev
exit
docker run --rm --user docker -p 8000:8000 -ti rocker/r-base bash
R
install.packages("V8")
# Finally worked! Yuss!
sudo docker run --rm --user docker -p 8000:8000 -v $HOME/crossprod:/home/docker/crossprod -ti pelican bash
sudo docker run --rm --user docker -p 8000:8000 -v $HOME/pelican-themes:/home/docker/pelican-themes -v $HOME/pelican-plugins:/home/docker/pelican-plugins -v $HOME/crossprod:/home/docker/crossprod -ti pelican bash
source /etc/bash_completion.d/virtualenvwrapper
workon crossprod

# Install ag
sudo pacman -S the_silver_searcher

# Install TexLive for LaTeX
sudo mkdir -p /media/iso
sudo mkdir scripts 
sudo mount -t iso9660 -o ro,loop,noauto ~/installables/texlive2016-20160523.iso /media/iso
sudo /media/iso/install-tl --profile=~/scripts/texlive.profile
# Add the exports to the .zshrc
export PATH=$PATH:/usr/local/texlive/2016/bin/x86_64-linux
export MANPATH=$MANPATH:/usr/local/texlive/2016/texmf-dist/doc/man
export INFOPATH=$INFOPATH:/usr/local/texlive/2016/texmf-dist/doc/info
sudo umount /media/iso
sudo tlmgr option repository http://mirror.ctan.org/systems/texlive/tlnet
sudo tlmgr update --self
sudo tlmgr update --all
# and for atp-plugin, you need psutil from python
sudo pip install psutil

# Install htop for monitoring the system load, CPU, memory etc.
sudo pacman -S htop

# Install bluetooth (No, don't! It interferes with wifi, apparently.)
sudo pacman -S bluez bluez-utils
sudo modprobe btusb
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
sudo gpasswd -a nacnudus lp
rfkill unblock bluetooth
bluetoothctl
power on
scan on
devices
agent on
trust 64:BC:0C:F6:62:74
pair 64:BC:0C:F6:62:74
# connect 64:BC:0C:F6:62:74
# Doesn't work, but you can transfer files like this (still doesn't work)
obexftp -b 64:BC:0C:F6:62:74 -p /path/to/file
obexftp -b 64:BC:0C:F6:62:74 -g /path/to/file
exit
sudo pacman -S obexfs
# Try again, still doesn't work, but can transfer files
sudo pacman -S blueman
blueman-manager

# Install mouse
sudo pacman -S xf86-input-synaptics
# Copy /etc/X11/xorg.conf.d/50-synaptics.conf from a backup

# Install fonts
# Take your pick from ttf-anything, but you need inconsolata for current
# defaults, and fontawesome for i3bar volume icons
sudo pacman -S ttf-
sudo pacman -S ttf-inconsolata
yaourt -S ttf-font-awesome

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

# Synchronise time
sudo pacman -S ntp
sudo ntpd -u ntp:ntp
sudo systemctl enable ntpd.service 

# OpenGL
sudo pacman -S mesa-libgl

# Intel graphics config
# File: /etc/X11/xorg.conf.d/20-intel.conf (to reduce tearing -- does something
# worse instead!)
Section "Device"
   Identifier  "Intel Graphics"
   Driver      "intel"
   Option      "TearFree"    "true"
EndSection
# Set recommended options (also causes problems refreshing the terminal when
# typing)
# /etc/modprobe.d/i915.conf
options i915 enable_rc6=1 enable_fbc=1 lvds_downclock=1 semaphores=1
# Next, I tried (based on http://www.linux-hell.com/2015/05/09/solve-ubuntu-video-tearing/
sudo pacman -S lib32-sdl


# Directory sizes
sudo pacman -S baobab

# Backups (back in time)
gpg --keyserver pgp.mit.edu --recv-key 944B4826
yaourt -S backintime backintime-cli
# Run with
sudo backintime-qt4
# or
sudo backintime --profile home backup
sudo backintime --profile full backup

# xrandr
sudo pacman -S xorg-xrandr

# sound
sudo pacman -S pulseaudio-alsa alsa-utils
yaourt -S pulseaudio-ctl
# pulseaudio-ctl provides commands to control volume and mute, the mappings for
# which are in ~/.i3/config.
# Create ~/.asoundrc with the lines
# defaults.ctl.card 1
# defaults.pcm.card 1
# Check with
speaker-test
# Eventually pavucontrol was only way to get everything working
sudo pacman -S pavucontrol

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

# Virtualbox (I don't think virtualbox-guest-utils is necessary)
sudo pacman -S virtualbox virtualbox-host-modules-arch net-tools virtualbox-guest-iso
# qt5-x11extras seems to be needed 2016-07-23
sudo pacman -S qt5-x11extras
# Load the modules immediately
sudo modprobe vboxdrv vboxnetadp vboxnetflt vboxpci
# The GuestAdditions iso lives here
/usr/lib/virtualbox/additions/VBoxGuestAdditions.iso
# For usb sharing, use this:
sudo gpasswd -a $USER vboxusers
# # Shared folders ?? Old instruction ??
# sudo gpasswd -a $USER vboxsf
# # now you find it in /media/sf_share
# For webcam etc.
yaourt -S virtualbox-ext-oracle

# Map alt-key to right-click context menu
sudo pacman -S xorg-xmodmap
# use sudo showkey to find the keycode
xmodmap -pke > ~/.Xmodmap # warning, wipes file if it exists!
vim ~/.Xmodmap # and do, e.g.
keycode 100 = Menu NoSymbol Menu
# But last time it was keycode 135
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
# Also w3m for viewing images in the console
sudo pacman -S w3m
ranger --copy-config=scope

# Okular (requires qt or gtk or something huge, use zathura instead)
# sudo pacman -S kdegraphics-okular
# Selecting 2, 2 gave the smallest install size
# For latex reverse search, Tools > Settings > Editor
# $HOME/.vim/plugged/atp_vim/ftplugin/ATP_files/reverse_search.py '%f' '%l'
# No longer works, use this instead:
# vim --servername VIM --remote +%l %f
# Zathura is a lightweight alternative that has synctex support
# xdotool is necessary for forward-search from Vim
sudo pacman -S zathura-pdf-mupdf xdotool wmctrl
# Set as default viewer
xdg-mime default zathura.desktop application/pdf

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
yaourt -S cnijfilter-mp280 scangearmp-mp280 --noconfirm
sudo pacman -S simple-scan cups ghostscript cups-pdf libcups
# For HP Photosmart 7350
sudo pacman -S hplip
sudo gpasswd -a nacnudus sys
systemctl enable org.cups.cupsd.service
systemctl start org.cups.cupsd.service
# browse http://localhost:631
# Administration
# Add printer
# To print in greyscale, print to file and then:
convert -density 300 -colorspace gray output.pdf output_greyscale.pdf

# gksu (includes gksudo)
sudo pacman -S gksu

# Swap orientation
sudo pacman -S xorg-xinput

# # Citrix
# # Directly from Citrix, but follow these intructions:
# # https://bbs.archlinux.org/viewtopic.php?id=195998
# #
# # "Firstly, enable the multilib repository by uncommenting the [multilib]
# # section in /etc/pacman.conf as mentioned on this wiki page:
# # https://wiki.archlinux.org/index.php/Multilib.  Then update the package list
# # and upgrade with pacman -Syu.
# #
# # "Follow mostly the steps under "Manual Install" on this wiki page:
# # ttps://wiki.archlinux.org/index.php/Citrix.  On Step 0, the package
# # lib32-libpng12 is no longer in the official repository (it's in AUR).  I skipped it and also
# # the four AUR packages (lib32-libxp, lib32-libxpm, lib32-libxaw,
# # lib32-openmotif).  No issue so far."
# sudo pacman -S openmotif lib32-libxmu printproto nspluginwrapper lib32-alsa-lib lib32-gcc-libs lib32-libxft lib32-gtk2 lib32-libxdamage libcanberra
# yaourt -S lib32-libpng12 lib32-libxp lib32-libxpm lib32-libxaw lib32-openmotif --noconfirm
# # Run as root:
# cd /opt/Citrix/ICAClient/keystore/cacerts/
# sudo cp /etc/ssl/certs/ca-certificates.crt .
# sudo awk 'BEGIN {c=0;} /BEGIN CERT/{c++} { print > "cert." c ".pem"}' < ca-certificates.crt
# # Use like this:
# /opt/Citrix/ICAClient/wfica ~/Downloads/launch.jsp

# Playonlinux
sudo pacman -S playonlinux

# axel
sudo pacman -S axel

# unrar
sudo pacman -S unrar

# # crashplan backup
# yaourt -S crashplan
# # sudo systemctl enable crashplan.service
# systemctl start crashplan.service
# CrashPlanDesktop
# systemctl stop crashplan.service

# get_iplayer
yaourt -S get_iplayer
sudo pacman -S perl-xml-simple
sudo pacman -S rtmpdump

# music audio player
sudo pacman -S cmus
man cmus-tutorial

# gui music audio player
# sudo pacman -Rs clementine gstreamer0.10-base-plugins gstreamer0.10-good-plugins gstreamer0.10-bad-plugins gstreamer0.10-ugly-plugins
sudo pacman -S clementine gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav

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
# Copy fonts from a windows installation in C:\Windows\Fonts to the Linux home
# directory (already done, in ~/WindowsFonts)
sudo mkdir /usr/share/fonts/WindowsFonts
sudo cp -r WindowsFonts /usr/share/fonts
sudo chmod 755 /usr/share/fonts/WindowsFonts/*
fc-cache
# sudo fc-cache?

# Backup pacman packages
git clone https://github.com/tech4david/bacpac
cd bacpac
./backpac init

# Manage dos/unix line endings
sudo pacman -S dos2unix

# Lightweight spreadsheet and word
sudo pacman -S gnumeric abiword

# k3b audio CD burner
sudo pacman -S k3b cdrdao dvd+rw-tools
# Options 2 and 2 had the smallest footprint

# Downgrade packages easily
yaourt -S downgrade
# downgrade foo bar

# fasd for fast cd
yaourt -S fasd

# 7zip (7za command)
sudo pacman -S p7zip

# mdbtools
yaourt -S mdbtools

# directory structure
sudo pacman -S tree

# torrents
sudo pacman -S qbittorrent

# podcasts (not found last time)
# sudo pacman -S gpodder

# rename by mp3 tag
sudo pacman -S puddletag

# photo viewer
sudo pacman -S nomacs

# keyboard with pound sign (right-alt + shift + 4)
localectl set-keymap --no-convert us
localectl --no-convert set-x11-keymap us pc105 altgr-intl
# To choose, examine these:
# localectl list-x11-keymap-models
# localectl list-x11-keymap-layouts
# localectl list-x11-keymap-variants
# localectl list-x11-keymap-options
# For serious customisation, look at
# cd /usr/share/kbd/keymaps
# sudo cp i386/qwerty/us.map.gz nacnudus.map.gz
# sudo gunzip nacnudus.map.gz
# man keymaps
# less dumpkeys.txt
# .Xmodmap
# And for .Xmodmap the keycodes aren't the showkey ones, but the xev ones from
# package xorg-xev:
# xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'

# Network usage monitor
sudo pacman -S vnstat
sudo systemctl start vnstat.service
sudo systemctl enable vnstat.service
# vnstat -q
# vnstat -l

# redshift (like f.lux)
sudo pacman- S redshift
touch ~/.config/redshift.conf
sudo cp /usr/lib/systemd/user/redshift.service /etc/systemd/system/redshift.service
sudo systemctl start redshift
sudo systemctl enable redshift

# mount usb sticks e.g. vfat
sudo pacman -S dosfstools
# and restart

# Photo organiser and Google+/Picasa uploader
yaourt -S shotwell

# For copyediting, convert word to txt
sudo pacman -S antiword

# calise to automatically adjust screen brightness (32 MB!)
# Not working as of 17 Feb 2016
# yaourt -S calise-git

# Poor wifi performance (slow)
# Enable antennae aggregation (this worked on 2016-03-06)
nvim /etc/modprobe.d/iwlwifi.conf
options iwlwifi 11n_disable=8
# nvim /etc/modprobe.d/iwlwifi.conf
# options iwlwifi 11n_disable=1
# options iwlwifi swcrypto=1
# Or disable power management
# nvim /etc/udev/rules.d/80-iwlwifi.rules

# eduroam example connections
# yaourt -S netctl-eduroam
# sudo pacman -S wicd wicd-gtk
sudo wpa_supplicant -c /home/nacnudus/dotfiles/eduroam -i wlp2s0 -D nl80211
sudo dhcpcd wlp2s0

# kicker for knitr-compiling files edited with vimtex
gem install kicker -s http://gemcutter.org
# and add .gem/ruby/2.3.0/gems/kicker-3.0.0/bin to the path (in .zshrc)

# mirror list maintenance
sudo pacman -S reflector
sudo reflector --verbose -l 5 --sort rate --save /etc/pacman.d/mirrorlist

# List uuid of all devices
sudo blkid

# musescore music typesetting like sibelius
sudo pacman -S musescore qt5-base qt5-declarative qt5-webkit qt5-sensors qt5-webchannel
# launch with mscore

# unrar to extrat .rar files
sudo pacman -S unrar

# Consider:
# csvkit (obvious)
# patool (untar everything)

# Set up usb tethering
sudo ip link
# Note the name of the link and use it, e.g. enp0s20u2
sudo dhcpcd enp0s20u2
# Create /etc/systemd/network/enp0s20u2
[Match]
Name=enp0s20u2

[Network]
DHCP=ipv4
# And you're done.  To reconnect after reboot, if necessary, do
sudo dhcpcd enp0s20u2

# Prevent screen from turning off during movies (temporarily)
xset s off

# Offline wikipedia
yaourt -S kiwix-bin

# Kill by mouse
sudo pacman -S xorg-xkill

# battery health
sudo pacman -S acpi
acpi -i

# lldb and valgrind gdb c++ segfault debuggers
# Note that lldb doesn't work (missing a .so file somewhere)
sudo pacman -S lldb 
sudo pacman -S valgrind 
sudo pacman -S gdb 

# julia language
sudo pacman -S julia

# sqlite browser gui
sudo pacman -S sqlitebrowser


# Update everything
yaourt -Syua
yaourt -Syua --noconfirm
# Backup list of pacman packages
cd ~/bacpac
./bacpac update
# Clean cache
sudo pacman -Sc
# Completely wipe cache
sudo pacman -Scc
# Clean /var/log/journal
sudo journalctl --vacuum-size=16M
# Uninstall and remove unneeeded dependencies
sudo pacman -Rs xxx
# Remove orphaned packages
sudo pacman -Rns $(pacman -Qtdq) 
# List explicitly-installed packages
pacman -Qen
# List explicitly-installed packages not in official repositories
pacman -Qem
# List explicitly-installed packages with no dependencies
./clean
# Refresh keys (signature from ... is unknown trust)
sudo pacman-key --refresh-keys
