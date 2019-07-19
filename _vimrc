"https://github.com/alisaifee/dotfiles

"""""""""""""""
" global config
""""""""""""""'
" ensure profile is loaded
set shell=zsh
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
set mouse=a
" don't outdent hashes
inoremap # #

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


""""""""""""""'
" plugin setup
""""""""""""""'
let g:pyenv#auto_activate = 1
let g:ycm_python_interpreter_path = '~/.pyenv/shims/python'
let g:ycm_python_sys_path = []
let g:ycm_extra_conf_vim_data = [
  \  'g:ycm_python_interpreter_path',
  \  'g:ycm_python_sys_path'
  \]
let g:ycm_global_ycm_extra_conf = '~/.vim/local/ycm_extra.py'
let g:pathogen_disabled = []
call add(g:pathogen_disabled, "pydoc")
call pathogen#infect()
call pathogen#helptags()


""""""""""""""'
" look and feel
""""""""""""""'
set background=dark
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = 0
let g:gruvbox_improved_warnings = 1

colorscheme gruvbox
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode'],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo', 'percent'], [ 'gitbranch'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

"""""""""""""""""""
" start up commands
""""""""""""""""""'
autocmd StdinReadPre * let s:std_in=1
" open nerdtree automatically if started with a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" close preview window automatically when we move around
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" enable pyenv if found
" clean up dangling spaces on save.
autocmd BufWritePre *.* :%s/\s\+$//e
" Filetype overrides
autocmd BufNewFile,BufRead *.mako,*.mak,*.jinja2,*.jxml setlocal ft=html
autocmd BufNewFile,BufRead *.task setlocal ft=ruby
autocmd FileType html,xhtml,xml,css setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
" Ensure crontab can be saved when edited with vim
autocmd filetype crontab setlocal nobackup nowritebackup


""""""""""""""""""""""'
" plugin configurations
"""""""""""""""""""""""'
" Syntastic Settings
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0

" FZF
let g:fzf_history_dir = "~/.fzf"

""""""""""""""'
" key bindings
""""""""""""""'
let mapleader="-"             " change the leader to be a - vs slash
" sudo write this
cmap W! w !sudo tee % >/dev/null
" TagBarOpen
nmap <leader>o :TagbarToggle<CR>

" Search

let g:rg_command = '
            \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always" --vimgrep
            \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
            \ -g "!{.git,node_modules,vendor}/*" '

command! -bang -nargs=* Rg call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)

map <C-f><C-f> :Files<CR>
map <C-f><C-t> :Tags<CR>
map <C-f><C-b> :Buffers<CR>
map <C-f><C-g> :GFiles<CR>
map <C-f><C-p> :Rg<space>
" Open NerdTree
map <leader>n :NERDTreeToggle<CR>
" open vimrc
map <leader>v :sp ~/.vimrc<CR><C-W>_
" reload vimrc
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
" close current buffer
map <leader>x :bd<CR>
" close current window
nnoremap <leader>q :q<CR>
" hide matches on <leader>space
nnoremap <leader><space> :nohlsearch<cr>
" Remove trailing whitespace on <leader>S
nnoremap <leader>S :%s/\s\+$//<cr>:let @/=''<CR>
" quote string under cursor
:nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
:nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
" ctrl-jklm  changes to that split
map <C-j> <c-w>j
map <C-k> <c-w>k
map <C-l> <c-w>l
map <C-h> <c-w>h
" and lets make these all work in insert mode too ( <C-O> makes next cmd
"  happen as if in command mode )
imap <C-W> <C-O><C-W>
" Buffer navigation
:nnoremap <C-n> :bnext<CR>
:nnoremap <C-p> :bprevious<CR>
" Tab navigation
":nnoremap <C-N> :tabnext<CR>
":nnoremap <C-P> :tabprevious<CR>
" Copy/Paste to mac clipboard
vmap <C-x> :!pbcopy<CR>
vmap <C-c> :w !pbcopy<CR><CR>"
" exit from insert to normal mode
:inoremap jk <esc>
