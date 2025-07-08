#!/bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
DEFAULT="\033[0m"

export RUNZSH=no

installAllDotFiles ()
{
	echo -e "${YELLOW}==> Installing dotfiles...${DEFAULT}"
	for file in $( ls -A | grep -vE '\.exclude*|\.git$|\.gitignore|.*.md' ); do
		ln -sv "$PWD/$file" "$HOME" 2> /dev/null || echo -e "\e[31m$file already exists.${DEFAULT}"
	done
    echo -e "${YELLOW}==> Installing .config files...${DEFAULT}"
    mkdir -p "$HOME/.config"
    for file in $( ls -A .config | grep -vE '\.exclude*|\.git$|\.gitignore|.*.md' ); do
        ln -sv "$PWD/.config/$file" "$HOME/.config" 2> /dev/null || echo -e "\e[31m$file already exists.${DEFAULT}"
    done
}

installOhMyZsh ()
{
	sudo pacman -S zsh
	#Installing zsh and syntax highlighting
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 
    # Setting zsh as default shell  
    chsh -s $(which zsh)
    # Remove the .zshrc created by oh-my-zsh and use the one from the repo
    rm -f "$HOME/.zshrc"
    mv $HOME/.zshrc.pre-oh-my-zsh $HOME/.zshrc
}

install42 ()
{
	echo -e "${YELLOW}==> Installing brew...${DEFAULT}"
	rm -rf "$HOME/.brew" && git clone --depth=1 https://github.com/Homebrew/brew "$HOME/.brew" && export PATH="$HOME/.brew/bin:$PATH" && brew update && echo 'export PATH="$HOME/.brew/bin:$PATH"' >> ~/.zshrc
	ln -sv "$PWD/.zshrc" "$HOME" 2> /dev/null || echo -e "${RED}.zshrc already exists.${DEFAULT}"
	ln -sv "$PWD/.vimrc" "$HOME" 2> /dev/null || echo -e "${RED}.vimrc already exists.${DEFAULT}"
}

generateSSHKey ()
{
	echo -e "${YELLOW} ==> Email for the ssh key : ${DEFAULT}"
	read email
	ssh-keygen -t ed25519 -C $email
}

unameOut="$(uname -s)"

case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [[ "$machine" == "Mac" ]]; then
	option="x"
	while [[ ! $option =~ [yYnN] ]]; do 
		echo -en "${YELLOW}==>  Are u at 42 ? [Y/N]: ${DEFAULT}"
		read option

		if [[ $option =~ [yY] ]]; then
			install42
		elif [[ $option =~ [nN] ]]; then
			echo -e "${GREEN}==> Ok\e[0m"
		else 
			echo -e "${RED}==> I didn't get that.${DEFAULT}"
		fi
	done
elif [[ ! "$machine" == "Linux" ]]; then
	echo -e "${RED}==! Unknown type of machine ${unameOut}"
	exit
elif [[ ! -f "/etc/arch-release" ]]; then
	echo -e "${RED}==! Sorry this script is only for arch based distros."
	exit
else
    echo -e "${YELLOW}==> This is an arch based distro${DEFAULT}"
    sudo pacman -Syu --noconfirm
    sudo pacman -S git curl wget vim zsh neovim --noconfirm
fi
	

option="x"
while [[ ! $option =~ [yYnN] ]]; do 
	echo -en "${YELLOW}==>  Do u need an ssh key ? [Y/N] ${DEFAULT}"
	read option

	if [[ $option =~ [yY] ]]; then
		generateSSHKey
	elif [[ $option =~ [nN] ]]; then
		echo -e "${GREEN}==> Ok${DEFAULT}"
	else 
		echo -e "${RED}==> I didn't get that.${DEFAULT}"
	fi
done


option="x"
while [[ ! $option =~ [yYnN] ]]; do 
	echo -en "${YELLOW}==> Do you want to install all the dotfiles? [Y/N]: ${DAFAULT}"
	read option

	if [[ $option =~ [yY] ]]; then
		installAllDotFiles
	elif [[ $option =~ [nN] ]]; then
		echo -e "${GREEN}==> Ok${DAFAULT}"
	else 
		echo -e "${RED}==> I didn't get that.${DAFAULT}"
	fi
done

option="x"
while [[ ! $option =~ [yYnN] ]]; do 
	echo -en "${YELLOW}==> Do you want to install oh-my-zsh? [Y/N]: ${DAFAULT}"
	read option

	if [[ $option =~ [yY] ]]; then
		echo -e "${YELLOW}==> Installing oh-my-zsh${DAFAULT}"
		installOhMyZsh
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	elif [[ $option =~ [nN] ]]; then
		echo -e "${GREEN}==> Ok${DAFAULT}"
	else 
		echo -e "${RED}==> I didn't get that.${DAFAULT}"
	fi
done

option="x"
while [[ ! $option =~ [nNyY] ]]; do 
	echo -en "${YELLOW}==> Do you want to install i3 realted programs? [Y/N]: ${DAFAULT}"
	read option

	if [[ $option =~ [yY] ]]; then
		echo -e "${YELLOW}==> Installing i3 related programs${DAFAULT}"
		sudo pacman -S i3-gaps i3blocks i3lock i3status rofi ranger
	elif [[ $option =~ [nN] ]]; then
		echo -e "${GREEN}==> Ok${DAFAULT}"
	else 
		echo -e "${RED}==> I didn't get that.${DAFAULT}"
	fi
done

option="x"
while [[ ! $option =~ [nNsS] ]]; do 
	echo -en "${YELLOW}==> Do you want to install yay? [Y/N]:${DAFAULT}" 
	read option

	if [[ $option =~ [sS] ]]; then
		echo -e "${YELLOW}==> Installing yay ${DAFAULT}"
		mkdir ~/programs
		git clone https://aur.archlinux.org/yay.git
		mv yay ~/programs
		cd ~/programs/yay
		makepkg -si
		yay -S spotify steam telegram-desktop
	elif [[ $option =~ [nN] ]]; then
		echo -e "${GREEN}==> Ok${DAFAULT}"
	else 
		echo -e "${RED}==> I didn't get that.${DAFAULT}"
	fi
done
