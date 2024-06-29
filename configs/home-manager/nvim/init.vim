filetype plugin indent on

syntax on
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set backspace=indent,eol,start

set number
set relativenumber

set path=**
set wildmode=longest,list,full
set wildmenu
set complete-=i

let mapleader = "\<Space>"

nnoremap <Leader>w :w<CR>

set splitright
set splitbelow

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set undoreload=10000

nnoremap Q <Nop>

set completeopt-=preview

nnoremap <c-p> :FzfLua files<cr>

set exrc
set secure
set nomodeline
set mouse=

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
