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

set tags=tags;
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
function! InsertStatuslineColor(mode)
    if a:mode == 'i'
        hi statusline guibg=peru
    elseif a:mode == 'r'
        hi statusline guibg=blue
    else
        hi statusline guibg=red
    endif
endfunction
au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=lightGreen guifg=black
hi statusline guibg=lightGreen
highlight StatusLine guifg=black guibg=Green
highlight StatusLineNC guifg=Gray guibg=White

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
" VUNDLE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"filetype on
""set the runtime path to include Vundle and initialize
"set rtp+=/home/work/.vim/bundle/Vundle.vim
"call vundle#begin()
""call vundle#begin('/home/work/.jumbo/share/vim/vim80/')
"" alternatively, pass a path where Vundle should install plugins
"
"" let Vundle manage Vundle, required
"Plugin 'VundleVim/Vundle.vim'
"
"Plugin 'indentpython.vim'
"" The following are examples of different formats supported.
"" Keep Plugin commands between vundle#begin/end.
"" plugin on GitHub repo
""Plugin 'tpope/vim-fugitive'
"" plugin from http://vim-scripts.org/vim/scripts.html
"" Plugin 'L9'
"" Git plugin not hosted on GitHub
"" Plugin 'git://git.wincent.com/command-t.git'
"" git repos on your local machine (i.e. when working on your own plugin)
"" Plugin 'file:///home/gmarik/path/to/plugin'
"" The sparkup vim script is in a subdirectory of this repo called vim.
"" Pass the path to set the runtimepath properly.
""Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
"" Install L9 and avoid a Naming conflict if you've already installed a
"" different version somewhere else.
"" Plugin 'ascenator/L9', {'name': 'newL9'}
"
"" All of your Plugins must be added before the following line
"call vundle#end()            " required
"filetype plugin indent on    " required
"" To ignore plugin indent changes, instead use:
""filetype plugin on
""
"" Brief help
"" :PluginList       - lists configured plugins
"" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
"" :PluginSearch foo - searches for foo; append `!` to refresh local cache
"" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
""
"" see :h vundle for more details or wiki for FAQ
"" Put your non-Plugin stuff after this line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" VUNDLE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
