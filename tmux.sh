# Tmux Plugin Manager https://github.com/tmux-plugins/tpm 
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Install all plugins by starting tmux and doing prefix-I (i.e. ctrl+a I)

# Reload the config with prefix source-file ~/.tmux.conf or in a shell tmux
# source-file ~/.tmux.conf.  It won't just do it on opening a new terminal,
# because it's a daemon thing.

# Don't use powerline -- far too slow -- but read below if you can't resist.
# The powerline project works for zsh, tmux and vim.  This means replacing
# airline in vim.  Foor zsh, etc., see https://powerline.readthedocs.org/en/latest/usage/shell-prompts.html
# It doesn't really work with i3bar, so use bar instead (pacman), now known as
# lemonbar https://github.com/LemonBoy/bar.
# You can configure it to give your inbox status https://powerline.readthedocs.org/en/latest/configuration/segments/common.html#module-powerline.segments.common.mail
# For making it work in gnome-terminal, look at https://askubuntu.com/questions/283908/how-can-i-install-and-use-powerline-plugin

# To move a pane to another window, do this:
# https://unix.stackexchange.com/questions/14300/moving-tmux-window-to-pane

# You may need https://github.com/tmux-plugins/vim-tmux-focus-events to fix some
# vim bug in tmux that affects gitgutter and fugitive.

# A vim plugin for .tmux.conf syntax, help (with K) etc. https://github.com/tmux-plugins/vim-tmux 

# Resurrect tmux sessions after restarts etc. https://github.com/tmux-plugins/tmux-resurrect
# It will do the same with vim, depending on
# https://github.com/tpope/vim-obsession and automatically with https://github.com/tmux-plugins/tmux-continuum

# Consider 
# https://github.com/tmux-plugins/tmux-sensible
# https://github.com/tmux-plugins/tmux-pain-control
# https://github.com/tmux-plugins/tmux-yank https://github.com/tpope/vim-tbone
# for interacting with tmux from vim
# https://github.com/christoomey/vim-tmux-navigator for consistent keybindings
# to move between vim panes and tmux panes.


# To use alt without prefix to move windows, you could try something like https://gist.github.com/spicycode/1229612
# # Use Alt-vim keys without prefix key to switch panes
# bind -n M-h select-pane -L
# bind -n M-j select-pane -D 
# bind -n M-k select-pane -U
# bind -n M-l select-pane -R

# # Use Alt-arrow keys without prefix key to switch panes
# bind -n M-Left select-pane -L
# bind -n M-Right select-pane -R
# bind -n M-Up select-pane -U
# bind -n M-Down select-pane -D

# Tmuxinator is recommended for managing complex sessions (or configuring them?)

# Colourscheme:
# https://github.com/EvanPurkhiser/linux-vt-setcolors
# https://github.com/EvanPurkhiser/mkinitcpio-colors
# https://github.com/seebi/tmux-colors-solarized
# Follow the instructions given at the end of these installs.
yaourt -S setcolors-git
yaourt -S mkinitcpio-colors-git
# In particular, add the hook to /etc/mkinitcpio.conf
# Earlier is better, but how early?
HOOKS="base udev autodetect modconf block filesystems keyboard fsck colors"
# And putting the colours into /etc/vconsole.conf:
COLOR_0=002b36
COLOR_1=dc322f
COLOR_2=859900
COLOR_3=b58900
COLOR_4=268bd2
COLOR_5=d33682
COLOR_6=2aa198
COLOR_7=eee8d5
COLOR_8=002b36
COLOR_9=cb4b16
COLOR_10=586e75
COLOR_11=657b83
COLOR_12=839496
COLOR_13=6c71c4
COLOR_14=93a1a1
COLOR_15=fdf6e3
# Finally, run
sudo mkinitcpio -p linux

# Brightness:
# chmod +x the files brighter and darker in dotfiles, then copy to
# /usr/local/bin
# Keybindings in the console are here https://wiki.archlinux.org/index.php/Extra_keyboard_keys_in_console
sudo mkdir -p /usr/local/share/kbd/keymaps
vim /usr/local/share/kbd/keymaps/personal.map
keycode 225 = F31
string F31 = "/usr/local/bin/brighter\n"
keycode 224 = F32
string F32 = "/usr/local/bin/darker\n"
# Then add the path to the KEYMAP VARIABLE in /etc/vconsole.conf
# And add this line to visudo
ALL ALL=NOPASSWD: /usr/bin/tee /sys/class/backlight/intel_backlight/brightness
# Finally, run
sudo mkinitcpio -p linux
# Or for testing, do
loadkeys /usr/local/share/kbd/keymaps/personal.map

# Look for R colorout solarized

# Font for powerline
# The trouble is, the console can't handle ttf fonts (true-type) like
# inconsolata.
# Try using fbterm instead.

# fbterm
# sudo pacman -S fbterm
# sudo gpasswd -a nacnudus video
# sudo setcap 'cap_sys_tty_config+ep' /usr/bin/fbterm
# sudo chmod u+s /usr/bin/fbterm
# Try yaft instead (yet another framebuffer terminal)

# TODO: IPython 
