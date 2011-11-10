# vim: set filetype=sh:#

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cdd='cd $(python -c "import django, os.path; print os.path.dirname(django.__file__)")'
alias g='/bin/grep --exclude-dir=.git --exclude=tags -RIEn'
alias ohwait="git st -s --porcelain -uall | awk '{print \$2}' | /bin/grep '[.]py\$' | xargs pyflakes"
alias runs="./manage.py runserver 0.0.0.0:8000"
alias hruns="HTTPS=on ./manage.py runserver 0.0.0.0:8001"
alias psql="sudo su postgres -c psql"
alias msh="./manage.py mshell"
alias f="find . -name"
alias F="find . -iname"
alias vd='vim $(git diff --name-only)'

function cdpy() {
    MODULE_PATH=$(python -c "import $1, os.path; print os.path.dirname($1.__file__)")
    if [ $? ]
    then
        cd $MODULE_PATH
    fi
}

vg () { vim -q<( grep -RIEn "$@" ); }

