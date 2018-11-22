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

# Set a UK/GB keyboard layout by editing
/etc/X11/xorg.conf.d/00-keyboard.conf
# And adding the lines below, including the comments
# Read and parsed by systemd-localed. It's probably wise not to edit this file
# manually too freely.
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "gb"
        Option "XkbModel" "pc105"
        # Option "XkbVariant" "altgr-intl"
EndSection

# # wifi manually, following
# # https://wiki.archlinux.org/index.php/Wireless_network_configuration#Wireless_management
# sudo ip link set wlp2s0 up
# sudo wpa_supplicant -i wlp2s0 -c <(wpa_passphrase "TALKTALK-FB7208" "7FWKUNMX")

# # wifi and internet and ethernet with connman (I've gone back to netctl)
# # To find existing passwords from netctl
# sudo cat /etc/netctl/something
# # connman configs are in
# /var/lib/connman/somthing.config
# # Now for connman
# sudo pacman -S connman
# yaourt -S connman_dmenu-git
sudo systemctl enable connman.service
sudo systemctl start connman.service
# connmanctl technologies
# connmanctl enable wifi
# # For unprotected networks
# connmanctl scan wifi
# connmanctl services
# connmanctl connect wifi_gobbledegook
# # For protected networks, go interactive
# connmanctl
# scan wifi
# services
# agent on
# connect wifi_gobbledegook
# yaourt -S connman-ncurses-git
yaourt -S connman_dmenu-git
# sudo systemctl stop connman.service
# sudo systemctl disable connman.service

# # Auto-connect to wifi and ethernet
# I'm pretty sure we do need to copy a template from /etc/netctl/examples
sudo cp /etc/netctl/examples/ethernet-dhcp /etc/netctl/eno1
# And then change the interface name in the file to 'eno1'.
# This delays boot:
# sudo systemctl enable dhcpcd@eno1.service
sudo pacman -S wpa_actiond
sudo systemctl start netctl-auto@wlp2s0.service
sudo systemctl enable netctl-auto@wlp2s0.service
# Do we need?
sudo pacman -S ifplugd
sudo systemctl enable netctl-ifplugd@eno1.service
sudo systemctl start netctl-ifplugd@eno1.service
# sudo systemctl disable netctl-ifplugd@eno1.service
# sudo systemctl stop netctl-auto@wlp2s0.service
# sudo systemctl disable netctl-auto@wlp2s0.service

# # For wifi, I now (no longer) follow the instructions on the Arch wiki for wicd
# sudo pacman -S wicd
# sudo systemctl stop and disable all net* services
# sudo systemctl enable wicd
# sudo systemctl start wicd
# gpasswd -a nacnudus users
# wicd-curses

# Enable ssd fstrim to save wear and tear
sudo systemctl enable fstrim.timer

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
# And enable file transfer on the phone
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
# If output doesn't appear in the terminal immediately, try putting/changing
Section "Device"
        Option      "AccelMethod" "uxa"
EndSection
# in /etc/X11/xorg.conf.d/20-intel.conf

# # Install python (note, python3 by default, otherwise use python2)
# sudo pacman -S python python-virtualenv python-virtualenvwrapper python-pip python2 python2-pip ipython ipython2
# # Change the line in .zshrc to
# source /usr/bin/virtualenvwrapper.sh

# Coexist virtualenvwrapper and conda by following
# https://stackoverflow.com/a/42014049/937932

# Install conda for anaconda environments Use the miniconda installer, because
# the full anaconda is huge, ~1.7 GB It will add anaconda's python to the
# beginning of the path, taking precedence over Arch's python, so move it to the
# end of the path instead, as per
# http://tobanwiebe.com/blog/2016/09/anaconda-python-linux
# Default configuration of Anaconda installer
# export PATH="/home/toban/utilities/anaconda3/bin:$PATH"
# Append Anaconda so that it doesn't override system Python
# export PATH="$PATH:/home/toban/utilities/anaconda3/bin"
# The root environment uses the standard Anaconda python installation, so to
# activate the Anaconda’s python, just do source activate root. (Note: this only
# affects the current shell session).
# Set up neovim with jedi completion
source create -n neovim2 python=2
pip install neovim jedi
conda install ncurses
source create -n neovim3 python=3
pip install neovim jedi
conda install ncurses
source deactivate

