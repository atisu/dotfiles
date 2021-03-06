# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="atisu"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=~/.oh-my-zsh-custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git osx vi-mode virtualenv atisu local)

# User configuration

export PATH="/usr/local/bin:/Users/atisu/bin:/usr/local/bin:/Users/atisu/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/texbin:/Users/atisu/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

setopt interactivecomments

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

bindkey '\e[3~' delete-char
bindkey "^R" history-incremental-search-backward

SVN_EDITOR=vim
EDITOR=vim
PATH=~/bin:$PATH

export LANG SVN_EDITOR PATH EDITOR

for i in .sshagent bin/marks.sh; do
    if [ -f "${HOME}/$i" ]; then
	source "${HOME}/$i"
    fi
done

gdiff() {
   git diff --color=always "$@" | less -r
}

# http://boredzo.org/blog/archives/2016-08-15/colorized-man-pages-understood-and-customized
man() {
     env \
         LESS_TERMCAP_mb=$(printf "\e[1;31m") \
         LESS_TERMCAP_md=$(printf "\e[1;31m") \
         LESS_TERMCAP_me=$(printf "\e[0m") \
         LESS_TERMCAP_se=$(printf "\e[0m") \
         LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
         LESS_TERMCAP_ue=$(printf "\e[0m") \
         LESS_TERMCAP_us=$(printf "\e[1;32m") \
         man "$@"
}

alias tmux="tmux -2"
alias tma="tmux -2 attach -t misc"
alias tmn="tmux -2 new -s misc"

git_parent() {
	git show-branch -a \
	| grep '\*' \
	| grep -v `git rev-parse --abbrev-ref HEAD` \
	| head -n1 \
	| sed 's/.*\[\(.*\)\].*/\1/' \
	| sed 's/[\^~].*//'
}

man_l() {
	# e.g.,: man_l 1 agrep
	links -dump https://linux.die.net/man/$1/$2 | less
}

if hash archey 2>/dev/null; then
    # we assume OS X version has -c ...
    if [ -z "`uname -a | grep Darwin`" ]; then
	archey
    else
	archey -c
    fi
elif hash screenfetch 2>/dev/null; then
    screenfetch
fi

if [ -f "/usr/local/bin/virtualenvwrapper.sh" ]; then
    export WORKON_HOME=~/Projects/virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh
fi

if hash thefuck 2>/dev/null; then
    eval "$(thefuck --alias)"
fi

alias did="vim +'normal Go' +'r!date' ~/did.txt"

if [ -f ~/.zshrc-local ]; then
    source  ~/.zshrc-local
fi
