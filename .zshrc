# .zshrc
#
# created on 2014.06.30.
# updated on 2019.06.25.
#
# ... by meinside@gmail.com
#
# $ git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
# $ chsh -s /bin/zsh
#

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Path to your oh-my-zsh installation.
# (https://github.com/robbyrussell/oh-my-zsh)
export ZSH=$HOME/.oh-my-zsh

# If you would like oh-my-zsh to automatically update itself
# without prompting you
DISABLE_UPDATE_PROMPT="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="steeef"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git docker colored-man-pages encode64 urltools)

source $ZSH/oh-my-zsh.sh

# User configuration
#umask 027
export DISPLAY=:0.0
export EDITOR="/usr/bin/vim"
export SVN_EDITOR="/usr/bin/vim"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export TERM="screen-256color"
export CLICOLOR=true
export HISTCONTROL=erasedups
export HISTSIZE=10000

# prompt
export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\007"; find_git_branch; find_git_dirty;'

# colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep="grep --color=auto"
fi

# aliases
. ~/.aliases
if [ -f ~/.custom_aliases ]; then
    . ~/.custom_aliases
fi

######################
##  for development  #
######################

if [[ -z $TMUX ]]; then

	# for Ruby (RVM)
	[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

	# for Go
	if [ -d /opt/go/bin ]; then
		export GOROOT=/opt/go
	elif [ -x "`which go`" ]; then
		export GOROOT=`go env GOROOT`
	fi
	if [ -d $GOROOT ]; then
		export GOPATH=$HOME/srcs/go
		export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
	fi

	# for Lein (Clojure)
	export LEIN_JVM_OPTS=""

	# for Node.js
	export PATH=$PATH:/opt/node/bin

	# for Rust
	export PATH=$PATH:$HOME/.cargo/bin

	# additional paths
	export PATH="$PATH:$HOME/bin:$HOME/.local/bin"

fi

# for python and virtualenv
#
# $ sudo apt-get install python-pip
# $ sudo pip install virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
[[ -s "/usr/local/bin/virtualenvwrapper.sh" ]] && source "/usr/local/bin/virtualenvwrapper.sh"	# virtualenv and virtualenvwrapper

# for zsh-syntax-highlighting
if [ -d /usr/share/zsh-syntax-highlighting/  ]; then
	source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
