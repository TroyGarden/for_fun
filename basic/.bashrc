# .bashrc

# User specific aliases and functions

alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CF'                              #
alias cls='tput reset'
alias cl='cls; ls -CF'
alias clt='cls; ls -CFt -l'
alias lspath='echo $PATH | sed "s/\:/\n/g"'

alias du='du -h'
alias du1='du -d1 -h'

alias grep='grep --color'
alias grepi='grep --color -i'
alias greppi='grep --color -P -i'
alias grepv='grep --color -v'
alias greppv='grep --color -P -v'

alias gits='git status'
alias gitss='git status -s'
alias gita='git add'
alias gitcm='git commit -m'
alias gitca='git commit --amend'
alias gitb='git branch -va'
alias gitf='git fetch --prune'
alias gitl='git log'
alias gitln='git log -n'
alias gitl1='git log -n 1'
alias gitl2='git log -n 2'
alias gitl3='git log -n 3'
alias gitd='git diff'
alias gitdn='git diff --name-only'
alias gitr='git reset HEAD~1 --hard; git pull'


# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi


if [ -f /data/workspace/FCM_LICENSE ]; then
    export FCM_LICENSE=`cat /data/workspace/FCM_LICENSE`
    export PYTHONPATH=/data/workspace
fi