# direnv for directory specific python environment variables
yay direnv
# Add to the end of ~/.zshrc
eval "$(direnv hook zsh)"

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

# battery life (conflicts with pm-utils)
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

# yay for unofficial packages (seems better, easier to import keys)
yaourt -S yay

# dpkg for .deb-only packages (a bad idea, but necessary for e.g. zombodb)
yaourt -S dpkg

# install ruby, gems and chruby
sudo pacman -S ruby jruby
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
# For vim-github-dashboard
gem install neovim
gem install json_pure
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
# sudo pacman -S ctags
yaourt -S universal-ctags-git
# For latex, you need nvim-remote
mkdir ~/bin
curl -Lo ~/bin/nvr https://raw.githubusercontent.com/mhinz/neovim-remote/master/nvr
chmod 700 ~/bin/nvr

# Install R stats rstats
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
# rJava
# If the output of
archlinux-java status
# is
Available Java environments:
  java-7-openjdk/jre (default)
  java-8-openjdk
# then only the JRE component of java-7 is installed, so install the JDK bit too
sudo pacman -S jdk7-openjdk
# Finally, in R
install.packages("rJava")

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
# littler
yaourt -S littler

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
sudo pacman -S docker docker-compose
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo gpasswd -a nacnudus docker
newgrp docker
# To go straight into R
docker run --rm -ti rocker/r-base
# For version-stable images
docker run --rm -ti rocker/r-ver:3.1.0
# To install other stuff with root privileges
docker run --user docker -u 0 -p 8000:8000 -ti rocker/tidyverse:devel bash
apt-get update
# For V8 you need
apt-get install -y libv8-dev libcurl4-openssl-dev
# For rsconnect you need
apt-get install -y libcurl4-openssl-dev libssl-dev
# Commit the changes (outside of the container, get the id with docker ps -l)
sudo docker commit <container_id> rocker/r-base
exit
docker run --rm --user docker -p 8000:8000 -ti rocker/r-base bash
R
install.packages("V8")
# Finally worked! Yuss!
# To use files outside of the image
sudo docker run --rm --user docker -p 8000:8000 -v $HOME/crossprod:/home/docker/crossprod -ti pelican bash
sudo docker run --rm --user docker -p 8000:8000 -v $HOME/pelican-themes:/home/docker/pelican-themes -v $HOME/pelican-plugins:/home/docker/pelican-plugins -v $HOME/crossprod:/home/docker/crossprod -ti pelican bash
source /etc/bash_completion.d/virtualenvwrapper
workon crossprod
# Or for this rsconnect thing
docker run --rm --user docker -u 0 -p 8000:8000 -v $HOME/R:/home/docker/R -ti rocker/r-ver:3.3.0 bash
apt-get install -y libcairo2-dev libudunits2-dev vim
vim /etc/apt/sources.list
# add
deb-src http://ftp.us.debian.org/debian/ unstable main contrib non-free
apt-get update
apt-get build-dep -y dpkg-dev
apt-get -b source dpkg-dev
apt-get build-dep -y debhelper
apt-get -b source debhelper
apt-get build-dep -y libudunits2-dev
apt-get -b source libudunits2-dev
R
install.packages("devtools")
install.packages("igraph")
devtools::install_github("RcppCore/Rcpp")
devtools::install_github("rstudio/httpuv")
devtools::install_github("rstudio/shiny")
devtools::install_github("Ironholds/piton")
devtools::install_github("davidgohel/gdtools")
devtools::install_github("edzer/units")
devtools::install_github("joelgombin/concaveman")
devtools::install_github("thomasp85/ggforce") # these take ages, so many dependencies
devtools::install_github("thomasp85/ggraph") # these take ages, so many dependencies
devtools::install_github("nacnudus/tidyxl")
deployApp("/home/docker/R/tidyxl/shiny/", appName = "xlex")

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
sudo pacman -S bluez bluez-utils rfkill
sudo modprobe btusb
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
sudo gpasswd -a nacnudus lp
sudo rfkill unblock bluetooth
bluetoothctl
power on
scan on
devices
agent on
trust 64:BC:0C:F6:62:74
pair 64:BC:0C:F6:62:74
connect 64:BC:0C:F6:62:74
# Doesn't work, but you can transfer files like this (still doesn't work)
sudo pacman -S obexfs
obexftp -b 64:BC:0C:F6:62:74 -p /path/to/file
obexftp -b 64:BC:0C:F6:62:74 -g /path/to/file
exit
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
sudo pacman -S ttf-opensans
# sudo pacman -S ttf-inconsolata
# yaourt -S ttf-font-awesome
# yaourt -S nerd-fonts-complete
# The above is a fallback, but really you should download inconsolata from nerd
# fonts, put it in /usr/share/fonts/OTF, and then do something like
fc-cache

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

