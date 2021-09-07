#!/bin/bash
# BLFS 10.1 Build Script

package_name=""
package_ext=""

begin() {
	package_name=$1
	package_ext=$2
	
	echo "[lfs-scripts] Starting build of $package_name at $(date)"
	
	tar xf $package_name.$package_ext
	cd $package_name
}

finish() {
	echo "[lfs-scripts] Finishing build of $package_name at $(date)"

	cd /sources
	rm -rf $package_name
}

cd /sources

#https://kernel.googlesource.com/pub/scm/linux/kernel/git/firmware/linux-firmware/
#git clone https://kernel.googlesource.com/pub/scm/linux/kernel/git/firmware/linux-firmware


cat > /etc/profile << "EOF"
# Begin /etc/profile
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# modifications by Dagmar d'Surreal <rivyqntzne@pbzpnfg.arg>

# System wide environment variables and startup programs.

# System wide aliases and functions should go in /etc/bashrc.  Personal
# environment variables and startup programs should go into
# ~/.bash_profile.  Personal aliases and functions should go into
# ~/.bashrc.

# Functions to help us manage paths.  Second argument is the name of the
# path variable to be modified (default: PATH)
pathremove () {
        local IFS=':'
        local NEWPATH
        local DIR
        local PATHVARIABLE=${2:-PATH}
        for DIR in ${!PATHVARIABLE} ; do
                if [ "$DIR" != "$1" ] ; then
                  NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
                fi
        done
        export $PATHVARIABLE="$NEWPATH"
}

pathprepend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

pathappend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}

export -f pathremove pathprepend pathappend

# Set the initial path
export PATH=/usr/bin

# Attempt to provide backward compatibility with LFS earlier than 11
if [ ! -L /bin ]; then
        pathappend /bin
fi

if [ $EUID -eq 0 ] ; then
        pathappend /usr/sbin
        if [ ! -L /sbin ]; then
                pathappend /sbin
        fi
        unset HISTFILE
fi

# Setup some environment variables.
export HISTSIZE=1000
export HISTIGNORE="&:[bf]g:exit"

# Set some defaults for graphical systems
export XDG_DATA_DIRS=${XDG_DATA_DIRS:-/usr/share/}
export XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:-/etc/xdg/}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/tmp/xdg-$USER}

# Setup a red prompt for root and a green one for users.
NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
if [[ $EUID == 0 ]] ; then
  PS1="$RED\u [ $NORMAL\w$RED ]# $NORMAL"
else
  PS1="$GREEN\u [ $NORMAL\w$GREEN ]\$ $NORMAL"
fi

