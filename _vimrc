" =============================================================================
" General
" =============================================================================

set nocompatible
filetype plugin indent on
syntax on

let mapleader=" "

" =============================================================================
" vim-plug — auto-install if missing
" =============================================================================

let data_dir = expand('~/.vim')
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo ' . data_dir . '/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" File tree
Plug 'preservim/nerdtree'

" Git
Plug 'tpope/vim-fugitive'

" Color scheme
Plug 'morhetz/gruvbox'

" LSP client
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'   " auto-installs language servers

" Async completion
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()

" =============================================================================
" Color scheme
" =============================================================================

set background=dark
colorscheme gruvbox

" =============================================================================
" Display
" =============================================================================

set number          " absolute line numbers
set relativenumber  " relative numbers for easy jumping
set cursorline      " highlight current line
set colorcolumn=80  " right-margin guide
set scrolloff=5     " keep lines visible above/below cursor
set sidescrolloff=8
set signcolumn=yes  " always show sign column (LSP, git markers)
set title           " set terminal window title
set showmatch       " briefly jump to matching bracket
set showcmd         " show partial command in status line

" Status line (built-in; no plugin needed)
set laststatus=2
set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)

" =============================================================================
" Editing
" =============================================================================

set expandtab       " spaces, not tabs
set shiftwidth=2
set tabstop=2
set softtabstop=2
set autoindent
set copyindent
set nrformats=      " treat all numbers as decimal (C-a / C-x)

" =============================================================================
" Search
" =============================================================================

set hlsearch
set incsearch
set ignorecase
set smartcase       " override ignorecase when pattern has uppercase

" Clear search highlight with <leader>/
nnoremap <leader>/ :nohlsearch<CR>

" =============================================================================
" Files & history
" =============================================================================

set nobackup
set noswapfile
set history=10000
set undolevels=10000

" Persistent undo — survive restarts
if has('persistent_undo')
  let &undodir = expand('~/.vim/undo')
  silent! call mkdir(&undodir, 'p')
  set undofile
endif

" =============================================================================
" Wild menu / completion
" =============================================================================

set wildmenu
set wildmode=longest:full,full
set wildignore+=*.o,*.pyc,*.class,*/.git/*,*/node_modules/*,*/__pycache__/*

" =============================================================================
" Splits & windows
" =============================================================================

set splitbelow      " horizontal splits open below
set splitright      " vertical splits open to the right

" Move between splits with Ctrl-hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" =============================================================================
" Buffer management
" =============================================================================

nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprev<CR>
nnoremap <leader>bd :bdelete<CR>

" =============================================================================
" NERDTree
" =============================================================================

nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git$', '\.DS_Store$', '__pycache__', '\.pyc$']

" Open NERDTree automatically when Vim is given a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
      \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Close Vim if NERDTree is the only window left
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 &&
      \ exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" =============================================================================
" fzf
" =============================================================================

nnoremap <leader>p :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <leader>h :History<CR>

" =============================================================================
" vim-fugitive (Git)
" =============================================================================

nnoremap <leader>gs :Git<CR>
nnoremap <leader>gl :Git log --oneline<CR>
nnoremap <leader>gb :Git blame<CR>

" =============================================================================
" LSP (vim-lsp + asyncomplete)
" =============================================================================

" Enable diagnostics in the sign column and virtual text
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_signs_enabled = 1
let g:lsp_document_highlight_enabled = 1

" Key bindings — only active when an LSP server is attached
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  nnoremap <buffer> gd <plug>(lsp-definition)
  nnoremap <buffer> gr <plug>(lsp-references)
  nnoremap <buffer> K  <plug>(lsp-hover)
  nnoremap <buffer> <leader>rn <plug>(lsp-rename)
  nnoremap <buffer> [d <plug>(lsp-previous-diagnostic)
  nnoremap <buffer> ]d <plug>(lsp-next-diagnostic)
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" asyncomplete: Tab to accept, Shift-Tab to go back
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? asyncomplete#close_popup() : "\<CR>"

" =============================================================================
" Miscellaneous
" =============================================================================

" Re-source vimrc quickly
nnoremap <leader>sv :source $MYVIMRC<CR>

" Strip trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Return to last cursor position when reopening a file
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   execute "normal! g'\"" |
      \ endif