# # Printer and scanner (out of date?)
# yaourt -S cnijfilter-mp280 scangearmp-mp280 --noconfirm
# sudo pacman -S simple-scan cups ghostscript cups-pdf libcups
# # For HP Photosmart 7350
# sudo pacman -S hplip
# sudo gpasswd -a nacnudus sys
# systemctl enable org.cups.cupsd.service
# systemctl start org.cups.cupsd.service
# # browse http://localhost:631
# # Administration
# # Add printer
# # To print in greyscale, print to file and then:
# convert -density 300 -colorspace gray output.pdf output_greyscale.pdf

# Printer and scanner (Mum and Dad's)
sudo pacman -S hplip
sudo hp-setup
hp-toolbox

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
sudo pacman -S perl-xml-simple rtmpdump atomicparsley

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

# Lightweight spreadsheet and word, with poor xls->xlsx conversion
sudo pacman -S gnumeric abiword
# Then convert xls to xlsx with
ssconvert in.xls out.xlsx

# Heavyweight (>500MB!) spreadsheet and word, for better xls->xlsx conversion
sudo pacman -S libreoffice-fresh
# Then convert xls to xlsx with
libreoffice --headless --convert-to xlsx myfile.xls

# k3b audio CD burner and ripper
sudo pacman -S k3b cdrdao dvd+rw-tools
# Options 2 and 2 had the smallest footprint

# ripright audio CD ripper
yaourt -S ripright

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

# # redshift (like f.lux)
# sudo pacman- S redshift
# touch ~/.config/redshift.conf
# sudo cp /usr/lib/systemd/user/redshift.service /etc/systemd/system/redshift.service
# sudo systemctl start redshift
# sudo systemctl enable redshift

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
# Then use with e.g. R:
R -d valgrind -e "tidyxl::contents('./R/readxl/tests/testthat/iris-google-doc.xlsx')"

# julia language
sudo pacman -S julia

# sqlite browser gui
sudo pacman -S sqlitebrowser

# gimp and help
sudo pacman -S gimp gimp-help-en_gb

# nodejs javascript console
sudo pacman -S nodejs
# then run with
node

# zotero reference manager
yaourt -S zotero

# things for playonlinux for office
sudo pacman -S wine-mono wine_gecko samba lib32-libxml2

# qoobar for specialised classical music organisation
yaourt -S qoobar

# flac lossless audio codec
sudo pacman -S flac

