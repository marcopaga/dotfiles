set nocompatible

" Pathogen
call pathogen#infect()
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
 
set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)
filetype plugin indent on
 
syntax on
set number
set hlsearch
set showmatch
set incsearch
set ignorecase
set autoindent
set copyindent

set history=1000
set undolevels=1000

set cursorline
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set title

" C-a and C-x interpret every number as decimal formatted 
set nrformats=

set nobackup
set noswapfile

set background=dark
colorscheme wombat
