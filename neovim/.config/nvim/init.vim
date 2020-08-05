" Basics --------------------------------------- {{{
set nocompatible
syntax on
filetype plugin indent on
" }}}

" Vim plug ------------------------------------- {{{
let s:autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
if !filereadable(s:autoload_plug_path)
  silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs 
        \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}

" Plugins -------------------------------------- {{{
call plug#begin('~/.config/nvim/plugged')
Plug 'sheerun/vim-polyglot'
Plug 'machakann/vim-sandwich'
Plug 'romainl/vim-qf'
Plug 'romainl/vim-cool'
Plug 'neovim/nvim-lsp'
Plug 'lifepillar/vim-mucomplete'

Plug 'tpope/vim-fugitive' |
      \ Plug 'tpope/vim-rhubarb'
Plug 'junegunn/fzf', {  'dir': '~/.fzf', 'do': { -> fzf#install() } }
      \ | Plug 'junegunn/fzf.vim'
Plug 'vim-test/vim-test' |
      \ Plug 'skywind3000/asyncrun.vim'

if executable('ctags')
  Plug 'ludovicchabant/vim-gutentags'
endif
call plug#end()
" }}}

" Core settings -------------------------------- {{{
set autoindent
set backspace=indent,eol,start
set hidden
set incsearch
set ruler
set wildmenu
set wildignore+=*/node_modules/*,*/__pycache__/*
set expandtab 
set nowrap
set hidden
set nobackup
set nowritebackup
set shiftwidth=2
set smarttab
set softtabstop=0 
set tabstop=4 
set cmdheight=1
set updatetime=50
set shortmess+=c
set ignorecase incsearch smartcase
set inccommand=split
set exrc
set secure
set undofile
let &undodir = stdpath('data') . '/undo'
set number
set relativenumber
set completeopt-=preview
set completeopt+=menuone,noselect,noinsert
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-column\ --smart-case\ --color=never
endif
set cursorline
set path+=src/**,static/,config/,head/**,frontend/**
set errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
" }}}

" Statusline ----------------------------------- {{{
set laststatus=2
set statusline=
set statusline+=%<\ 
set statusline+=[%n%H%M%R%W]%*\ 
set statusline+=%-.40{pathshorten(expand('%:~:.'))}\ 
set statusline+=%#StatusLineError#
set statusline+=%{exists('*FugitiveStatusline')?FugitiveStatusline():''}%*\ 
set statusline+=%=%y%*%*\ 
set statusline+=%10((%l,%c)%)\ 
set statusline+=%P
" }}}

" Colors --------------------------------------- {{{
if has('termguicolors')
  set termguicolors
  if exists('$TMUX')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
endif
set background=dark
colorscheme plain
" }}}

" Autocommands --------------------------------- {{{
augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END
augroup close_preview
  autocmd!
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif
augroup END
" }}}

" Mappings ------------------------------------- {{{
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
nnoremap <Space>es :sp <C-R>=expand("%:.:h") . "/"<CR>
nnoremap <Space>ev :vs <C-R>=expand("%:.:h") . "/"<CR>
nnoremap <Space>ew :e <C-R>=expand("%:.:h") . "/"<CR>
nnoremap <Space>x :bn<CR>:bd#<CR>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
" FZF.vim -------------------------------------- {{{
nnoremap <silent> <C-b> :Buffers<cr>
nnoremap <silent> <C-f> :Files<cr>
nnoremap <silent> <C-_> :BLines<cr>
" }}}
" Fugitive ------------------------------------- {{{
nnoremap <Space>gs :Gstatus<CR>
" }}}
" }}}

" Providers ------------------------------------ {{{
" Python2 -------------------------------------- {{{
let g:loaded_python_provider = 0
" }}}
" Python3 -------------------------------------- {{{
let s:workon_home = !empty($WORKON_HOME) ? expand($WORKON_HOME) : expand('$HOME/.virtualenvs')
let s:workon_python = printf('%s/neovim/bin/python', s:workon_home)
if filereadable(s:workon_python)
  let g:python3_host_prog = s:workon_python
elseif executable('python3')
  let g:python3_host_prog = exepath('python3')
endif
" }}}
" Node.js -------------------------------------- {{{
if executable('neovim-node-host')
  let g:node_host_prog = exepath('neovim-node-host')
endif
" }}}
" Ruby ----------------------------------------- {{{
let s:ruby_host = expand('$GEM_HOME/bin/neovim-ruby-host')
let s:ruby_host_exists = filereadable(s:ruby_host)
let s:available_hosts = map(glob('~/.gem/ruby/*/bin/neovim-ruby-host', 0, 1), 'shellescape(v:val, 1)')
if executable('neovim-ruby-host')
  let g:ruby_host_prog = exepath('neovim-ruby-host')
elseif !empty($GEM_HOME) && s:ruby_host_exists
  let g:ruby_host_prog = s:ruby_host
elseif len(s:available_hosts)
  let g:ruby_host_prog = s:available_hosts[-1]
endif
" }}}
" }}}

" FZF.vim -------------------------------------- {{{
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
let $FZF_DEFAULT_OPTS = '--reverse'
let g:fzf_history_dir = stdpath('cache') . '/fzf-history'
let g:fzf_layout = { 'window': { 'width': 0.6, 'height': 0.6 } }
let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
" }}}

" Vim-test ------------------------------------- {{{
let test#strategy = "asyncrun_background_term"
" }}}

" Gutentags ------------------------------------ {{{
let g:gutentags_modules = ['ctags']
let g:gutentags_cache_dir = stdpath('cache') . '/tags'

if !isdirectory(g:gutentags_cache_dir)
  call mkdir(g:gutentags_cache_dir, "p")
endif
" }}}

" Vim-QF --------------------------------------- {{{
let g:qf_auto_open_quickfix = 1
let g:qf_auto_open_loclist = 1
let g:qf_shorten_path = 0
let g:qf_auto_resize = 1
let g:qf_mapping_ack_style = 1
" }}}

" MUcomplete ----------------------------------- {{{
let g:mucomplete#enable_auto_at_startup = 1
"  }}}