# whipper for high-quality audio cd ripping
yaourt -S whipper-git
# Get the model name
whipper drive list
# Look up the offset http://www.accuraterip.com/driveoffsets.htm (MATSHITA is
# listed as PANASONIC, offset is +103)
# Either confirm it (takes ages) with
whipper offset find -o +103
# or manually put
[drive:MATSHITA%3ABD-CMB%20UJ162%20%20%20%20%3A1.01]
vendor = MATSHITA
model = BD-CMB UJ162
release = 1.01
read_offset = 103
# into $HOME/.config/whipper/whipper.conf
# To rip:
whipper cd rip

# Microsoft office 2010
# Go through playonlinux
# Use product key and activation code in ./installables/Microsoft Office
# Professional Plus 2010/ or in email
# Otherwise (this never worked), create a wineprefix with PlayOnLinux and then
export WINEPREFIX=~/.PlayOnLinux/wineprefix/Office2010
export WINEARCH=win32
export FREETYPE_PROPERTIES="truetype:interpreter-version=35"
wine /home/nacnudus/installables/Microsoft\ Office\ Professional\ Plus\ 2010/X16-32250.exe
winecfg
# set riched20 and gdiplus to 'native' only
wine .PlayOnLinux/wineprefix/Office2010/drive_c/Program\ Files/Microsoft\ Office/Office14/EXCEL.EXE

# Microsoft office 2013 (doesn't work)
# Use product key and activation code in email
# In playonlinux, install Wine version 2.1
# Instructions from https://askubuntu.com/q/879304
sudo pacman -S krb5 samba
WINEPREFIX=~/.PlayOnLinux/wineprefix/Office2013 WINEARCH=win32 winecfg
# In the winecfg applications tab select "Windows version: Windows 7", then
# close wine config
sudo pacman -S zenity
WINEPREFIX=~/.PlayOnLinux/wineprefix/Office2013 WINEARCH=win32 winetricks msxml6
WINEPREFIX=~/.PlayOnLinux/wineprefix/Office2013 WINEARCH=win32 winetricks
# 2. select Run regedit and wait for the Registry Editor window to open. In the
# folder tree expand HKEY_CURRENT_USER - Software - Wine and create a new key in
# the Wine folder. To do so, right click, select new-->key and name it Direct3D.
# Now create new-->DWORD Value, rename the file to MaxVersionGL and set the
# value data to 30002 (hexadecimal). Close the Registry Editor window.
WINEPREFIX=~/.PlayOnLinux/wineprefix/Office2013 WINEARCH=win32 wine /media/dvd/office/setup32.exe
wine .PlayOnLinux/wineprefix/Office2013/drive_c/Program\ Files/Microsoft\ Office/Office14/EXCEL.EXE

# Haskell
sudo pacman -S ghc
# type ghci in terminal
sudo pacman -S hlint ghc-mod

# shutter for screenshots and snipping
yaourt -S shutter

# gov uk prototype kit https://github.com/alphagov/govuk_prototype_kit
sudo pacman -S npm
yaourt -S nvm
nvm install 6
# Download the latest kit and unzip into ~/govuk/prototypes, rename the folder
# and cd into it.
npm install
# Expect warnings about optional components for 'darwin' (mac)
npm start

# remark, a markdown code tidier/beautifier/lintr
npm install -g remark-cli

# vim markdown preview
npm install -g livedown

# slack (like IRC)
yaourt -S slack-desktop
# For desktop notifications
sudo pacman -S dunst

# elixir, for the commands elixir elixirc ix and mix
# "Elixir is a dynamic, functional language designed for building scalable and
# maintainable applications"
sudo pacman -S elixir

# Postgresql
sudo pacman -S postgresql
sudo -u postgres -i
initdb --locale en_GB.UTF-8 -E UTF8 -D '/var/lib/postgres/data'
exit
sudo systemctl start postgresql.service
sudo systemctl enable postgresql.service
# If you create a PostgreSQL user with the same name as your Linux username, it
# allows you to access the PostgreSQL database shell without having to specify a
# user to login (which makes it quite convenient).
sudo -u postgres -i
createuser --interative
exit
createdb myDatabaseName
# Ignore upgrades by adding to /etc/pacman.conf
IgnorePkg = postgresql postgresql-libs

