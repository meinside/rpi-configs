" meinside's vimrc file,
" created by meinside@gmail.com,
" last update: 2014.08.11.


""""""""""""""""""""""""""""""""""""
" settings for vundle (https://github.com/gmarik/vundle)
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if filereadable(vundle_readme)
	set nocompatible               " be iMproved
	filetype off                   " required!

	set rtp+=~/.vim/bundle/vundle/
	call vundle#rc()

	" let Vundle manage Vundle
	" required!
	Bundle 'gmarik/vundle'

	""""""""
	" add bundles here
	"
	Bundle 'surround.vim'
	Bundle 'matchit.zip'
	Bundle 'ragtag.vim'
	Bundle 'snippetsEmu'
	Bundle 'fugitive.vim'
	Bundle 'tpope/vim-endwise'

	" For uploading Gist
	Bundle 'mattn/webapi-vim'
	Bundle 'mattn/gist-vim'

	" For Ruby
	Bundle 'tpope/vim-bundler'
	Bundle 'dasch/vim-rack'

	" CoffeeScript
	Bundle 'kchmck/vim-coffee-script'

	" Clojure
	Bundle 'guns/vim-clojure-static'

	" Go
	Bundle 'jnwhiteh/vim-golang'

	" CSS
	Bundle 'cakebaker/scss-syntax.vim'

	" HAML
	Bundle 'tpope/vim-haml'

	"
	""""""""

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

" for color schemes
set t_Co=256
colo elflord

" custom key mappings, 2011.04.15,
nmap <F2> :30vsplit . <CR>

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
	autocmd FileType ruby,eruby,yaml,ru set ai sw=2 ts=2 sts=2 et

	" For html/javascript/coffee/css
	autocmd FileType htm,html,erb,haml,js,coffee set ai sw=2 ts=2 sts=2 et
	autocmd FileType css,scss set ai sw=2 ts=2 sts=2 et

	" For other programming languages
	autocmd FileType clj set ai sw=2 ts=2 sts=2 et
	autocmd FileType go set ai sw=4 ts=4 sts=4 noet

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
