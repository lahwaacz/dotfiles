set nocompatible

" Tabs, Spaces and Indentation.
set expandtab           " Use spaces for tabs.
set tabstop=4           " Number of spaces to use for tabs.
set shiftwidth=4        " Number of spaces to autoindent.
set softtabstop=4       " Number of spaces for a tab.
set autoindent          " Set autoindenting on.
set smartindent         " Automatically insert another level of indent when needed. 
retab

" Backup.
set nobackup            " Don't backup files.
set nowritebackup
set noswapfile

" Searching.
set hlsearch            " Highlight search terms
set incsearch           " Show search matches as you type
set ignorecase          " Ignore case when searching
set smartcase           " Make searches case sensitive only if they contain uppercase stuff

" Various.
set ruler               " Show the cursor position.
set scrolloff=5         " Show 5 lines above/below the cursor when scrolling.
set number              " Line numbers on.
set showcmd             " Shows the command in the last line of the screen.
set autoread            " Read files when they've been changed outside of Vim.

" Encoding.
set encoding=utf-8      " use utf-8 everywhere
set fileencoding=utf-8  " use utf-8 everywhere
set termencoding=utf-8  " use utf-8 everywhere

set history=1000        " Number of command lines stored in the history tables.
set undolevels=1000     " Number of levels of undo

" Set console title and reset it when exiting
if &term != "builtin_gui"
    let &titleold=getcwd()
    set title
endif

syntax on               " Syntax highlighting on.
set t_Co=256

set splitright          " Open new vertical split windows to the right of the current one, not the left.
set splitbelow          " See above description. Opens new windows below, not above.

set backspace=indent,eol,start          " More flexible backspace.

set wildmode=longest,list               " File and directory matching mode.

set nrformats=hex                       " Allow incrementing and decrementing numbers that start with 0 using <c-a> and <c-x>

set clipboard=unnamedplus,autoselect    " Use + register (X Window clipboard) as unnamed register"

set ttyfast

" Map keys to navigate tabs
map <C-h> :tabprevious<CR>
map <C-l> :tabnext<CR>

" Map F1 to Esc instead of the stupid help crap.
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Make a curly brace automatically insert an indented line
inoremap {<CR> {<CR>}<Esc>O<BS><Tab>

" Make jj exit insert mode (since it's almost never typed normally).
imap jj <Esc>:w<CR>
imap kk <Esc>:w<CR>
