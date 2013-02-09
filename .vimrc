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

syntax on               " Syntax highlighting on.
filetype plugin indent on             " filetype detection
au BufNewFile,BufRead *.log set filetype=messages       " syntax highlighting in all *.log files
"set t_Co=256            " usually not needed

" colorscheme
let g:solarized_termcolors=256
if has('gui_running')
    set background=light
else
    set background=dark
endif
colorscheme solarized

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

" Temporarily disable search highlight until next search
"nnoremap <esc> :noh<return><esc>

" Automatic hard-wrapping for *.tex files
autocmd FileType tex    set textwidth=120

" LaTeX compiler (use my custom Makefile actually)
function MakeLaTeX()
    :w
    :make
endfunction
autocmd FileType tex    set makeprg=make\ -j2\ pdf\ nocolor=1
autocmd FileType tex    map <C-m> :call MakeLaTeX()<CR>

" Comment out a range of lines (default settings)
map - :s/^/\#/<CR>:nohlsearch<CR>

" Comment out a range of lines (per-language settings)
autocmd FileType tex    map - :s/^/\%/<CR>:nohlsearch<CR>
autocmd FileType vim    map - :s/^/\"/<CR>:nohlsearch<CR>
autocmd FileType c,cpp  map - :s/^/\/\//<CR>:nohlsearch<CR>

" Clear all comment markers (one rule for all languages)
map _ :s/^\/\/\\|^--\\|^> \\|^[#"%!;]//<CR>:nohlsearch<CR>

" Removes trailing whitespace
function TrimWhiteSpace()
    %s/\s\+$//e
endfunction
map <F2> :call TrimWhiteSpace()<CR>
