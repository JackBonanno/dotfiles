export PATH="$HOME/bin:/usr/local/bin:$PATH"
#export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
#export PATH="$HOME/bin:$PATH"
# Source local zsh config settings
if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi
# Enable zsh-autosuggestions if available
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Enable zsh-syntax-highlighting if available
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Source local zsh config settings
if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi

autoload -Uz vcs_info
precmd() { vcs_info }

setopt PROMPT_SUBST
#og prompt
#export PROMPT='%B%F{yellow}[%h]%f %F{red}!%f %F{yellow}%n%f%F{blue}@%m%f %F{red}%~>%f%b'
#git prompt
#export PROMPT='%B%F{blue}%m%f%F{yellow}${vcs_info_msg_0_}%f %F{red}%~>%f%b'
#combo?
export PROMPT='%B%F{yellow}[%h]%f %F{red}!%f %F{yellow}%n%f%F{blue}@%m%f%F{red}${vcs_info_msg_0_} ~> %f%b'

autoload -Uz compinit
compinit
autoload -U select-word-style
select-word-style bash

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history       
setopt hist_ignore_dups     
setopt share_history        

bindkey "^[[1;5C" forward-word      # Ctrl + →
bindkey "^[[1;5D" backward-word     # Ctrl + ←
bindkey "^Y" autosuggest-accept

alias vim="nvim"
alias audiotui="ncpamixer"
alias elvis="~/.local/script/elvis_login.sh"
alias arm64ssh="ssh -i ~/bin/bonann56.key bonann56@52.206.15.75"

export JAVA_HOME=/usr/lib/jvm/default

autoload -U select-word-style
select-word-style bash

#use keychain to load my github key
if command -v keychain >/dev/null 2>&1 && [[ -f ~/.keychain/${HOST}-sh ]]; then
    eval "$(keychain --quiet --eval "$GITHUB_KEY_NAME")"
fi


alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
