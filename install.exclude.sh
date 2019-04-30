#!/bin/bash

for file in $( ls -A | grep -vE '\.exclude*|\.git$|\.gitignore|.*.md' ); do
	ln -sv "$PWD/$file" "$HOME" 2> /dev/null || echo -e "$file already exists."
done

