ZSH=$HOME/.oh-my-zsh
ZSH_THEME="gentoo"
DISABLE_AUTO_UPDATE="true"

plugins=(git brew django github lein python redis-cli vagrant)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

export PATH="${HOME}/bin:${HOME}/local/bin:/usr/local/share/python:/usr/local/bin:/usr/local/Cellar/python/2.7.2/bin:/usr/local/Cellar/ruby/1.9.3-p125/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export EDITOR=vim
export LANG=en_US.UTF-8

which pip > /dev/null && eval "$(pip completion --zsh)"
which virtualenvwrapper.sh > /dev/null && source $(which virtualenvwrapper.sh)

source ~/etc/aliases
source ~/.zshrc_local


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

if [ $SHLVL -eq 1 ]
then
    if [ -S $SSH_AUTH_SOCK ]
    then
        # Socket we are linking already does not exists
        if [ ! -e $HOME/.ssh_auth_sock ]
        then
            rm $HOME/.ssh_auth_sock
            ln -s $SSH_AUTH_SOCK $HOME/.ssh_auth_sock
        fi
    fi
    export SSH_AUTH_SOCK=$HOME/.ssh_auth_sock
fi

