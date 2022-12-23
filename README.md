# archrice
My arch configuration files

# What is this ?

This is a repo to save all my configuration files. I use this repo everytime i reinstall my linux computer or at the 42 campus.

# What does it have ?

In this repo i have my config for:

- vim (.vimrc) - Simple config with just a couple of plugins. I'm starting to use nvim so i dont use it that much any more
- nvim (.config/nvim) - I use this at 42 as a C/C++ IDE
- zsh (.zshrc) - A couple of aliases
- tmux (.tmux.conf) - Changed prefix and colors
- i3 (.i3/ , .i3blocks.conf) - I'm not using this currently
- urxvt - (.Xresources) - I'm using alacritty right now but i'm keeping this config

# How it works

To install everythin you just have to clone the repo cd into it and run the .install.exclude.sh.

1. Clone the repo
```
git clone https://github.com/diegosanchezstrange/archrice.git
```
2. cd into the repo
```
cd archrice
```
3. Run the script
```
./install.exclude.sh
```

The script will prompt you with different questions on each step so you can just install the things you need.



