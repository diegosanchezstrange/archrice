" Automatic plug installation 
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'flazz/vim-colorschemes'
Plug 'https://github.com/tomtom/tcomment_vim'
Plug 'https://github.com/Valloric/YouCompleteMe'
Plug 'mattn/emmet-vim'

call plug#end()

python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/

set laststatus=2

set t_Co=256

colorscheme 1989
 
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set textwidth=80
set colorcolumn=+1
set encoding=utf-8
set fillchars+=stl:\ ,stlnc:\
highlight ColorColumn ctermbg=DarkRed

map <Up> :echo "Estas usando vim pedazo de subnormal" <Cr>
map <Down> :echo "Estas usando vim pedazo de subnormal" <CR>
map <Left> :echo "Estas usando vim pedazo de subnormal" <CR>
map <Right> :echo "Estas usando vim pedazo de subnormal" <CR>
