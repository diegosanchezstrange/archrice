# Path to your oh-my-zsh installation.
export ZSH="/home/diego/.oh-my-zsh"

ZSH_THEME="gallois"

COMPLETION_WAITING_DOTS="true"

plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export EDITOR='mvim'


alias py="python3"
alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias i3config="vim ~/.i3/config"
alias Xres="vim ~/.Xresources"
