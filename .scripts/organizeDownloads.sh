#!/bin/bash

files=`ls ~/Downloads`

for file in $files; do
	if [ ! -d "~/Downloads/.${file#*.}" ]; then
		echo "~/Downloads/.${file#*.}"
		mkdir ~/Downloads/.${file#*.}	
	fi
	if [ "~/Downloads/+$file" ]; then
		echo $file	
	fi
done


