#!/bin/bash

#Make dmenu show all the man pages. Choosing one makes zathura open it in pdf

man -k . | dmenu -l 30 | cut -d " " -f 1 | xargs -r man -Tpdf | zathura -

