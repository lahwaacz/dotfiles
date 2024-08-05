set nocompatible
set ttyfast

" Tabs, spaces, indentation, wrapping
set expandtab                           " use spaces for tabs
set tabstop=4                           " number of spaces to use for tabs
set shiftwidth=4                        " number of spaces to autoindent
set softtabstop=4                       " number of spaces for a tab
set autoindent                          " set autoindenting on
set smartindent                         " automatically insert another level of indent when needed
if has('breakindent')                   " not available before 7.4.338, see https://retracile.net/blog/2014/07/18/18.00
    set breakindent                     " autoindent wrapped lines, see https://retracile.net/wiki/VimBreakIndent
    autocmd FileType python,c,cpp setlocal breakindentopt=shift:4    " shift wrapped lines another 4 chars
endif
set linebreak                           " break at character in 'breakat' rather than at the last character that fits on the screen
set backspace=indent,eol,start          " more flexible backspace
"retab                                   " spaces instead of tabs
set list                                " apply highlighting as per listchars
"set listchars=tab:␉·,trail:␠,nbsp:⎵     " highlighting of special white-space characters
set listchars=tab:»·,trail:·            " highlighting of special white-space characters

" Backup
set nobackup                            " don't backup files
set nowritebackup
set noswapfile

" Searching
set hlsearch                            " highlight search terms
set incsearch                           " show search matches as you type
set ignorecase                          " ignore case when searching
set smartcase                           " make searches case sensitive only if they contain uppercase stuff

" Encoding
set encoding=utf-8                      " use utf-8 everywhere
set fileencoding=utf-8                  " use utf-8 everywhere
set termencoding=utf-8                  " use utf-8 everywhere

" Various
set ruler                               " show the cursor position
set scrolloff=5                         " show 5 lines above/below the cursor when scrolling
set number                              " show numbers
set showcmd                             " shows the command in the last line of the screen
set autoread                            " read files when they've been changed outside of Vim
set showmatch                           " matching brackets & the like
set tabpagemax=25                       " max number of tabs that can be opened with '-p' option
set fillchars="fold:\ "                 " fill fold lines with spaces instead of dashes

set history=500                         " number of command lines stored in the history tables
set undolevels=500                      " number of levels of undo
set sessionoptions-=options             " don't store any options and mappings (global and local values)

set splitright                          " open new vertical split windows to the right of the current one, not the left
set splitbelow                          " same as above - opens new windows below, not above
set wildignorecase                      " ignore case when completing file names and directories
set wildmenu                            " enable enhanced command-line completion
set wildmode=longest,list,full          " file and directory matching mode
set notitle                             " don't set xterm window title
set nrformats=hex                       " allow incrementing and decrementing numbers that start with 0 using <c-a> and <c-x>
set clipboard+=unnamedplus              " use + register (X Window clipboard) as unnamed register"
set viminfo='100,<1000,s10,h            " large registers (for copying between sessions)

if !exists('g:vscode')

set guifont=Monospace\ 9                " font in gvim

" Load pathogen.vim (manage runtime path)
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Load vim-plug plugins
" Note: some useful commands to manage the pugins:
" :PlugInstall to install the plugins
" :PlugUpdate to install or update the plugins
" :PlugDiff to review the changes from the last update
" :PlugClean to remove plugins no longer in the list
call plug#begin()
    " https://github.com/ellisonleao/gruvbox.nvim
    Plug 'ellisonleao/gruvbox.nvim'
    " https://github.com/rebelot/kanagawa.nvim
    Plug 'rebelot/kanagawa.nvim'
    " https://github.com/shaunsingh/solarized.nvim
    Plug 'shaunsingh/solarized.nvim'
    " https://github.com/craftzdog/solarized-osaka.nvim
    Plug 'craftzdog/solarized-osaka.nvim'
call plug#end()

syntax on                               " syntax highlighting
filetype plugin on                      " load file type plugins
filetype indent on                      " load file type based indentation
" disable file type based indentation for cmake files  https://superuser.com/a/865581
autocmd FileType cmake let b:did_indent = 1
autocmd FileType cmake setlocal indentexpr=


" colorscheme
if &t_Co < 256
    " colorscheme for the 8 color linux term
    colorscheme vim
else
    set background=dark
    colorscheme solarized-osaka
endif


" Map keys to toggle functions
function! MapToggle(key, opt)
    let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
    exec 'nnoremap '.a:key.' '.cmd
    exec 'inoremap '.a:key." \<C-O>".cmd
endfunction
command! -nargs=+ MapToggle call MapToggle(<f-args>)

" Keys & functions
MapToggle <F4> number
MapToggle <F5> spell
MapToggle <F6> paste
MapToggle <F7> hlsearch
MapToggle <F8> wrap

" Map F1 to Esc instead of the stupid help crap
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" space bar un-highligts search
:noremap <silent> <Space> :silent noh<Bar>echo<CR>

" Make a curly brace automatically insert an indented line
"inoremap {<CR> {<CR>}<Esc>O<BS><Tab>

" Make jj exit insert mode (since it's almost never typed normally)
"imap jj <Esc>:w<CR>
"imap kk <Esc>:w<CR>
imap jj <Esc>
imap kk <Esc>

" Tab navigation
nnoremap <C-h> :tabprevious<CR>
nnoremap <C-l> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>
nnoremap <C-n> :tabnext<CR>
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <silent> <C-S-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <C-S-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>


" jumps to the last known position in a file just after opening it
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" automatic absolute/relative numbers toggling
"set relativenumber
"autocmd InsertEnter * :set number
"autocmd InsertLeave * :set relativenumber

" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
" ref: http://vim.wikia.com/wiki/Keep_folds_closed_while_inserting_text
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

" force wrapping of long lines in diff mode
autocmd FilterWritePre * if &diff | setlocal wrap< | endif

" Removes trailing whitespace
function TrimWhiteSpace()
    %s/\s\+$//e
endfunction
map <F2> :call TrimWhiteSpace()<CR>

" spell checking
set spelllang=en,cs
set spellfile=$XDG_DATA_HOME/nvim/site/spell/custom.utf-8.add   " my whitelist
autocmd FileType tex,text,markdown,mediawiki,rst setlocal spell
autocmd FileType help setlocal nospell    " help pages are first recognized as 'text' and then set to 'help'

" Syntax based folding for C-family languages
autocmd FileType c,cpp setlocal foldmethod=syntax
autocmd FileType c,cpp setlocal foldnestmax=2
" open all folds by default in tex files
autocmd FileType tex normal zR

" textwidth
autocmd FileType gitcommit setlocal textwidth=72
autocmd FileType rst setlocal textwidth=80

endif "!exists('g:vscode')
