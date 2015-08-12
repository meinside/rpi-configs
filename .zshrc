# .zshrc
#
# created on 2014.06.30.
# updated on 2015.08.12.
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

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="risto"

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
#plugins=(osx git ruby rails)
plugins=(debian)

source $ZSH/oh-my-zsh.sh

# User configuration
umask 027
export DISPLAY=:0.0
export EDITOR="/usr/bin/vim"
export SVN_EDITOR="/usr/bin/vim"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export TERM="xterm-color"
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
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi
if [ -f ~/.custom_aliases ]; then
    . ~/.custom_aliases
fi

######################
##  for development  #
######################

# XXX - for using my global Gemfile as fallback...
autoload -U add-zsh-hook
set-fallback-gemfile () {
		_search () {
				slashes=${PWD//[^\/]/}
				directory="$PWD"
				for (( n=${#slashes}; n>0; --n )); do
						test -e "$directory/$1" && echo "$directory/$1" && return
						directory="$(dirname "$directory")"
				done
		}
		if [ `_search "Gemfile.lock"` ]; then   # XXX - check if 'Gemfile.lock' exists in any of direct-upper directories
				# using local Gemfile
				unset BUNDLE_GEMFILE
		else    # if no Gemfile is provided, use my own(system-wide?) one instead
				# using fallback Gemfile at $HOME/Gemfile
				export BUNDLE_GEMFILE=$HOME/Gemfile
		fi
}
add-zsh-hook chpwd set-fallback-gemfile

if [[ -z $TMUX ]]; then

	# for RVM
	[[ -s "/etc/profile.d/rvm.sh" ]] && source "/etc/profile.d/rvm.sh"  # This loads RVM into a shell session.
	PATH=$PATH:/usr/local/rvm/bin # Add RVM to PATH for scripting
	export rvmsudo_secure_path=1

	# for iojs(node)
	if [ -d /opt/iojs/bin ]; then
		export PATH=$PATH:/opt/iojs/bin
	fi

	# for go
	if [ -d /opt/go/bin ]; then
		export GOROOT=/opt/go
		export GOPATH=$HOME/srcs/go
		export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
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
		export PATH="$PATH:$HOME/bin"
	fi

fi

