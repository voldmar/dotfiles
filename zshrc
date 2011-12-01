ZSH=$HOME/.oh-my-zsh
ZSH_THEME="gentoo"
DISABLE_AUTO_UPDATE="true"

plugins=(git brew django github lein python redis-cli vagrant)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

export PATH="${HOME}/bin:/usr/local/share/python:/usr/local/bin:/usr/local/Cellar/python/2.7.2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export EDITOR=vim
export LANG=en_US.UTF-8

which pip > /dev/null && eval "$(pip completion --zsh)"
which virtualenvwrapper.sh > /dev/null && source $(which virtualenvwrapper.sh)

source ~/etc/aliases
source ~/.zshrc_local