# postgis
sudo pacman -S postgis
createdb addressbase
psql addressbase
# in the psql prompt
CREATE EXTENSION postgis;
# exit the prompt
\q


# cisco anyconnect VPN equivalent
sudo pacman -S openconnect
sudo openconnect <url>

# green-recorder screencast recorder
yaourt -S green-recorder

# gscreenshot screenshot taker
yaourt -S gscreenshot

# diff2html-cli for rendering diffs in HTML with highlighting a la github
# sudo pacman -S diff2html
npm install -g diff2html-cli

# markdown-diff for rendering diffs of markdown in HTML with highlighting
cd ~/temp
curl -RL \
     -O https://raw.github.com/netj/markdown-diff/master/markdown-format-wdiff \
     -O https://raw.github.com/netj/markdown-diff/master/markdown-git-changes
chmod +x markdown-format-wdiff markdown-git-changes
mkdir -p ~/bin
mv -f markdown-format-wdiff markdown-git-changes ~/bin/

# diarize-jruby for speaker identification from audio files, though I've no idea
# how then to use it
rvm install 1.7.0
zsh --login # or set gnome-terminal to run as login shell
rvm use 1.7.0
mkdir $HOME/ruby
cd $HOME/ruby
git clone git@github.com:bbc/diarize-jruby.git
cd diarize-jruby
jruby -S rake --trace

# voiceid for speaker identification from audio files
conda create -n voiceid
source activate voiceid
pip install wxPython mplayer.py MplayerCtrl SoX # wxPython took ages and didn't work
cd $HOME/python
git clone git@github.com:BackupGGCode/voiceid.git
sudo ln /usr/bin/gst-launch-1.0 /usr/bin/gst-launch
cd voiceid
python setup.py install

# ClamAV Antivirus
sudo pacman -S clamav
sudo freshclam
sudo systemctl start clamav-freshclam.service
sudo systemctl enable clamav-freshclam.service
sudo systemctl start clamav-daemon.service
sudo systemctl enable clamav-daemon.service
yaourt -S clamav-unofficial-sigs
sudo systemctl start clamav-unofficial-sigs.timer
sudo systemctl enable clamav-unofficial-sigs.timer

# create a swap file
sudo fallocate -l 16G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
vim /etc/fstab
# Add the line
/swapfile none swap defaults 0 0
# Reduce swappiness
vim /etc/sysctl.d/99-sysctl.conf
# Add the line
vm.swappiness=10

# Set up hibernation into the swap file
# You need to know the partition of the swapfile, e.g. /dev/sdb1
# and the offset, which is from the following command, row 1, column 4 (left
# column of 'physical_offset' pair.
vim /etc/default/grub
# Add the parameters to the line
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
# e.g.
GRUB_CMDLINE_LINUX_DEFAULT="resume=/dev/sdb1 resume_offset=5734400 quiet"
# Generate new grub.cfg config file
sudo grub-mkconfig -o /boot/grub/grub.cfg
vim /etc/mkinitcpio.conf
# Edit the line HOOKS= to include resume, e.g.
HOOKS="base udev resume autodetect modconf block filesystems keyboard fsck"
# generate this boot image
sudo mkinitcpio -p linux
# enable systemd to handle lid close events and buttons and so on
vim /etc/systemd/logind.conf
# uncomment a line and edit it, e.g.
HandleSuspendKey=hibernate
# resume with a locked screen
yaourt -S xss-lock
# Add to $HOME/.xsession
xss-lock -- i3lock -c 002b36

# Install firmware wd719x-firmware to avoid warnings in mkinitcpio -p linux
yaourt -S wd719x-firmware
yaourt -S aic94xx-firmware

# mpack for the munpack utitilty to extract attachments from exported emails
# (mbox)
yaourt -S mpack

# sml for coursera programming languages proglang course
sudo pacman -S smlnj mlton
# install the vim plugin https://github.com/jez/vim-better-sml
cd ~/nvim/plugged/vim-better-sml
make
# Doesn't currently work.  I opened an issue

