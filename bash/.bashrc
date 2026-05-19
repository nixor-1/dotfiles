#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias stowall='cd ~/dotfiles && stow */'

# For launching various NeoVim distributions (package bundles).
alias nvim-astro='NVIM_APPNAME=astronvim nvim'

PS1='[\u@\h \W]\$ '

# source /usr/share/nvm/init-nvm.sh
