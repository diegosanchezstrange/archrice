#!/bin/bash

RED="\033[0;31m"
YELLOW="\033[1;33m"
DEFAULT="\033[0m"

installAllDotFiles ()
{
	echo -e "\e[32m==> Installing dotfiles...${DEFAULT}"
	for file in $( ls -A | grep -vE '\.exclude*|\.git$|\.gitignore|.*.md' ); do
		ln -sv "$PWD/$file" "$HOME" 2> /dev/null || echo -e "\e[31m$file already exists.${DEFAULT}"
	done
}

installOhMyZsh ()
{
	#Installing zsh and syntax highlighting
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}

install42 ()
{
	echo -e "\e[32m==> Installing brew...\e[0m"
	rm -rf "$HOME/.brew" && git clone --depth=1 https://github.com/Homebrew/brew "$HOME/.brew" && export PATH="$HOME/.brew/bin:$PATH" && brew update && echo 'export PATH="$HOME/.brew/bin:$PATH"' >> ~/.zshrc
	ln -sv "$PWD/.zshrc" "$HOME" 2> /dev/null || echo -e "\e[31m.zshrc already exists.${DEFAULT}"
	ln -sv "$PWD/.vimrc" "$HOME" 2> /dev/null || echo -e "\e[31m.vimrc already exists.${DEFAULT}"
}

generateSSHKey ()
{
	echo -e "${YELLOW} ==> Email for the ssh key : ${DEFAULT}"
	read email
	ssh-keygen -t ed25519 -C $email
}

option="x"
while [[ ! $option =~ [yYnN] ]]; do 
	echo -en "${YELLOW}==>  Do u need an ssh key ? [Y/N] ${DEFAULT}"
	read option

	if [[ $option =~ [yY] ]]; then
		generateSSHKey
	elif [[ $option =~ [nN] ]]; then
		echo -e "\e[31m==> Ok\e[0m"
	else 
		echo -e "\e[31m==> I didn't get that.${DEFAULT}"
	fi
done

option="x"
while [[ ! $option =~ [yYnN] ]]; do 
	echo -en "\e[33m==>  Are u at 42 ? [Y/N] \e[0m"
	read option

	if [[ $option =~ [yY] ]]; then
		install42
	elif [[ $option =~ [nN] ]]; then
		echo -e "\e[31m==> Ok\e[0m"
	else 
		echo -e "\e[31m==> I didn't get that.\e[0m"
	fi
done

option="x"
while [[ ! $option =~ [yYnN] ]]; do 
	echo -en "\e[33m==> Do you want to install all the dotfiles? \e[0m"
	read option

	if [[ $option =~ [yY] ]]; then
		installAllDotFiles
	elif [[ $option =~ [nN] ]]; then
		echo -e "\e[31m==> Ok\e[0m"
	else 
		echo -e "\e[31m==> I didn't get that.\e[0m"
	fi
done

option="x"
while [[ ! $option =~ [yYnN] ]]; do 
	echo -en "\e[33m==> Do you want to install oh-my-zsh? \e[0m"
	read option

	if [[ $option =~ [yY] ]]; then
		echo -e "\e[32m==> Installing oh-my-zsh\e[0m"
		installOhMyZsh
	elif [[ $option =~ [nN] ]]; then
		echo -e "\e[31m==> Ok\e[0m"
	else 
		echo -e "\e[31m==> I didn't get that.\e[0m"
	fi
done

option="x"
while [[ ! $option =~ [nNsS] ]]; do 
	echo -en "\e[33m==> Do you want to install i3 realted programs? \e[0m"
	read option

	if [[ $option =~ [sS] ]]; then
		echo -e "\e[32m==> Installing i3 related programs\e[0m"
		sudo pacman -S i3-gaps i3blocks i3lock i3status rofi ranger
	elif [[ $option =~ [nN] ]]; then
		echo -e "\e[31m==> Ok\e[0m"
	else 
		echo -e "\e[31m==> I didn't get that.\e[0m"
	fi
done

option="x"
while [[ ! $option =~ [nNsS] ]]; do 
	echo -en "\e[33m==> Do you want to install some useful staff?\e[0m" 
	read option

	if [[ $option =~ [sS] ]]; then
		echo -e "\e[32m==> Installing some useful staff\e[0m"
		mkdir ~/programs
		git clone https://aur.archlinux.org/yay.git
		mv yay ~/programs
		cd ~/programs/yay
		makepkg -si
		yay -S firefox spotify steam telegram-desktop
	elif [[ $option =~ [nN] ]]; then
		echo -e "\e[31m==> Ok\e[0m"
	else 
		echo -e "\e[31m==> I didn't get that.\e[0m"
	fi
done
