export LANG=en_US.UTF-8
export LC_CTYPE=
export PYTHONPATH=/usr/local/Cellar/python/2.7.1/lib/python2.7/site-packages:$PYTHONPATH
export EMAIL="voldmar@voldmar.ru"
export NAME="Vladimir Epifanov"
export LESS='-r'
export HISTCONTROL=ignoredups:ignorespace
export NODE_PATH=/usr/local/lib/node

export BZR_EDITOR=vim
export SVN_EDITOR=vim
export CVSEDITOR=vim
export EDITOR=vim


alias ls="ls -FG"
alias ll="ls -l"
alias la="ls -a"
alias ..="cd .."
alias ...="cd ../.."
alias ipython='/usr/bin/env python $(which ipython)'
alias pysh="ipython -p pysh"
alias pyclean="find . -type f -name '*.py[co]' -delete"
alias swpclean="find . -type f -name '*.swp' -delete"
alias tl="tmux list-sessions"
alias ta="tmux attach"
alias sd="ssh dev2.ostrovok.ru"
alias red="curl -s 'http://red.ostrovok.ru/issues.xml?assigned_to_id=7&limit=100' | xml sel  -t -m '/issues/issue' -v 'concat(id, \":\", subject)' -n | grep ^. | gsort -R | head -1"
alias sv="ssh voldmar.ru"

export PATH="${HOME}/bin:${HOME}/node_modules/.bin:/usr/local/share/python:/usr/local/bin:/usr/local/Cellar/python/2.7.1/bin:/opt/local/bin:/opt/local/sbin:/opt/local/lib/postgresql83/bin:${PATH}"
export MANPATH="/opt/local/share/man:${MANPATH}"

# http://www.macosxhints.com/article.php?story=20081231012753422
export __CF_USER_TEXT_ENCODING=0x1F5:0x8000100:0x8000100

if [ -f `brew --prefix`/etc/bash_completion ]
then
    . `brew --prefix`/etc/bash_completion
fi

[ -e $(which virtalenvwrapper.sh) ] && . $(which virtualenvwrapper.sh)
which pip > /dev/null && eval "`pip completion --bash`"

export WORKON_HOME=$HOME/.virtualenvs
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=auto
export PS1="\u@\h:\w\$(__git_ps1) \$ "
# export PS1="\[\e]0;\u@\h: \w\a\]\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$(__git_ps1 \" (%s)\")\$ "

# -- EOF -- #

