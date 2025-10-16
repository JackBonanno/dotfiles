export PATH="$HOME/bin:/usr/local/bin:$PATH"
# Enable zsh-autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Enable zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Source local zsh config settings
if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi

autoload -Uz vcs_info
precmd() { vcs_info }

#export PROMPT='%B%F{yellow}[%h]%f %F{red}!%f %F{yellow}%n%f%F{blue}@%m%f %F{red}%~>%f%b'
setopt PROMPT_SUBST
export PROMPT='%B%F{blue}%m%f%F{yellow}${vcs_info_msg_0_}%f %F{red}%~>%f%b'

autoload -Uz compinit
compinit

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history

bindkey "^[[1;5C" forward-word      # Ctrl + →
bindkey "^[[1;5D" backward-word     # Ctrl + ←
bindkey "^Y" autosuggest-accept

alias vim="nvim"
alias audiotui="ncpamixer"

export JAVA_HOME=/usr/lib/jvm/default

autoload -U select-word-style
select-word-style bash

#use keychain to load my github key
eval $(keychain --quiet --eval "$GITHUB_KEY_NAME")

alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
