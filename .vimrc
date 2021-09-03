" Show line numbers
set number

" Set Tab to 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" No line wrapping
set wrap!

" Use syntax highlighting
syntax on
colorscheme peachpuff

" Run python on F5 
autocmd FileType python map <F5> <Esc>:w<CR>:!clear;python %<CR>
