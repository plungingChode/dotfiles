set number
set tabstop=4
set shiftwidth=4
set expandtab
set ignorecase
set smartcase

" Use syntax highlighting
syntax on
colorscheme peachpuff

" Run python on F5 
autocmd FileType python map <F5> <Esc>:w<CR>:!clear;python %<CR>

