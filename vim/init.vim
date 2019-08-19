"""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""

set encoding=utf-8  " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.
syntax on " Enable syntax highlight

"""""""""""""""""""""""""""""""""""""""""""""""
" => Install plug and plugins if missing
"""""""""""""""""""""""""""""""""""""""""""""""

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

"""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins List
"""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin()

" nord-vim colorscheme
Plug 'arcticicestudio/nord-vim'

" JavaScript Highlight & Improved Indentation
Plug 'pangloss/vim-javascript'

" NERDTree
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug 'Xuyuanp/nerdtree-git-plugin'

" ctrlp.vim
Plug 'kien/ctrlp.vim'

" .editorconfig
Plug 'editorconfig/editorconfig-vim'

" emmet
Plug 'mattn/emmet-vim'

" syntastic
Plug 'vim-syntastic/syntastic'

" Rust
Plug 'rust-lang/rust.vim'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Related Configs"""""""""""""""""""""""""""""""""""""""""""""""

" Open NERDTree automatically when vim starts up
" autocmd vimenter * NERDTree
" NERDTree
" let NERDTreeShowHidden=1
map <silent> <C-n> :NERDTreeToggle<CR>

" DO NOT close NERDTree after a file is opened
let g:NERDTreeQuitOnOpen=0

" ctrlp
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard'] " only show files that are not ignored by git

" syntastic eslint checks
let g:neomake_javascript_enabled_makers=['eslint']"

" enable highlight for JSDocs
let g:javascript_plugin_jsdoc = 1

" show bookmarks on startup
let NERDTreeShowBookmarks=1

" How can I close vim if the only window left open is a NERDTree?
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"""""""""""""""""""""""""""""""""""""""""""""""
" => Visual Related Configs
"""""""""""""""""""""""""""""""""""""""""""""""

" 256 colors
set t_Co=256

" set colorscheme
colorscheme desert

" long lines as just one line (have to scroll horizontally)
set nowrap

" line numbers
set relativenumber
set number

" show the status line all the time
set laststatus=2

" toggle invisible characters
set invlist
set list
set listchars=tab:¦\ ,eol:¬,trail:⋅,extends:❯,precedes:❮

"""""""""""""""""""""""""""""""""""""""""""""""
" => Keymappings
"""""""""""""""""""""""""""""""""""""""""""""""

" copy and paste to/from vIM and the clipboard
nnoremap <C-y> +y
vnoremap <C-y> +y
nnoremap <C-p> +P
vnoremap <C-p> +P

" access system clipboard
set clipboard=unnamed

" swapfiles location
set backupdir=/tmp//
set directory=/tmp//

"""""""""""""""""""""""""""""""""""""""""""""""
" => Indentation
"""""""""""""""""""""""""""""""""""""""""""""""

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
" :help smarttab
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Auto indent
" Copy the indentation from the previous line when starting a new line
set ai

" Smart indent
" Automatically inserts one extra level of indentation in some cases, and works for C-like files
set si

set ttimeoutlen=100


"""""""""""""""""""""""""""""""""""""""""""""""
" => Buffers
" Remap CRTL-\ for switching buffers + hidden (so i can switch unsaved)
"""""""""""""""""""""""""""""""""""""""""""""""

set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>
nnoremap <C-\> :b <C-Z>
set hidden

" disable swapfile (maybe we want to re-eanble for big files)
set noswapfile
