call plug#begin('~/.local/share/nvim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'cespare/vim-toml'
Plug 'fatih/vim-go', {'tag': '*', 'do': ':GoInstallBinaries'}
Plug 'itchyny/lightline.vim'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-commentary', {'tag': '*'}
Plug 'tpope/vim-surround', {'tag': '*'}
call plug#end()

set background=dark
set backspace=indent,eol,start
set clipboard+=unnamedplus
set encoding=UTF-8
set fileencoding=UTF-8
set guicursor=n-v-ve-o-c:hor100-blinkon1000,i-r-ci-cr-sm:ver100-blinkon1000
set hlsearch
set incsearch
set noerrorbells
set nomodeline
set noshowmode   " lightline will show the current mode (e.g. INSERT, NORMAL)
set relativenumber
set ruler
set scrolloff=3
set shiftwidth=4
set showcmd
set showmatch
set softtabstop=4
set tabstop=4
set wildmenu

colorscheme solarized
syntax on
filetype plugin indent on

augroup strip_trailing_whitespace
	autocmd BufWritePre * :%s/\s\+$//e
augroup END

let g:go_fmt_command = 'goimports'
let g:lightline = { 'colorscheme': 'solarized' } " dark is default
let g:netrw_banner = 0
let g:netrw_list_style = 3 " tree view
let g:rustfmt_autosave = 1