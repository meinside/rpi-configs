" meinside's vimrc file,
"
" created by meinside@gmail.com,
" last update: 2016.04.01.
"
" $ sudo update-alternatives --config editor


""""""""""""""""""""""""""""""""""""
" settings for vundle (https://github.com/VundleVim/Vundle.vim)
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if filereadable(vundle_readme)
	set nocompatible              " be iMproved, required
	filetype off                  " required

	" set the runtime path to include Vundle and initialize
	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin()
	" alternatively, pass a path where Vundle should install plugins
	"call vundle#begin('~/some/path/here')

	" let Vundle manage Vundle, required
	Plugin 'VundleVim/Vundle.vim'

	""""""""
	" add bundles here

	" Useful plugins
	Plugin 'surround.vim'
	Plugin 'matchit.zip'
	Plugin 'ragtag.vim'
	Plugin 'snippetsEmu'
	Plugin 'fugitive.vim'
	Plugin 'tpope/vim-endwise'

	" For source file browsing
	" XXX: ctags and vim-nox is needed!
	Plugin 'majutsushi/tagbar'
	nmap <F8> :TagbarToggle<CR>

	" For uploading Gist
	Plugin 'mattn/webapi-vim'
	Plugin 'mattn/gist-vim'

	" For Ruby
	Plugin 'vim-ruby/vim-ruby'

	" Go
	Plugin 'fatih/vim-go'

	" CSS
	Plugin 'cakebaker/scss-syntax.vim'

	" For statusline/tabline configuration
	Plugin 'itchyny/lightline.vim'
	set laststatus=2
	let g:lightline = {
	      \ 'colorscheme': 'wombat',
	      \ }

	"
	""""""""

	" All of your Plugins must be added before the following line
	call vundle#end()            " required
	filetype plugin indent on    " required
	" To ignore plugin indent changes, instead use:
	"filetype plugin on
	"
	" Brief help
	" :PluginList       - lists configured plugins
	" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
	" :PluginSearch foo - searches for foo; append `!` to refresh local cache
	" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
	"
	" see :h vundle for more details or wiki for FAQ
	" Put your non-Plugin stuff after this line
else
	echo "Install vundle: git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim"
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup	" do not keep a backup file, use versions instead
set history=50	" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch	" do incremental searching
set cindent
set ai
set smartindent
set nu
set ts=4
set sw=4
set sts=4
set fencs=ucs-bom,utf-8,korea
set termencoding=utf-8
set wildmenu   " visual autocomplete for command menu

" for color schemes
set t_Co=256
colo elflord

" custom key mappings, 2011.04.15,
nmap <F2> :30vsplit . <CR>

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

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
