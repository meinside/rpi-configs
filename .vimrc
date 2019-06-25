" meinside's .vimrc file,
" created by meinside@gmail.com,
"
" last update: 2019.06.25.
"
" XXX - change default text editor:
" $ sudo update-alternatives --config editor
"
" XXX - setup for nvim:
" $ sudo apt-get install python3-pip
" $ pip3 install --upgrade --user pynvim

""""""""""""""""""""""""""""""""""""
" settings for nvim
"
"
" for nvim, symbolic link '~/.vimrc' to '~/.config/nvim/init.vim'
if !filereadable(expand('~/.config/nvim/init.vim'))
    silent !mkdir -p ~/.config/nvim
    silent !ln -sf ~/.vimrc ~/.config/nvim/init.vim
endif

""""""""""""""""""""""""""""""""""""
" settings for vim-plug (https://github.com/junegunn/vim-plug)
if has('nvim')
    " for nvim
    if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
        silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
else
    " for vim
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endif

" Specify a directory for plugins
if has('nvim')
    call plug#begin('~/.local/share/nvim/plugged')
else
    call plug#begin('~/.vim/plugged')
endif

""""""""
" plugins

" Useful plugins
Plug 'jiangmiao/auto-pairs'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-ragtag' " TAG + <ctrl-x> + @, !, #, $, /, <space>, <cr>, ...
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
let g:airline#extensions#ale#enabled = 1
Plug 'docunext/closetag.vim'
Plug 'luochen1990/rainbow'     " rainbow-colored parentheses
let g:rainbow_active = 1

" For autocompletion
if has('nvim')
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

	let g:deoplete#enable_at_startup = 1
	let g:deoplete#enable_smart_case = 1

	" To close preview window after selection
	autocmd CompleteDone * pclose
endif

" For source file browsing, XXX: ctags and vim-nox is needed! ($ sudo apt-get install vim-nox ctags)
Plug 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>

" For uploading Gist
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'

" For Clojure
Plug 'guns/vim-clojure-static', {'for': 'clojure'}

" For Go
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoInstallBinaries'}

" For Ruby
Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}
Plug 'tpope/vim-endwise', {'for': 'ruby'}

" XXX - do not load following plugins on machines with low performance:
" (touch '~/.vimrc.lowperf' for it)
let lowperf=expand('~/.vimrc.lowperf')
if !filereadable(lowperf)

	" For syntax checking
	Plug 'vim-syntastic/syntastic'
	set statusline+=%#warningmsg#
	if exists('*SyntasticStatuslineFlag')
		set statusline+=%{SyntasticStatuslineFlag()}
	endif
	set statusline+=%*
	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_auto_loc_list = 1
	let g:syntastic_check_on_open = 0
	let g:syntastic_check_on_wq = 0

	" For LanguageServer
	if has('nvim')
		Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': './install.sh'}
		let g:LanguageClient_serverCommands = {}
		nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
		nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
		nnoremap <silent> <F3> :call LanguageClient#textDocument_rename()<CR>
	endif

	" For gitgutter
	Plug 'airblade/vim-gitgutter'        " [c, ]c for prev/next hunk
	let g:gitgutter_highlight_lines = 1
	let g:gitgutter_realtime = 0
	let g:gitgutter_eager = 0

	" For Go
	if has('nvim')
		" For autocompletion: <C-X><C-O>
		let g:LanguageClient_serverCommands.go = ['gopls']
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
	let g:syntastic_go_checkers = ['go']	" XXX: 'golint' is too slow, use :GoLint manually.
	let g:syntastic_aggregate_errors = 1

	" For Python
	if has('nvim')
		Plug 'zchee/deoplete-jedi', {'for': 'python'}	" For autocompletion
		let g:deoplete#sources#jedi#show_docstring = 1
	endif
endif

"
""""""""

" Initialize plugin system
call plug#end()
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
if exists('$TMUX')
	set termguicolors	" not working in terminals
endif
colo elflord

" file browser (netrw)
" :Ex, :Sex, :Vex
let g:netrw_liststyle = 3
let g:netrw_winsize = 30
" <F2> for vertical file browser
nmap <F2> :Vex <CR>

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

