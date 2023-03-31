" Automatic plug installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

nnoremap <silent> <C-f> :Files<CR>

set laststatus=2

set t_Co=256

colorscheme Atelier_EstuaryDark

let g:airline#extensions#tabline#enabled = 1

set visualbell
set noerrorbells

set number
set relativenumber
set tabstop=4
set shiftwidth=4
set textwidth=80
set colorcolumn=+1
set encoding=utf-8
set fillchars+=stl:\ ,stlnc:\
highlight ColorColumn ctermbg=DarkRed
