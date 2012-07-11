ZSH=$HOME/.oh-my-zsh
DISABLE_AUTO_UPDATE="true"

plugins=(git brew django github lein python redis-cli vagrant)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

export PATH="${HOME}/bin:${HOME}/local/bin:/usr/local/share/python:/usr/local/bin:/usr/local/Cellar/python/2.7.3/bin:/usr/local/Cellar/ruby/1.9.3-p194/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export EDITOR=vim
export LANG=en_US.UTF-8
export CDPATH=$CDPATH:~:~/Dropbox/weekly

which pip > /dev/null && eval "$(pip completion --zsh)"
which virtualenvwrapper.sh > /dev/null && source $(which virtualenvwrapper.sh)

source ~/etc/aliases
source ~/.zshrc_local

# Redefine virtualenv’s prompt
VIRTUAL_ENV_DISABLE_PROMPT="yes"
function virtualenv_prompt() {
    if [[ -n $VIRTUAL_ENV ]]
    then
        local NAME=$(basename $VIRTUAL_ENV)
        if [[ $NAME == ".env" ]]
        then
            echo "☢ "
        else
            echo "($NAME) "
        fi
    fi
}

# Checks if there are commits behind the remote
function git_prompt_behind() {
  if $(echo "$(git log HEAD..origin/$(current_branch) 2> /dev/null)" | grep '^commit' &> /dev/null); then
    echo "$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi
}

PROMPT='%{$fg_no_bold[yellow]%}$(virtualenv_prompt)%{$reset_color%}%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) $(git_prompt_info)$(git_prompt_ahead)$(git_prompt_behind) %{$fg_bold[blue]%}%#%{$reset_color%} '
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg_bold[red]%}↓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[red]%}↑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"


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

