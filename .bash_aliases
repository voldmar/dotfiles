# vim: set filetype=sh:#

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cdd='cd $(python -c "import django, os.path; print os.path.dirname(django.__file__)")'
alias grep='/bin/grep --exclude-dir=.git --exclude=tags -RIEn'
alias ohwait="git st -s --porcelain -uall | awk '{print \$2}' | /bin/grep '[.]py\$' | xargs pyflakes"
alias runs="./manage.py runserver 0.0.0.0:8000"
alias psql="sudo su postgres -c psql"

function cdpy() {
    MODULE_PATH=$(python -c "import $1, os.path; print os.path.dirname($1.__file__)")
    if [ $? ]
    then
        cd $MODULE_PATH
    fi
}

