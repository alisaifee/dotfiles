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
" replace the default grep program with rg
set grepprg=rg

""" Insert completion
" don't select first item, follow typing in autocomplete
set completeopt=menuone,longest,preview
set pumheight=6             " Keep a small completion window


""" Moving Around/Editing
set cursorline              " have a line indicate the cursor location
set colorcolumn=79            " have a line indicate the cursor location
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
set autoread              " Don't automatically re-read changed files.
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
let g:ycm_python_sys_path = []
let g:ycm_python_interpreter_path = '~/.asdf/shims/python'
let g:ycm_extra_conf_vim_data = [
 \  'g:ycm_python_interpreter_path',
 \  'g:ycm_python_sys_path'
\]
let g:ycm_global_ycm_extra_conf = '~/.vim/local/ycm_extra.py'
let g:pathogen_disabled = ['pydoc']
call pathogen#infect()
call pathogen#helptags()

let NERDTreeShowBookmarks=1
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools', 'CodeLLDB' ]
let g:vimspector_sign_priority = {
  \    'vimspectorBP':         666,
  \    'vimspectorBPCond':     666,
  \ }
nmap <S-F5> :VimspectorReset<CR>
vmap <Leader><F10> <Plug>VimspectorReset
nmap <Leader>di <Plug>VimspectorBalloonEval
vmap <Leader>di <Plug>VimspectorBalloonEval


""""""""""""""'
" look and feel
""""""""""""""'
set background=dark
set termguicolors
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = 0
let g:gruvbox_improved_warnings = 1

colorscheme gruvbox

"""""""""""""""""""
" start up commands
""""""""""""""""""'
autocmd StdinReadPre * let s:std_in=1
" open nerdtree automatically if started with a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" close preview window automatically when we move around
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" clean up dangling spaces on save.
autocmd BufWritePre *.* :%s/\s\+$//e
" Filetype overrides
autocmd BufNewFile,BufRead *.mako,*.mak,*.jinja2,*.jxml setlocal ft=html
autocmd BufNewFile,BufRead *.task,*.pp setlocal ft=ruby
autocmd BufNewFile,BufRead *.tsx set filetype=typescript
autocmd BufNewFile,BufRead *.jsx set filetype=javascript
autocmd BufNewFile,BufRead *.zsh set filetype=sh
autocmd FileType html,xhtml,xml,css setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
" Ensure crontab can be saved when edited with vim
autocmd filetype crontab setlocal nobackup nowritebackup


""""""""""""""""""""""'
" plugin configurations
"""""""""""""""""""""""'
" vim-go
let g:go_def_mapping_enabled = 0
" ALE
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
let g:ale_use_global_executables = 1
highlight link ALEWarningSign String
highlight link ALEErrorSign Title
let g:ale_linters = {
\    "rst": ["proselint", "write-good"],
\    "python": ["mypy", "flake8", "black"],
\    "yaml": ["yamllint"],
\    "zsh": ["shfmt", "shellcheck"],
\    "sh": ["shfmt", "shellcheck"],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'css': ['prettier', 'stylelint'],
\   'json': ['jq'],
\   'javascript': ['eslint'],
\   'javascript.jsx': ['eslint'],
\   'javascriptreact': ['eslint'],
\   'typescript': ['eslint'],
\   'python': ['black', 'isort', 'add_blank_lines_for_python_control_statements', 'reorder-python-imports'],
\   'ruby': ['rubocop'],
\   'go': ['gofmt'],
\   'elixir': ['credo'],
\   'html': ['prettier'],
\   'rust': ['rustfmt'],
\   'sh': ['shfmt'],
\   'zsh': ['shfmt'],
\}
" FZF
let g:fzf_history_dir = "~/.fzf"
" AutoFormat
let g:formatter_yapf_style = 'pep8'

" Search
let g:rg_command = '
            \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
            \ -g "*.{js,json,php,md,styl,jade,html,config,py,pyi,cpp,c,go,hs,rb,conf,tilt,star}"
            \ -g "!{.git,node_modules,vendor}/*" '
"
"command! -bang -nargs=* Rg call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/bundle/fzf.vim/bin/preview.sh {}']}, <bang>0)


" Lightline
"
function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ▲', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return "✓"
endfunction

function! LightlineFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

autocmd User ALELint call lightline#update()
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode'],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [
      \     [ 'lineinfo', 'percent'], [ 'gitbranch'],
      \     [ 'ale_error', 'ale_warning', 'ale_ok', 'filetype']
      \   ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'filetype': 'LightlineFiletype',
      \ },
      \ 'component_expand' : {
      \   'ale_error': 'LightlineLinterErrors',
      \   'ale_warning': 'LightlineLinterWarnings',
      \   'ale_ok': 'LightlineLinterOK'
      \ },
      \ 'componment_type': {
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error'
      \ }
      \ }
""""""""""""""'
" key bindings
""""""""""""""'
let mapleader="-"             " change the leader to be a - vs slash
" sudo write this
cmap W! w !sudo tee % >/dev/null
" TagBarOpen
nmap <leader>o :TagbarToggle<CR>
" Code completion
nnoremap <C-]> :YcmCompleter GoTo<CR>
nnoremap <C-LeftMouse> :YcmCompleter GoTo<CR>

nnoremap <C-RightMouse> :YcmCompleter GoToReferences<CR>

nnoremap <Leader>rr :YcmCompleter RefactorRename
" Code completion
nnoremap <silent> <Leader>= :ALEFix<CR>

" Search
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)


" Search
map <C-f><C-f> :Files<CR>
map <C-f><C-t> :Tags<CR>
map <C-f><C-b> :Buffers<CR>
map <C-f><C-g> :GFiles<CR>
map <C-f><C-p> :Rg<CR>
" Open NerdTree
map <leader>n :NERDTreeToggle<CR>
map <leader>nf :NERDTreeFind<CR>
" open vimrc
map <leader>v :e ~/.vimrc<CR><C-W>_
" reload vimrc
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
" close current buffer
" map <leader>x :bd<CR>
nnoremap <C-X> :bp<cr>:bd #<cr>
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
" Copy/Paste to mac clipboard
vmap <C-x> :!pbcopy<CR>
vmap <C-c> :w !pbcopy<CR><CR>"
" exit from insert to normal mode
:inoremap jk <esc>

" Devicons
if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" Align tables
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>


set t_RV=