for script in /etc/profile.d/*.sh ; do
        if [ -r $script ] ; then
                . $script
        fi
done

unset script RED GREEN NORMAL

# End /etc/profile
EOF

install --directory --mode=0755 --owner=root --group=root /etc/profile.d

cat > /etc/profile.d/dircolors.sh << "EOF"
# Setup for /bin/ls and /bin/grep to support color, the alias is in /etc/bashrc.
if [ -f "/etc/dircolors" ] ; then
        eval $(dircolors -b /etc/dircolors)
fi

if [ -f "$HOME/.dircolors" ] ; then
        eval $(dircolors -b $HOME/.dircolors)
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
EOF

cat > /etc/profile.d/extrapaths.sh << "EOF"
if [ -d /usr/local/lib/pkgconfig ] ; then
        pathappend /usr/local/lib/pkgconfig PKG_CONFIG_PATH
fi
if [ -d /usr/local/bin ]; then
        pathprepend /usr/local/bin
fi
if [ -d /usr/local/sbin -a $EUID -eq 0 ]; then
        pathprepend /usr/local/sbin
fi

# Set some defaults before other applications add to these paths.
pathappend /usr/share/man  MANPATH
pathappend /usr/share/info INFOPATH
EOF

cat > /etc/profile.d/readline.sh << "EOF"
# Setup the INPUTRC environment variable.
if [ -z "$INPUTRC" -a ! -f "$HOME/.inputrc" ] ; then
        INPUTRC=/etc/inputrc
fi
export INPUTRC
EOF

cat > /etc/profile.d/umask.sh << "EOF"
# By default, the umask should be set.
if [ "$(id -gn)" = "$(id -un)" -a $EUID -gt 99 ] ; then
  umask 002
else
  umask 022
fi
EOF

cat > /etc/profile.d/i18n.sh << "EOF"
# Set up i18n variables
export LANG=en_US.UTF-8
EOF

cat > /etc/bashrc << "EOF"
# Begin /etc/bashrc
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# updated by Bruce Dubbs <bdubbs@linuxfromscratch.org>

# System wide aliases and functions.

# System wide environment variables and startup programs should go into
# /etc/profile.  Personal environment variables and startup programs
# should go into ~/.bash_profile.  Personal aliases and functions should
# go into ~/.bashrc

# Provides colored /bin/ls and /bin/grep commands.  Used in conjunction
# with code in /etc/profile.

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Provides prompt for non-login shells, specifically shells started
# in the X environment. [Review the LFS archive thread titled
# PS1 Environment Variable for a great case study behind this script
# addendum.]

NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
if [[ $EUID == 0 ]] ; then
  PS1="$RED\u [ $NORMAL\w$RED ]# $NORMAL"
else
  PS1="$GREEN\u [ $NORMAL\w$GREEN ]\$ $NORMAL"
fi

unset RED GREEN NORMAL

# End /etc/bashrc
EOF

mkdir -v /etc/skel

cat > /etc/skel/.bash_profile << "EOF"
# Begin ~/.bash_profile
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# updated by Bruce Dubbs <bdubbs@linuxfromscratch.org>

# Personal environment variables and startup programs.

# Personal aliases and functions should go in ~/.bashrc.  System wide
# environment variables and startup programs are in /etc/profile.
# System wide aliases and functions are in /etc/bashrc.

if [ -f "$HOME/.bashrc" ] ; then
  source $HOME/.bashrc
fi

if [ -d "$HOME/bin" ] ; then
  pathprepend $HOME/bin
fi

# Having . in the PATH is dangerous
#if [ $EUID -gt 99 ]; then
#  pathappend .
#fi

# End ~/.bash_profile
EOF

cat > /etc/skel/.bashrc << "EOF"
# Begin ~/.bashrc
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>

# Personal aliases and functions.

# Personal environment variables and startup programs should go in
# ~/.bash_profile.  System wide environment variables and startup
# programs are in /etc/profile.  System wide aliases and functions are
# in /etc/bashrc.

if [ -f "/etc/bashrc" ] ; then
  source /etc/bashrc
fi

# Set up user specific i18n variables
#export LANG=<ll>_<CC>.<charmap><@modifiers>

# End ~/.bashrc
EOF

cat > /etc/skel/.tmux.conf << "EOF"
unbind C-b
set -g prefix C-Space
set -g history-limit 100000
 
unbind r
bind r source-file ~/.tmux.conf \; display-message "~/.tmux.conf reloaded"
 
set -g mouse on
set -g terminal-overrides 'xterm*:smcup@:rmcup@'
 
set -g status-bg blue
set -g status-fg black
 
# set  v = vertical  h = horizontal
unbind v
unbind h
unbind %
bind v split-window -h -c '#{pane_current_path}'
unbind '"'
bind h split-window -v -c '#{pane_current_path}'
 
# -n no prefix key, ctrl+hjkl to move pane to pane
# ctrl-h is backspace... it does not work yet...
bind -n C-h select-pane -L
bind -n C-j select-pane -D
bind -n C-k select-pane -U
bind -n C-l select-pane -R
 
unbind n  #DEFAULT KEY: Move to next window
unbind w  #DEFAULT KEY: change current window interactively
 
bind n command-prompt "rename-window '%%'"
bind w new-window -c "#{pane_current_path}"
 
set -g base-index 1
set-window-option -g pane-base-index 1
 
# M = alt goto next or previous window
bind -n M-j previous-window
bind -n M-k next-window
 
# Vi key bindings
set-window-option -g mode-keys vi
 
unbind -T copy-mode-vi Space; #Default for begin-selection
unbind -T copy-mode-vi Enter; #Default for copy-selection
 
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -i -f -selection primary | xclip -i -selection clipboard"
 
# Another improvement you might want: navigating between tmux panes and Vim windows using the same keystrokes, ctrl+hjkl.
# This config will do exactly that:
# Smart pane switching with awareness of Vim splits.
# See: https://github.com/christoomey/vim-tmux-navigator
 
#is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
#    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
#bind -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
#bind -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
#bind -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
#bind -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
#bind -n C-\\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
 
 
##############
### DESIGN ###
##############

# panes
set -g pane-border-style fg=black
set -g pane-active-border-style fg=red

## Status bar design
# status line
set -g status-justify left
#set -g status-bg default
set -g status-style fg=blue
set -g status-interval 2

# messaging
set -g message-command-style fg=blue,bg=black

# window mode
setw -g mode-style bg=green,fg=black

# window status
setw -g window-status-format " #F#I:#W#F "
setw -g window-status-current-format " #F#I:#W#F "
setw -g window-status-format "#[fg=magenta]#[bg=black] #I #[bg=cyan]#[fg=white] #W "
setw -g window-status-current-format "#[bg=brightmagenta]#[fg=white] #I #[fg=white]#[bg=cyan] #W "
setw -g window-status-current-style bg=black,fg=yellow,dim
setw -g window-status-style bg=green,fg=black,reverse

# loud or quiet?
set -g visual-activity off
set -g visual-bell off
set -g visual-silence off
set-window-option -g monitor-activity off
set -g bell-action none

# The modes 
set-window-option -g clock-mode-colour red
set-window-option -g mode-style fg=red,bg=black,bold

# The panes 
set -g pane-border-style bg=black,fg=black
set -g pane-active-border-style fg=blue,bg=brightblack

# The statusbar 
set -g status-position bottom
set -g status-style bg=black,fg=yellow,dim
set -g status-left ''
set -g status-right '#{?client_prefix,#[fg=red]prefix pressed ..,#[fg=brightwhite]#H}'

set -g status-right-length 50
set -g status-left-length 20

# The window
set-window-option -g window-status-current-style fg=red,bg=brightblack,bold
set-window-option -g window-status-current-format ' #I#[fg=brightwhite]:#[fg=brightwhite]#W#[fg=blue]#F '

set-window-option -g window-status-style fg=magenta,bg=black,none
set-window-option -g window-status-format ' #I#[fg=colour251]:#[fg=colour251]#W#[fg=black]#F '

set-window-option -g window-status-bell-style fg=white,bg=red,bold

# The messages 
set -g message-style fg=white,bg=red,bold

EOF

cat > /etc/skel/.bash_logout << "EOF"
# Begin ~/.bash_logout
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>

# Personal items to perform on logout.

# End ~/.bash_logout
EOF

dircolors -p > /etc/dircolors



cat > /etc/issue << "EOF"
\d \t \s \m
\n \r \v
EOF

cd /sources
#wget https://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20210819.tar.xz
tar xf blfs-systemd-units-20210819.tar.xz
mv blfs-systemd-units-20210819 blfs-systemd-units




#  Cleaning Up
rm -rf /tmp/*a

echo "blfs-after.sh"
#cat  /sources/blfssystemrc.log

