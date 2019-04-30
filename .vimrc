call plug#begin('~/.vim/plugged')

Plug 'flazz/vim-colorschemes'
Plug 'https://github.com/tomtom/tcomment_vim'
Plug 'https://github.com/Valloric/YouCompleteMe'

call plug#end()

colorscheme molokai
 
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set textwidth=80
set colorcolumn=+1
highlight ColorColumn ctermbg=DarkRed

map <Up> :echo "Estas usando vim pedazo de subnormal" <Cr>
map <Down> :echo "Estas usando vim pedazo de subnormal" <CR>
map <Left> :echo "Estas usando vim pedazo de subnormal" <CR>
map <Right> :echo "Estas usando vim pedazo de subnormal" <CR>
