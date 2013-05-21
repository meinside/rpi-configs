" meinside's vimrc file,
" created by meinside@gmail.com,
" last update: 2013.05.21.
"
"
"
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
"set nocompatible


""""""""""""""""""""""""""""""""""""
" settings for vundle (https://github.com/gmarik/vundle)
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if filereadable(vundle_readme)
	set nocompatible               " be iMproved
	filetype off                   " required!

	set rtp+=~/.vim/bundle/vundle/
	call vundle#rc()

	" let Vundle manage Vundle
	"  " required! 
	Bundle 'gmarik/vundle'

	" add bundles here
	Bundle 'surround.vim'
	Bundle 'matchit.zip'
	Bundle 'ragtag.vim'
	Bundle 'snippetsEmu'
	Bundle 'fugitive.vim'

	filetype plugin indent on     " required!

	"
	" :BundleList          - list configured bundles
	" :BundleInstall(!)    - install(update) bundles
	" :BundleSearch(!) foo - search(or refresh cache first) for foo
	" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
	" see :h vundle for more details or wiki for FAQ
	" NOTE: comments after Bundle command are not allowed..
	"
	""""""""""""""""""""""""""""""""""""
else
	echo "Install vundle: git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle"
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup		" do not keep a backup file, use versions instead
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set cindent
set ai
set smartindent
set nu
set ts=4
set sw=4
set sts=4
set fencs=ucs-bom,utf-8,korea
set termencoding=utf-8
colo evening

" custom key mappings, 11.04.15,
nmap <F2> :30vsplit . <CR>

" for macvim, 09.02.23,
if has("transparency")
	set noimd
	set imi=1
	set ims=-1
  set transparency=20
  set fuoptions=maxvert,maxhorz	" maximize window when :set fu
  win 120 40	" window size (120 x 40)
  colo pablo
endif

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " For ruby
  autocmd FileType ruby,eruby,yaml set ai sw=2 ts=2 sts=2 et

  " For html/javascript
  autocmd FileType htm,html,js,erb set ai sw=2 ts=2 sts=2 et

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")
