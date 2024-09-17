# Path to your oh-my-zsh installation.
export ZSH="/home/$USER/.oh-my-zsh"

ZSH_THEME="bira"

COMPLETION_WAITING_DOTS="true"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

bindkey '^ ' autosuggest-accept


source $ZSH/oh-my-zsh.sh

export EDITOR='mvim'

export PATH="$HOME/.local/bin:$PATH"

export PATH=/home/dsanchez/bin:$PATH

export DOCKER_HOST=unix:///run/user/1000/docker.sock

# Path Variables
export TERM='xterm-256color'
export EDITOR='nvim'
export VISUAL='nvim'


alias py="python3"
alias zshrc="vim ~/.zshrc"
alias szshrc="source ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias nvimrc="vim ~/.config/nvim"
alias i3config="vim ~/.i3/config"
alias Xres="vim ~/.Xresources"
alias vim=nvim
alias nv=nvim
