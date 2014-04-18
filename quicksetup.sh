sudo add-apt-repository --yes ppa:noobslab/apps # synapse
sudo add-apt-repository --yes ppa:ubuntu-wine/ppa # wine
sudo add-apt-repository --yes ppa:marutter/rrutter # R
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo add-apt-repository --yes ppa:mscore-ubuntu/mscore-stable # muse-score
sudo add-apt-repository --yes ppa:ubuntugis/ubuntugis-unstable # ubuntugis QGIS
sudo add-apt-repository --yes ppa:gnome-terminator # terminator
sudo add-apt-repository --yes ppa:ubuntugis/ppa
echo "deb http://debian.sur5r.net/i3/ saucy universe" | sudo tee -a /etc/apt/sources.list # i3
sudo apt-get --allow-unauthenticated install sur5r-keyring # i3

sudo apt-get update
sudo apt-get --assume-yes upgrade

# Terminator
export TERM=terminator

# zsh, the z shell
sudo apt-get --assume-yes install zsh
# set it as the default shell
chsh -s /usr/bin/zsh # doesn't work as root

# pip for other things
sudo apt-get --assume-yes install python-pip

# i3
sudo pip install i3-py

# Zotero
wget https://raw.github.com/smathot/zotero_installer/master/zotero_installer.sh -O /tmp/zotero_installer.sh
chmod +x /tmp/zotero_installer.sh
sudo /tmp/zotero_installer.sh

# Calibre
sudo -v && wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"

# chrome
sudo apt-get --assume-yes install libcurl3
sudo dpkg -i ~/Downloads/google-chrome-stable_current_amd64.deb

# RStudio
# R first
sudo apt-get install --assume-yes r-base r-base-dev libcurl4-openssl-dev
cd ~/Downloads
sudo apt-get --assume-yes install axel
axel -n 10 https://s3.amazonaws.com/rstudio-dailybuilds/rstudio-0.98.738-amd64.deb
sudo dpkg -i rstudio-0.98.738-amd64.deb

# R and java and things
wget http://www.lepem.ufc.br/jaa/vimcom.plus_0.9-93.tar.gz
R CMD INSTALL vimcom.plus_0.9-93.tar.gz
sudo apt-get --assume-yes install r-cran-rjava
sudo R CMD javareconf

# TexLive
sudo mount -t iso9660 -o ro,loop,noauto ~/installables/texlive2013-20130530.iso ~/usb
sudo ~/usb/install-tl --profile=~/scripts/texlive.profile
sudo umount ~/usb
tlmgr option repository http://mirror.ctan.org/systems/texlive/tlnet
tlmgr update --all

# install lilypond using their script
cd ~/Downloads
axel -n 10 http://download.linuxaudio.org/lilypond/binaries/linux-64/lilypond-2.18.0-1.linux-64.sh
sudo sh lilypond-2.18.0-1.linux-64.sh

# jedi for vim auto-completion
sudo pip install jedi

# jekyll
sudo apt-get --assume-yes install rubygems
sudo gem install bundler

# Aaron's printer
sudo apt-get install --assume-yes libc6 libcups2 libpopt0
sudo apt-get install --assume-yes libatk1.0-0 libcairo2 libfontconfig1 libglib2.0-0 libgtk2.0-0 libpango1.0-0 libpng12-0 libtiff4 libx11-6 libxcursor1 libxext6 libxinerama1 libxml2 libxrandr2 libxrender1
# http://support-nz.canon.co.nz/contents/NZ/EN/0100301402.html
# http://pdisp01.c-wss.com/gdl/WWUFORedirectTarget.do?id=MDEwMDAwMzAxNDAx&cmp=ABS&lang=EN
# Download the file and extract it.
# sudo dpkg -i # doing the "common" .deb first, then the mp280.

# axel
# terminator
# zsh
# i3
# i3status
# i3lock
# xbacklight
# dmenu
# scrot
# libcurl3
# synapse
# git
# pdftk
# get-iplayer
# ffmpeg
# libavcodec-extra-53 
# audacity
# gparted
# python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-# nose
# traceroute
# curl
# openjdk-7-jdk
# mpg123
# musescore
# docx2txt
# antiword
# catdoc
# python-software-properties
# qgis
# wine
# playonlinux
# winetricks
# silversearcher-ag
# exuberant-ctags
# ttf-inconsolata
# kexi
# pandoc
# digiKam
# tmux
# testdisk
# gimp
# gimp-ufraw
# clementine
# texstudio
# baobab
# gPodder
# smartmontools
# ruby1.9.1-dev
# libcurl4-openssl-dev
# vim-gnome
# youtube-dl
# gdal-bin libgdal1 proj-bin postgresql-9.1-postgis libpq-dev
# r-cran-boot 
# r-cran-class
# r-cran-cluster
# r-cran-codetools
# r-cran-foreign
# r-cran-kernsmooth
# r-cran-lattice
# r-cran-mass
# r-cran-matrix
# r-cran-mgcv
# r-cran-nlme
# r-cran-nnet
# r-cran-rpart
# r-cran-spatial
# r-cran-survival
# r-cran-rodbc
# littler
# python-rpy
# python-rpy-doc 

sudo apt-get install --assume-yes axel terminator zsh i3 i3status i3lock xbacklight dmenu scrot libcurl3 synapse git pdftk get-iplayer ffmpeg libavcodec-extra-53 audacity gparted python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose traceroute curl openjdk-7-jdk mpg123 musescore docx2txt antiword catdoc python-software-properties qgis wine playonlinux winetricks silversearcher-ag exuberant-ctags ttf-inconsolata kexi pandoc digiKam tmux testdisk gimp gimp-ufraw clementine texstudio baobab gPodder smartmontools ruby1.9.1-dev libcurl4-openssl-dev vim-gnome youtube-dl gdal-bin libgdal1 proj-bin postgresql-9.1-postgis libpq-dev r-cran-class r-cran-cluster r-cran-codetools r-cran-foreign r-cran-kernsmooth r-cran-lattice r-cran-mass r-cran-matrix r-cran-mgcv r-cran-nlme r-cran-nnet r-cran-rpart r-cran-spatial r-cran-survival r-cran-rodbc littler python-rpy python-rpy-doc 
