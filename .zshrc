# Path to your oh-my-zsh installation.
export ZSH="/home/diego/.oh-my-zsh"

#ZSH_THEME="robbyrussell"
#ZSH_THEME="agnoster"
ZSH_THEME="gallois"
#Randome theme

COMPLETION_WAITING_DOTS="true"

plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"


alias py="python3"
alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias i3config="vim ~/.i3/config"
alias Xres="vim ~/.Xresources"