# download coursera videos
yaourt -S coursera-dl

# rlwrap for making repls better
sudo pacman -S rlwrap

# mysql, there's an Arch wiki page on it, but basically install mariadb
sudo pacman -S mariadb
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable mariadb.service
sudo systemctl start mariadb.service
# Do the below and follow the prompts
mysql_secure_installation
mysql -u root -p
CREATE USER 'nacnudus'@'localhost' IDENTIFIED BY 'some_pass';
CREATE DATABASE nacnudus;
GRANT ALL PRIVILEGES ON nacnudus.* TO 'nacnudus'@'localhost';
# It seems that only root can create databases

# mongodb
sudo pacman -S mongodb
sudo systemctl start mongodb.service
sudo systemctl enable mongodb.service

# elasticsearch
sudo pacman -S elasticsearch
sudo systemctl start elasticsearch.service
sudo systemctl enable elasticsearch.service
# elasticsearch version 2 (for HMRC's address microservices)
yaourt -S elasticsearch2

# # virtuoso (graph database for RDF data).  It just doesn't work and the docs are
# # awful
# yaourt -S virtuoso
# cd /etc/virtuoso
# sudo virtuosod -fd
# # or to run as a demon (not debug)
# sudo virtuosod -f
# # open in browser
# http://localhost:8890/conductor/
# # the two accounts have the same password as username
# # dba -- the relational data administrative account,) and
# # dav --the WebDAV adminstrative account.
# # Create a new user via the website: username=nacnudus password=nacnudus
# # check "User Enabled" and "Allow SQL/ODBC Logins"
# # Give SPARQL_SELECT and SPARQL_UPDATE roles, and a DAV Home Path of
# # /DAV/home/nacnudus/ (check the 'create' checkbox)
# #Send data to the endpoint
# curl -i -T food-types.rdf http://localhost:8890/DAV/home/nacnudus/rdf_sink/food-data.rdf -u nacnudus:nacnudus

# libpostal address matcher normalizer
yaourt -S libpostal-git
sudo libpostal_data download all /usr/local/share/libpostal

# Encrypt the hard disk
# https://wiki.archlinux.org/index.php/Dm-crypt/Device_encryption
sudo pacman -S cryptsetup

# skype
yaourt -S skypeforlinux-bin

# pretty print json at the command line https://stedolan.github.io/jq/
sudo pacman -S jq
# use like
curl something | jq .

# proselint for linting prose in vim
sudo pip install proselint

# Amazon s3 command line
sudo pacman -S aws-cli
# Create an access token in the AWS online console, and use it to configure
aws configure

# tesseract ocr optical character recognition
sudo pacman -S tesseract tesseract-data-eng

# pdfsandwich to OCR pdf files and create searchable pdfs
yaourt -S pdfsandwich

# R magick package
sudo pacman -S libmagick tesseract
# in R
install.packages("magick")
install.packages("tesseract")

# Network monitor
sudo pacman -S vnstat
sudo systemctl start vnstat.service
sudo systemctl enable vnstat.service

# Microsoft SQL Server
# Native
yaourt -S mssql-server mssql-tools
sudo /opt/mssql/bin/mssql-conf setup
sudo systemctl disable mssql-server
systemctl status mssql-server
sqlcmd -S localhost -U SA -Q 'select @@VERSION'
# Or docker
sudo docker pull microsoft/mssql-server-linux:2017-latest
# Remove databases
sudo rm -rf /var/opt/mssql/
# Execute an SQL script
sqlcmd -S localhost -U SA -i ODS_CCG.sql
# Export a table
bcp dbo.ods_ccg out temp.tsv -c -S localhost -U SA

# Cross-database GUI
sudo pacman -S dbeaver

# moreutils for sponge to read from and write to the same file
sudo pacman -S moreutils

