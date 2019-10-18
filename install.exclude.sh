#!/bin/bash
echo -e "\e[32m==> Installing dotfiles...\e[0m"
for file in $( ls -A | grep -vE '\.exclude*|\.git$|\.gitignore|.*.md' ); do
	ln -sv "$PWD/$file" "$HOME" 2> /dev/null || echo -e "\e[31m$file already exists.\e[0m"
done

#Installing zsh and syntax highlighting
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting


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
