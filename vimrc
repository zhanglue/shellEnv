""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocp
set history=1000
set nu
set scrolloff=5
set shiftwidth=4
set softtabstop=4
set tabstop=4
set fileencoding=utf-8
set encoding=utf-8
set showcmd
set backspace=indent,eol,start
set smartindent
set autoindent
set is
set ic
set sc
set hls
"set mouse=nvc
"set mouse=a
nmap <C-m> :set termencoding=gbk, fileencodings=gbk, encoding=gbk<CR>

nmap <C-j> :vertical resize -3<CR>
nmap <C-k> :vertical resize +3<CR>
"set pastetoggle=<C-i>

filetype on
filetype plugin indent on

set foldmethod=indent
set foldlevel=99
nnoremap <space> za

set undofile    " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000   " How many undos
set undoreload=10000  " number of lines to save for undo

if has("autocmd")
	autocmd BufRead *.txt set tw=78
	au BufReadPost * exe "normal! g`\""
endif

set tags=./.tags;,.tags
set autochdir
let g:pydiction_location="$HOME/.vim/complete-dict"

nmap <silent> <F5> :diffupdate<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Status Line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable
syntax on
"colors desert
colors solarized
set bg=dark
set laststatus=2
set statusline=%2*%n%m%r%h%w%*\ %F\ %1*\ %=[COL=%2*%03v%1*]\ [ROW=%2*%03l%1*/%3*%L(%p%%)%1*]
"transparent background
hi Normal ctermfg=252 ctermbg=none

"function! InsertStatuslineColor(mode)
"    if a:mode == 'i'
"        hi statusline guibg=peru
"    elseif a:mode == 'r'
"        hi statusline guibg=blue
"    else
"        hi statusline guibg=red
"    endif
"endfunction
"au InsertEnter * call InsertStatuslineColor(v:insertmode)
"au InsertLeave * hi statusline guibg=lightGreen guifg=black
"hi statusline guibg=lightGreen
"highlight StatusLine guifg=black guibg=Green
"highlight StatusLineNC guifg=Gray guibg=White

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" for Python format
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set ts=4
set sw=4
set sts=4
set tw=100
autocmd FileType python nnoremap <buffer> [[ ?^class\\|^\s*def<CR>
autocmd FileType python nnoremap <buffer> ]] /^class\\|^\s*def<CR>
"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM-PLUG
if empty(glob('/root/.vim/autoload/plug.vim'))
  silent !curl -fLo /root/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plug 'ludovicchabant/vim-gutentags'
" Plug 'vim-scripts/taglist.vim'
" Plug 'mhinz/vim-signify'
call plug#begin('/root/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim'] }
Plug 'sgur/vim-textobj-parameter'
Plug 'kien/rainbow_parentheses.vim'
Plug 'fatih/vim-go'
call plug#end()
" 
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " hide vim-signify hilight column
" set signcolumn=no
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" rainbow parentheses
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

