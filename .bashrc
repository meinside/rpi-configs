# .bashrc
#
# created on 12.05.31.
# updated on 13.02.23.
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
export CLICOLOR=true

HISTCONTROL=ignoreboth

shopt -s histappend
shopt -s checkwinsize

# prompt
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|screen)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
		if [ `whoami` = "root" ]; then
			PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
		else
			PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
		fi
		;;
	*)
		PS1='\h \w \$ '
		;;
esac

# colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep="grep --color=auto"
fi

# aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
if [ -f ~/.custom_aliases ]; then
    . ~/.custom_aliases
fi

# bash completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# for RVM
[[ -s "/etc/profile.d/rvm.sh" ]] && source "/etc/profile.d/rvm.sh"  # This loads RVM into a shell session.
PATH=$PATH:/usr/local/rvm/bin # Add RVM to PATH for scripting

# for node
export NODE_PATH=/usr/local/lib/node_modules

# additional paths
if [ -d "$HOME/ruby" ] ; then
	PATH="$PATH:$HOME/ruby"
fi
if [ -d "$HOME/node" ] ; then
	PATH="$PATH:$HOME/node"
fi
if [ -d "$HOME/bin" ] ; then
    PATH="$PATH:$HOME/bin"
fi

