# .bashrc for Raspberry Pi
#
# created on 2012.05.31.
# updated on 2019.06.25.
#
# ... by meinside@gmail.com

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# various configurations
export DISPLAY=:0.0
export EDITOR="/usr/bin/vim"
export SVN_EDITOR="/usr/bin/vim"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export TERM="screen-256color"
export CLICOLOR=true

HISTCONTROL=ignoreboth

shopt -s histappend
shopt -s checkwinsize

# prompt
source ~/.bash/colors
source ~/.bash/git-prompt
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|screen*)
		if [ `whoami` = "root" ]; then
			PS1="\[$bldred\]\u@\h\[$txtrst\]:\[$bldblu\]\w\[$txtgrn\]\$git_branch\[$txtylw\]\$git_dirty\[$txtrst\]\$ "
		else
			PS1="\[$bldgrn\]\u@\h\[$txtrst\]:\[$bldblu\]\w\[$txtgrn\]\$git_branch\[$txtylw\]\$git_dirty\[$txtrst\]\$ "
		fi
		;;
	*)
		PS1='\u@\h \w \$ '
		;;
esac
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

# bash completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

######################
##  for development  #
######################

if [[ -z $TMUX ]]; then

	# for RVM
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

