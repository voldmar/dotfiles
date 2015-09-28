ZSH=$HOME/.oh-my-zsh
DISABLE_AUTO_UPDATE="true"

plugins=(git brew github lein python redis-cli vagrant ssh-agent npm node docker)

fpath=(/usr/local/share/zsh-completions $fpath)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

export PATH="${HOME}/bin:/usr/local/share/npm/bin:/usr/local/bin:${PATH}"
export EDITOR=vim
export LANG=en_US.UTF-8
export TERM=xterm-256color
export EDITOR=vim
export LC_ALL=en_US.UTF-8
export LESS="-r"
# export LEIN_JAVA_CMD=${LEIN_JAVA_CMD-drip}
export LEIN_FAST_TRAMPOLINE=y


#which pip > /dev/null && eval "$(pip completion --zsh)"
#which virtualenvwrapper.sh > /dev/null && source $(which virtualenvwrapper.sh)
#which rbenv > /dev/null && eval "$(rbenv init -)"

# Redefine virtualenv’s prompt
VIRTUAL_ENV_DISABLE_PROMPT="yes"
function virtualenv_prompt() {
    if [[ -n $VIRTUAL_ENV ]]
    then
        local NAME=$(basename $VIRTUAL_ENV)
        [[ $NAME == ".venv" ]] && echo "☢ " && return
        [[ $NAME == "ostrota" ]] && echo "Ω " && return
        echo "($NAME) "
    fi
}

