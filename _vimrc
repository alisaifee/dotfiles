"https://github.com/alisaifee/dotfiles


let mapleader="-"             " change the leader to be a - vs slash
command! W :w
" sudo write this
cmap W! w !sudo tee % >/dev/null


" -v brings up my .vimrc
" -V reloads it -- making all changes active (have to save first)
map <leader>v :sp ~/.vimrc<CR><C-W>_
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" ctrl-jklm  changes to that split
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h
" and lets make these all work in insert mode too ( <C-O> makes next cmd
"  happen as if in command mode )
imap <C-W> <C-O><C-W>

" Open NerdTree
map <leader>n :NERDTreeToggle<CR>
" Close current buffer 
map <leader>x :bd<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" Run command-t file search
map <c-f> :CommandT<CR>
let g:pathogen_disabled = []
call add(g:pathogen_disabled, "pydoc")
call pathogen#infect()
call pathogen#helptags()

" ==========================================================
" Basic Settings
" ==========================================================
set nocompatible              " Don't be compatible with vi
set maxmempattern=5000
set encoding=utf-8
set showtabline=2
syntax on                     " syntax highlighing
filetype on                   " try to detect filetypes
filetype plugin indent on     " enable loading indent file for filetype
set number                    " Display line numbers
set numberwidth=1             " using only 1 column (and 1 space) while possible
set title                     " show title in console title bar
set wildmenu                  " Menu completion in command mode on <Tab>
set wildmode=full             " <Tab> cycles between all matching choices.

" don't bell or blink
set noerrorbells
set vb t_vb=

" Ignore these files when completing
set wildignore+=*.o,*.obj,.git,*.pyc
set grepprg=ack-grep          " replace the default grep program with ack

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

""" Insert completion
" don't select first item, follow typing in autocomplete
set completeopt=menuone,longest,preview
set pumheight=6             " Keep a small completion window


""" Moving Around/Editing
set cursorline              " have a line indicate the cursor location
set colorcolumn=80            " have a line indicate the cursor location
set ruler                   " show the cursor position all the time
set nostartofline           " Avoid moving cursor to BOL when jumping around
set virtualedit=block       " Let cursor move past the last char in <C-v> mode
set scrolloff=3             " Keep 3 context lines above and below the cursor
set backspace=2             " Allow backspacing over autoindent, EOL, and BOL
set showmatch               " Briefly jump to a paren once it's balanced
set nowrap                  " don't wrap text
set linebreak               " don't wrap textin the middle of a word
set autoindent              " always set autoindenting on
set smartindent             " use smart indent if there is no indent file
set tabstop=4               " <tab> inserts 4 spaces
set shiftwidth=4            " but an indent level is 2 spaces wide.
set softtabstop=4           " <BS> over an autoindent deletes both spaces.
set expandtab               " Use spaces, not tabs, for autoindent/tab key.
set shiftround              " rounds indent to a multiple of shiftwidth
set matchpairs+=<:>         " show matching <> (html mainly) as well
set foldmethod=manual       " allow us to fold on indents
set foldlevel=4             " don't fold by default

" don't outdent hashes
inoremap # #

" close preview window automatically when we move around
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

"""" Reading/Writing
set noautowrite             " Never write a file unless I request it.
set noautowriteall          " NEVER.
set noautoread              " Don't automatically re-read changed files.
set modeline                " Allow vim options to be embedded in files;
set modelines=5             " they must be within the first or last 5 lines.
set ffs=unix,dos,mac        " Try recognizing dos, unix, and mac line endings.

"""" Messages, Info, Status
set ls=2         " allways show status line
set vb t_vb=     " Disable all bells.  I hate ringing/flashing.
set confirm      " Y-N-C prompt if closing with unsaved changes.
set showcmd      " Show incomplete normal mode commands as I type.
set report=0     " : commands always print changed line count.
set shortmess+=a " Use [+]/[RO]/[w] for modified/readonly/written.
set ruler        " Show some info, even without statuslines.
set laststatus=2 " Always show statusline, even if only 1 window.
set ttyfast
set lazyredraw

" displays tabs with :set list & displays when a line runs off-screen
set listchars=tab:>-,eol:$,trail:-,precedes:<,extends:>
set list

""" Searching and Patterns
set ignorecase              " Default to using case insensitive searches,
set smartcase               " unless uppercase letters are used in the regex.
set smarttab                " Handle tabs more intelligently
set hlsearch                " Highlight searches by default.
set incsearch               " Incrementally search while typing a /regex

let g:solarized_termcolors=256
set background=dark
let g:solarized_termcolors=256
colorscheme solarized
hi Normal ctermbg=none


" Paste from clipboard
map <leader>p "+gP

" Quit window on <leader>q
nnoremap <leader>q :q<CR>
"
" hide matches on <leader>space
nnoremap <leader><space> :nohlsearch<cr>

" Remove trailing whitespace on <leader>S
nnoremap <leader>S :%s/\s\+$//<cr>:let @/=''<CR>

" Select the item in the list with enter
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Copy/Paste to mac clipboard
vmap <C-x> :!pbcopy<CR>  
vmap <C-c> :w !pbcopy<CR><CR>"

au BufRead *.js set makeprg=jslint\ %

au BufEnter /private/tmp/crontab.* setl backupcopy=yes


" Use tab to scroll through autocomplete menus
autocmd VimEnter * imap <expr> <Tab> pumvisible() ? "<C-N>" : "<Tab>"
autocmd VimEnter * imap <expr> <S-Tab> pumvisible() ? "<C-P>" : "<S-Tab>"
autocmd VimEnter *.py PyenvActivate
snor <c-j> <esc>i<right><c-r>=TriggerSnippet()<cr>
let g:acp_completeoptPreview=1

function! CheckSpaces()
python << CHECK_SPACES_FOR_TABS
import re
import vim
two_spaces = re.compile("^\s{2}\w+", re.MULTILINE).findall("\n".join(vim.current.buffer[0:100]))
four_spaces = re.compile("^\s{4}\w+", re.MULTILINE).findall("\n".join(vim.current.buffer[0:100]))
tab_size = 2 if two_spaces > four_spaces else 4
vim.command("set tabstop=%d" % tab_size )
vim.command("set softtabstop=%d" % tab_size )
vim.command("set shiftwidth=%d" % tab_size )
CHECK_SPACES_FOR_TABS
endfunction
autocmd BufReadPost * call CheckSpaces()

" clean up dangling spaces on save.
autocmd BufWritePre *.py :%s/\s\+$//e
autocmd BufWritePre *.java :%s/\s\+$//e
autocmd BufWritePre *.rb :%s/\s\+$//e
" Filetype overrides
autocmd BufNewFile,BufRead *.mako,*.mak,*.jinja2,*.jxml setlocal ft=html
autocmd BufNewFile,BufRead *.gradle setlocal ft=groovy
autocmd BufNewFile,BufRead *.task setlocal ft=ruby
autocmd BufNewFile,BufRead *.jxml setlocal ft=html
autocmd FileType html,xhtml,xml,css setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" TagBarOpen
nmap <leader>o :TagbarToggle<CR>

" Powerline
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
" quote string under cursor
:nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
" exit from insert to normal mode
:inoremap jk <esc>
" ensure profile is loaded
set shell=zsh\ -l


" Syntastic Settings
" set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0


" Buffer navigation
"
:nnoremap <C-n> :bnext<CR>
:nnoremap <C-p> :bprevious<CR>

