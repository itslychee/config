

syntax on
set number
set nowrap
set termguicolors

call plug#begin()
	Plug 'ayu-theme/ayu-vim'
	Plug 'vimsence/vimsence'
	Plug 'fatih/vim-go'
call plug#end()

let ayucolor="dark"
colorscheme ayu