function git_prompt_info () {
	ref=$(git symbolic-ref HEAD 2> /dev/null)  || ref=$(git rev-parse --short HEAD 2> /dev/null)  || return
	echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}%{$fg_no_bold[yellow]%}$(parse_git_dirty)%{$fg_bold[blue]%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Checks if there are commits behind the remote
function git_prompt_behind() {
  if $(echo "$(git log HEAD..origin/$(current_branch) 2> /dev/null)" | grep '^commit' &> /dev/null); then
    echo "$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi
}

function smart_current_dir() {
    PROJ_DIRS=("$(echo ~)/proj/" "$(echo ~)/Dropbox/proj/")
    for PROJ in $PROJ_DIRS
    do
        DIR=${PWD##$PROJ}
        [[ $DIR != $PWD ]] && echo "☢ $DIR" && return
    done
    DIR=${PWD##$HOME}
    [[ $DIR != $PWD ]] && echo "~$DIR" && return
    echo $PWD
}

PROMPT='%{$fg_no_bold[yellow]%}$(virtualenv_prompt)%{$reset_color%}%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%m %{$fg_bold[blue]%}$(smart_current_dir) $(git_prompt_info)$(git_prompt_ahead)$(git_prompt_behind) %{$fg_bold[blue]%}%#%{$reset_color%} '
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg_bold[red]%}↓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[red]%}↑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"


alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cdd='cd $(python -c "import django, os.path; print os.path.dirname(django.__file__)")'
alias cdr='cd $(git rev-parse --show-toplevel)'
alias ohwait="git st -s --porcelain -uall | awk '{print \$2}' | grep '[.]py\$' | xargs pyflakes"
alias hruns="HTTPS=on ./manage.py runserver 0.0.0.0:8001"
alias msh="./manage.py mshell"
alias dsh="./manage.py dbshell"
alias f="find . -name"
alias F="find . -iname"
alias tls='tmux list-sessions'
alias ta='tmux attach'
alias ta0='tmux attach -t0'
alias ta1='tmux attach -t1'
alias ta2='tmux attach -t2'

alias ga="git add"
alias gc="git ci"
alias gcaa="git ci -a --amend"
alias gcb="git checkout -b"
alias gci="git ci"
alias gcl="git clone"
alias gd="git diff"
alias gdm="gd origin/master"
alias gf="git fetch --prune"
alias gm="git merge"
alias gmom="git merge origin/master"
alias gp="git push --set-upstream"
alias gpl="git pull --prune"
alias gs="git st"
alias gsh="git stash"
alias gsl="git stash list"
alias gsm="git sm"
alias gsp="git stash pop"
alias gu="git up"

alias -g EL="2>&1 | less"
alias -g dime="growlnotife -m Done -s"
alias ancient="lein ancient upgrade :all; lein ancient upgrade-profiles :all"
alias bu="brew update && brew upgrade && brew cleanup"
alias cljsbuild="lein trampoline cljsbuild $@"
alias reset="echo -e c"
alias rssh="ssh -fN -R 8022:localhost:22"
alias week="date +%W"

vag () { vim -q<(ag --nocolor --nogroup --filename --column "$@" ); }

serve() {
    python -m SimpleHTTPServer ${1:-9000}
}

# apt-get install realpath # On Ubuntu
# brew install coreutils && ln -s /usr/local/bin/{g,}realpath  # On Mac

with_parents () {
    local current="$(realpath ${1:-$PWD})"
    echo -n $current
    while [[ $current != '/' ]]
    do
        current=$(dirname $current)
        echo -n ' ' $current
    done
}

try_activate () {
    # Try find virtualenv info in local dir and activate it
    local d=$1
    [ -f $d/.venv/bin/activate ] && source $d/.venv/bin/activate && return 0
    if [ -f $d/.venv ]
    then
        local VENV=$(cat $d/.venv)
        (lsvirtualenv | grep -q $VENV) || mkvirtualenv $VENV
        workon $VENV
    fi
}

update_venv () {
    if [ -z $VIRTUAL_ENV ]
    then
        # Discover virtualenv
        for d in $(with_parents)
        do
            try_activate $d
        done
    else
        # Deactivate or switch virtualenv if we are not in virtualenv already
        for d in $(with_parents)
        do
            [ -f $d/.venv/bin/activate ] && local VENV=$d/.venv
            [ -f $d/.venv ] && local VENV=$WORKON_HOME/$(cat $d/.venv)
            [[ $VENV != $VIRTUAL_ENV ]] && try_activate $d
            [[ -n $VENV ]] && return 0
        done
        deactivate 2> /dev/null
    fi
}

# cd () {
    # builtin cd "$@"
    # update_venv
# }

function cdpy() {
    if MODULE_PATH=$(python -c "import $1, os.path; print os.path.dirname($1.__file__)" 2> /dev/null)
    then
        cd $MODULE_PATH
    else
        echo Unknown Python module: $1
        return 1
    fi
}

# Minimally awesome todo
# http://blog.jerodsanto.net/2010/12/minimally-awesome-todos/
export TODO=~/Dropbox/todo.txt
function todo(){ if [ $# -eq 0 ]; then cat $TODO; else echo "• $@" >> $TODO; fi }
function todone() { sed -i -e "/$*/d" $TODO; }

pbcopy () {
    cat $1 | /usr/bin/pbcopy
}

# Because ack searches .clj very strange 
gj () {
    grep $@ **/*.clj
}

commit-id () {
    git log -1 --no-merges --oneline -- $1 | cut -d\  -f 1
}

vd () {
    vim $(git diff --name-only -- $@ | sort -u)
}

sd () {
    subl $(git diff --name-only -- $@ | sort -u)
}

sdm () {
    subl $(git diff --name-only origin/master -- $@ | sort -u)
}

vt () {
    # vt path/to/test.py:TestClass.test_method —> open path at method
    local TEST=$1
    local FILE=$(echo $TEST | cut -d: -f1)
    local INFILE=$(echo $TEST | cut -d: -f2)
    local CLASS=$(echo $INFILE | cut -d. -f1)
    local METHOD=$(echo $INFILE | cut -d. -f2)
    vim $FILE +/"\<$CLASS\>" +/"\<$METHOD\>"
}

# update_venv

# Must be the last line
source ~/.zshrc_local

