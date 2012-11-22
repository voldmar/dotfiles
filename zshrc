ZSH=$HOME/.oh-my-zsh
DISABLE_AUTO_UPDATE="true"

plugins=(git brew github lein python redis-cli vagrant)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

export PATH="${HOME}/bin:/usr/local/CrossPack-AVR/bin:${HOME}/local/bin:/usr/local/share/python:/usr/local/bin:/usr/local/Cellar/python/2.7.3/bin:/usr/local/Cellar/ruby/1.9.3-p327/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export EDITOR=vim
export LANG=en_US.UTF-8
export CDPATH=$CDPATH:~:~/Dropbox/proj:~/Dropbox/contrib:~/Dropbox/weekly
export TERM=xterm-256color
export EDITOR=vim
export LC_ALL=en_US.UTF-8
export LESS="-r"

which pip > /dev/null && eval "$(pip completion --zsh)"
which virtualenvwrapper.sh > /dev/null && source $(which virtualenvwrapper.sh)

# Redefine virtualenv’s prompt
VIRTUAL_ENV_DISABLE_PROMPT="yes"
function virtualenv_prompt() {
    if [[ -n $VIRTUAL_ENV ]]
    then
        local NAME=$(basename $VIRTUAL_ENV)
        [[ $NAME == ".env" ]] && echo "☢ " && return
        [[ $NAME == "ostrota" ]] && echo "Ω " && return
        echo "($NAME) "
    fi
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
alias gs="git st"
alias gci="git ci"
alias gf="git fetch --prune"
alias gm="git merge"
alias gmom="git merge origin/master"
alias ga="git add"
alias gp="git push"
alias gpl="git pull --prune"
alias gd="git diff"
alias gu="git up"
alias gcb="git checkout -b"
alias gcl="git clone"
alias pi="pip install"
alias bu="brew update && brew upgrade"
alias -g EL="2>&1 | less"
alias week="date +%W"
alias reset="echo -e c"
alias rssh="ssh -fN -R 8022:localhost:22"
alias -g dime="growlnotife -m Done -s"
alias pytags='ctags --exclude=.env --exclude=migrations --languages=python --python-kinds=-i -R .'
alias rtc='pyclean && ./manage.py test -v --create-db'
alias rtf='pyclean && ./manage.py test -v --failed'
alias rtcf='pyclean && rm -f .noseids && ./manage.py test -v --create-db --failed'
alias frtc='pyclean -f && genm && ./manage.py test -v --create-db'
alias rt='./manage.py test -v'
alias genm='./manage.py generatemedia && (yes yes | ./manage.py collectstatic)'
alias tack='find . -name tests -not -path "./.env/*" -not -path "./src/*" | xargs ack'
alias acka='ack -a'
alias vim-update='brew upgrade ~/Dropbox/vim.rb'

vack () { vim -q<( ack -H --nocolor --nogroup --column  "$@" ); }
vtack () { vim -q<( tack -H --nocolor --nogroup --column  "$@" ); }
mkmig () {
    local msg name
    if msg=$(./manage.py schemamigration --auto $1 $2 2>&1)
    then
        name=$(echo $msg | sed -E 's/.* ([0-9]+.*\.py).*/\1/')
        # $EDITOR $1/migrations/$name
        echo $msg
    else
        echo $msg 1>&2 
    fi
}
mkdmig () {
    local msg name
    if msg=$(./manage.py datamigration $1 $2 2>&1)
    then
        name=$(echo $msg | sed -E 's/.* ([0-9]+.*\.py).*/\1/')
        echo $name
        # $EDITOR $1/migrations/$name
    else
        echo $msg 1>&2 
    fi
}
mig ()  { ./manage.py migrate $1 $2 --ignore-ghost-migrations }

runs() {
    while true
    do
        ./manage.py runserver 0.0.0.0:${1:-8000}
        sleep 1
    done
}

serve() {
    python -m SimpleHTTPServer ${1:-9000}
}

# apt-get install realpath # On Ubuntu
# brew install coreutils # On Mac
/usr/bin/which realpath > /dev/null && realpath_proxy() {echo $(realpath ${1}) }
/usr/bin/which grealpath > /dev/null && realpath_proxy() {echo $(grealpath ${1}) }
which realpath_proxy > /dev/null || realpath_proxy() { echo $(python -c "import os.path as p; print p.dirname(p.realpath('$1'))") }

with_parents () {
    local current=$(realpath_proxy ${1:-$PWD})
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
    [ -f $d/.env/bin/activate ] && source $d/.env/bin/activate && return 0
    if [ -f $d/.env ]
    then
        local VENV=$(cat $d/.env)
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
            [ -f $d/.env/bin/activate ] && local VENV=$d/.env
            [ -f $d/.env ] && local VENV=$WORKON_HOME/$(cat $d/.env)
            [[ $VENV != $VIRTUAL_ENV ]] && try_activate $d
            [[ -n $VENV ]] && return 0
        done
        deactivate 2> /dev/null
    fi
}

cd () {
    builtin cd "$@"
    update_venv
}

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


# pip’s requirements.txt update
updreq() {

    (( $# != 2 )) && { echo "Usage: $0 <requirement> <version>" >&2; return 1}
    requirement=$1
    revision=$2
    grep -q "${requirement}" requirements.txt || { echo "Unknown requirement ${requirement}" >&2; return 2 }
    [[ (( $(grep -c "${requirement}" requirements.txt) -gt 1 )) ]] && { echo "Ambigous requirement ${requirement}" >&2; grep --color=auto "${requirement}" requirements.txt; return 3} 


    if grep -q "^-e .*${requirement}" requirements.txt
    then
        if grep -q "@${revision}.*#egg=.*${requirement}.*" requirements.txt
        then
            echo "requirement ${requirement} already has revision ${revision}" >&2
            return 4
        else
            sed -i "/${requirement}/s/@.\+#/@${revision}#/" requirements.txt
            return 0
        fi
    fi

    version=$revision
    if grep -q "[a-z0-9_-]*${requirement}[a-z0-9_-]*==" requirements.txt
    then
        if grep "^[a-z0-9_-]*${requirement}[a-z0-9_-]*==${version}\s*$" requirements.txt
        then
            echo "requirement ${requirement} already has version ${version}"
            return 5
        else
            sed -i "/${requirement}/s/==.\+/==${version}/" requirements.txt
            return 0
        fi
    fi

}

# More intellegent pyclean
# Unalias pyclean from zsh python plugin
unalias pyclean 2> /dev/null
pyclean () {
    local CACHE=.pyclean_cache HEAD=.git/HEAD TTL=-1h
    [[ $1 == "-f" ]] && rm -f $CACHE

    if [ -e $CACHE ] && [ $(find $CACHE -newer $HEAD -mtime $TTL) ]
    then
        cat $CACHE | xargs rm -f
    else
        find . -type f -name "*.py[co]" | tee $CACHE | xargs rm -f
    fi
}

repl-listen () {
    rlwrap -r --multi-line -q"\"" -b "(){}[],^%3@\";:'" lein trampoline cljsbuild repl-listen
}

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

pipu () {
    [[ -z $VIRTUAL_ENV ]] && echo "you must be in virtualenv to run pipu" 1>&2 && return 1
    [[ -f .lastcommit ]] && last_commit=$(cat .lastcommit)
    current_commit=$(commit-id requirements.txt)
    [[ $last_commit != $current_commit ]] && new=$(git diff $last_commit..$current_commit -- requirements.txt | grep '^+[^+]' | cut -c 2- )
    [[ -n $new ]] && echo $new && pip install -r <(echo $new)
    commit-id requirements.txt > .lastcommit
}
pipu () {
    pip install --upgrade -r requirements.txt
}

ven () {
    if [[ -e requirements-macosx.txt || -e requirements.txt ]]
    then
        virtualenv .env
        cd .
        pipu
    else
        echo "You must have requirements.txt to create new environment"
    fi
}

vd () {
    vim $(git diff --name-only -- $@ | sort -u)
}

vt () {
    # vt path/to/test.py:TestClass.test_method —> open path at method
    local TEST=$1
    local FILE=$(echo $TEST | cut -d: -f1)
    local INFILE=$(echo $TEST | cut -d: -f2)
    local CLASS=$(echo $INFILE | cut -d. -f1)
    local METHOD=$(echo $INFILE | cut -d. -f2)
    vim $FILE +/$CLASS +/$METHOD
}

update_venv

# Must be last line
source ~/.zshrc_local

