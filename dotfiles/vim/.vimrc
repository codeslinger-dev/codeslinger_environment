" ----------------------------------------------------------------------------
" -- VIM / GVIM Configuration ------------------------------------------------
"
" This file, along with the contents of the '~./vim' folder define a basic
" VIM/GVIM configuration, primarily targeted at code-editing (c/c++/make),
" but still suitable for other editing activities and file-types.
"
" A few productivity plugins are provided and enabled by default:
" (for versions >= 7.0)
"
"  - 'lightline'  Plugin that gives a colorized status bar at
"                 the bottom of the window that dynamically
"                 updates to reflect the status of the current
"                 buffer (file) as well as the current MODE
"
"  - 'rainbow'    Plugin that color-codes parentheses, brackets,
"                 and braces.  Modulates the color when these
"                 items are nested, in order to provides a
"                 visual aid in matching elements
" ----------------------------------------------------------------------------


" -- Setup (Compatibiity & Behavior) -----------------------------------------
set nocompatible                " -- disable vi compatibility (do this first)
source $VIMRUNTIME/mswin.vim    " -- MS Windows-like cut/paste behavior
behave mswin                    " -- MS Windows-like mouse behavior


" -- Setup (Plugins Path) ----------------------------------------------------
set runtimepath^=~/.vim/plugin/ " -- add plugin path to VIM search path
set runtimepath^=~/.vim/after/  " -- add after  path to VIM search path
set runtimepath^=~/.vim/        " -- add ~/.vim path to VIM search path


" -- Setup (Window) ----------------------------------------------------------
colorscheme koehler_modified    " -- custom scheme located in ~/.vim/colors
syntax enable                   " -- syntax highlighing and processing
set number                      " -- show line numbers

if version >=700
  set numberwidth=5             " -- width of numbers (default is 4)
  set cursorline                " -- highlight line containing cursor
endif

set wildmenu                    " -- graphical auto-complete menu
set lazyredraw                  " -- don't update screen w/ macro and scripts


" -- Setup (Window - in support of specific plugins) -------------------------
if version >=700
  set noruler                   " -- plugin:lightline displays a ruler
  set noshowmode                " -- plugin:lightline displays the mode
  set laststatus=2              " -- plugin:lightline & command line
  let g:rainbow_active = 1      " -- plugin:rainbow color-codes matches braces
else
  set ruler                     " -- displays a ruler
  set showmode                  " -- displays the mode
  set laststatus=1              " -- display a command line
endif


" -- Setup (Window GUI vs Console) -------------------------------------------
if has("gui_running")

  if has('win32') || has('win64')
    set guifont=Consolas:h10    " -- set font
    set guioptions+=T           " -- enable GUI toolbar
  else
    set guifont=Monospace\ 10   " -- set font
    set guioptions-=T           " -- disable GUI toolbar
  endif

  set guiheadroom=62            " -- resevre pixels for gui elements

  set lines=199                 " -- set window height (max)
  set columns=87                " -- set window width

  set nowrap                    " -- don't wrap long lines
  set textwidth=0               " -- really, don't wrap long lines
  set wrapmargin=0              " -- really, don't wrap long lines
  set formatoptions-=tc         " -- really, don't wrap long lines
  set formatoptions-=t          " -- really, don't wrap long lines
  set formatoptions-=c          " -- really, don't wrap long lines
  set formatoptions+=l          " -- really, don't wrap long lines
  set guioptions+=b             " -- enable bottom scrollbar

  set foldmethod=manual         " -- manual fold
  set foldnestmax=3             " -- deepest fold is 3 levels
  set nofoldenable              " -- don't fold by default
else
                                "  - console-specific setup here
endif


" -- Setup (Indention) -------------------------------------------------------
set tabstop=4                   " -- number of visual spaces per tab
set softtabstop=4               " -- number of spaces per tab


" -- Setup (Indention - replaces tabs w/ spaces for C/C++ files) -------------
autocmd FileType c,cpp set expandtab


" -- Setup (Editing) ---------------------------------------------------------
set hidden                      " -- keeps buffers open when changing files
set history=999                 " -- increase history (default = 20)
set undolevels=999              " -- increase undo history (default=100)
set showmatch                   " -- highlight matching blocks [{()}]
set matchtime=6                 " -- highlight matches for 0.x seconds
set linebreak                   " -- avoid wrapping in the middle of a word
set backspace=indent,eol,start  " -- allow backspace over everything (insert)


" -- Setup (Visualize trailing spaces and tabs) ------------------------------
set list
let c_space_errors=1

if version >=700
  set listchars=tab:>-,trail:-,nbsp:?
else
  set listchars=tab:>-,trail:-
endif

set fillchars=fold:-


" -- Setup (C-style comment auto-completion) ---------------------------------
autocmd FileType c,cpp  set comments=sl:\/*,mb:**\ ,ex:*\/,:\/\/


" -- Setup (C indenting rules) -----------------------------------------------
autocmd FileType c,cpp  set cindent
autocmd FileType c,cpp  set cinwords=if,else,while,do,for,switch,case


" -- Setup (Searching) -------------------------------------------------------
set hlsearch                    " -- highlight matches
set incsearch                   " -- search as characters are entered
set smartcase                   " -- be smart about case-matching
set ignorecase                  " -- ignore case when searching


" -- Setup (ensure line wrapping is disabled) --------------------------------
set nowrap                      " -- don't wrap long lines
set textwidth=0                 " -- really, don't wrap long lines
set formatoptions-=tc           " -- really, don't wrap long lines
set formatoptions-=t            " -- really, don't wrap long lines
set formatoptions-=c            " -- really, don't wrap long lines
set formatoptions+=l            " -- really, don't wrap long lines


" -- End of File  ------------------------------------------------------------
" ----------------------------------------------------------------------------