# use cloudflare's fast dns domain name servers
vim /etc/resolv.conf
# Put the following lines at the top of /etc/resolv.conf and
# /etc/resolv.conf.head and (comment out whatever's already there)
# Cloudflare
# IPv4 nameservers:
nameserver 1.1.1.1
nameserver 1.0.0.1
# IPv6 nameservers:
nameserver 2606:4700:4700::1111
nameserver 2606:4700:4700::1001

# hub for git sugar
sudo pacman -S hub
# get instructions for aliasing
hub alias
# currently the instructions say to add the following to ~/.zshrc
eval "$(hub alias -s)"

# debugger
sudo pacman -S gdb

# jupyter notebooks
sudo pacman -S jupyter-notebook
# Then enable extensions (e.g. vim)
jupyter nbextension enable --py --sys-prefix widgetsnbextension
# Or in conda environments
conda install -c conda-forge jupyter_contrib_nbextensions
conda install -c conda-forge jupyter_nbextensions_configurator

# Lego designer LDCad
yaourt -S ldcad
sudo pacman -S povray
# or
yaourt -S leocad
# parts library
yaourt -S ldraw-parts-library
# or download the latest version 4 from Lego
unzip setupldd-pc-4_3_11.exe LDDSetup.exe
cp LDDSetup.exe /tmp
export WINEPREFIX=~/.PlayOnLinux/wineprefix/ldd
export WINEARCH=win32
winetricks flash
wine /tmp/LDDSetup.exe

# midi file playback
# timidity++ thing
sudo pacman -S timidity++
# fluidsynth sound font
sudo pacman -S fluidsynth soundfont-fluid
gpasswd -a nacnudus audio
# add the following line to vim /etc/timitidy++/timidity.cfg
soundfont /usr/share/soundfonts/FluidR3_GM.sf2
# then
sudo systemctl start timidity.service
sudo systemctl enable timidity.service
# play a file with
timidity path/to/file.mid
# to play in vlc you need the vlc-git package rather than plain vlc

# lilypond to typeset music like latex
# Includes midi2ly
sudo pacman -S lilypond

# simcity micropolis clone (native, small)
yaourt -S micropolis-git

# glpk operational research optimisation library for Rglpk
sudo pacman -S glpk

# urlwatch to monitor websites
sudo pacman -S urlwatch
sudo pip3 install pushbullet.py
export EDITOR=nvim
urlwatch --edit
e ~/.config/urlwatch/urlwatch.yaml
# Configure as you wish
sudo vim /etc/anacrontab
# Add the line
@daily  10      urlwatch.daily          urlwatch

# Telegram cross-device messaging
yaourt -S telegram-desktop-bin

# Wifi monitor connection monitor internet monitor
sudo pacman -S wavemon

# kops (kubernetes operations -- cluster something something)
yaourt -S kops-bin

# kubectl (kubernetes command-line tool)
yaourt -S kubectl-bin

# helm (kubernetes package manager)
yaourt -S kubernetes-helm

# Docker chrome GUI
sudo pacman -S xorg-xhost
xhost +local:root; \
docker run -it \
  --net host \
  --cpuset-cpus 0 \
  --memory 2048mb \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  -v $HOME/Downloads:/home/chrome/Downloads \
  --security-opt seccomp=$HOME/chrome.json \
  --device /dev/snd \
    --device /dev/dri \
  -v /dev/shm:/dev/shm \
  --name chrome \
  --cap-add=SYS_ADMIN \
  jess/chrome \
  https://www.google.com

# Discord chat and file sharing
yaourt -S discord

# spyder python ide like RStudio, comes for python versions 2 and 3 separately
yay spyder

# scala programming language
sudo pacman -S scala

# android-studio for creating android apps
yaourt -S android-studio

# cron
sudo pacman -S cronie
sudo systemctl start cronie
sudo systemctl enable cronie

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
# Empty coredump cache (usually from terminated R sessions)
sudo rm /var/lib/systemd/coredump/*
