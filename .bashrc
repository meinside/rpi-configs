# .bashrc for Raspberry Pi
#
# created on 2012.05.31.
# updated on 2015.10.13.
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
export TERM="xterm-256color"
export CLICOLOR=true

HISTCONTROL=ignoreboth

shopt -s histappend
shopt -s checkwinsize

# prompt
source ~/.bash/colors
source ~/.bash/git-prompt
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|screen)
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
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi
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
	[[ -s "/etc/profile.d/rvm.sh" ]] && source "/etc/profile.d/rvm.sh"  # This loads RVM into a shell session.
	PATH=$PATH:/usr/local/rvm/bin # Add RVM to PATH for scripting
	export rvmsudo_secure_path=1

	# for Node.js
	if [ -d /opt/node/bin ]; then
		export PATH=$PATH:/opt/node/bin
	fi

	# for go
	if [ -d /opt/go/bin ]; then
		export GOROOT=/opt/go
		export GOPATH=$HOME/srcs/go
		export PATH=$PATH:$GOPATH/bin
	fi

	# for phantomjs & casperjs
	if [ -d /opt/phantomjs/bin ]; then
		export PATH=$PATH:/opt/phantomjs/bin
	fi
	if [ -d /opt/casperjs/bin ]; then
		export PATH=$PATH:/opt/casperjs/bin
	fi

	# additional paths
	if [ -d "$HOME/bin" ] ; then
		PATH="$PATH:$HOME/bin"
	fi

fi

