" meinside's vimrc file,
"
" created by meinside@gmail.com,
" last update: 2017.07.14.
"
" $ sudo update-alternatives --config editor
"
" XXX - for nvim:
" $ sudo pip install --upgrade neovim
" $ mkdir -p ~/.config/nvim
" $ ln -sf ~/.vimrc ~/.config/nvim/init.vim

""""""""""""""""""""""""""""""""""""
" settings for vundle (https://github.com/VundleVim/Vundle.vim)
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
let vundle_fresh=0
if !filereadable(vundle_readme)
	echo "Installing Vundle..."
	echo ""

	silent execute "!git clone https://github.com/gmarik/vundle ~/.vim/bundle/Vundle.vim"

	let vundle_fresh=1
endif

set nocompatible	" be iMproved, required
filetype off		" required

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
Plugin 'ragtag.vim' " TAG + <ctrl-x> + @, !, #, $, /, <space>, <cr>, ...
Plugin 'vim-airline/vim-airline'
let g:airline#extensions#ale#enabled = 1

" For autocompletion
if has('nvim')
	" python3 needed ($ sudo pip3 install --upgrade neovim)
	Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	let g:deoplete#enable_at_startup = 1
endif

" For source file browsing
" XXX: ctags and vim-nox is needed! ($ sudo apt-get install vim-nox ctags)
Plugin 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>

" For uploading Gist
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'

" For Ruby
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-endwise'

" For Go
Plugin 'fatih/vim-go'

" For Haskell
if has('nvim')
	Plugin 'neovimhaskell/haskell-vim'
endif
Plugin 'itchyny/vim-haskell-indent'

" XXX - do not load following plugins on machines with low performance:
" (touch '~/.vimrc.lowperf' for it)
let lowperf=expand('~/.vimrc.lowperf')
if !filereadable(lowperf)
	" For snippets
	" - Ruby: https://github.com/honza/vim-snippets/blob/master/UltiSnips/ruby.snippets
	" - Go: https://github.com/honza/vim-snippets/blob/master/UltiSnips/go.snippets
	Plugin 'SirVer/ultisnips'
	Plugin 'honza/vim-snippets'
	let g:UltiSnipsExpandTrigger="<tab>"
	let g:UltiSnipsJumpForwardTrigger="<tab>"   " <tab> for next placeholder
	let g:UltiSnipsJumpBackwardTrigger="<s-tab>"    " <shift-tab> for previous placeholder
	let g:UltiSnipsEditSplit="vertical"

	" For Go
	if has('nvim')
		" For autocompletion
		Plugin 'zchee/deoplete-go', { 'do': 'make'}
	endif
	let g:go_fmt_command = "goimports"     " auto import dependencies
	let g:go_highlight_build_constraints = 1
	let g:go_highlight_extra_types = 1
	let g:go_highlight_fields = 1
	let g:go_highlight_functions = 1
	let g:go_highlight_methods = 1
	let g:go_highlight_operators = 1
	let g:go_highlight_structs = 1
	let g:go_highlight_types = 1
	let g:go_auto_sameids = 1
	let g:go_auto_type_info = 1

	" For Python
	if has('nvim')
		" For autocompletion
		Plugin 'zchee/deoplete-jedi'
	endif
endif

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

" install bundles
if vundle_fresh == 1
	echo "Installing bundles..."
	echo ""
	:BundleInstall
endif

"
""""""""""""""""""""""""""""""""""""

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
set showbreak=↳
set breakindent

" for color schemes
set t_Co=256
colo elflord

" file browser (netrw)
" :Ex, :Sex, :Vex
let g:netrw_liststyle = 3
let g:netrw_winsize = 30
" <F2> for vertical file browser
nmap <F2> :Vex <CR>

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

		" For html/javascript/css
		autocmd FileType htm,html,js,json set ai sw=2 ts=2 sts=2 et
		autocmd FileType css,scss set ai sw=2 ts=2 sts=2 et

		" For programming languages
		autocmd FileType go set ai sw=4 ts=4 sts=4 noet	" Golang
		autocmd FileType ruby,eruby,yaml set ai sw=2 ts=2 sts=2 et	" Ruby
		autocmd FileType python set ai sw=2 ts=2 sts=2 et	" Python
		autocmd FileType haskell set ai sw=2 ts=2 sts=2 et " Haskell

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
