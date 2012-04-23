ZSH=$HOME/.oh-my-zsh
ZSH_THEME="gentoo"
DISABLE_AUTO_UPDATE="true"

plugins=(git brew django github lein python redis-cli vagrant)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

export PATH="${HOME}/bin:${HOME}/local/bin:/usr/local/share/python:/usr/local/bin:/usr/local/Cellar/python/2.7.3/bin:/usr/local/Cellar/ruby/1.9.3-p194/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export EDITOR=vim
export LANG=en_US.UTF-8

which pip > /dev/null && eval "$(pip completion --zsh)"
which virtualenvwrapper.sh > /dev/null && source $(which virtualenvwrapper.sh)

source ~/etc/aliases
source ~/.zshrc_local


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

