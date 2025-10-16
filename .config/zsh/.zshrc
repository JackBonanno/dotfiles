export PATH="$HOME/bin:/usr/local/bin:$PATH"
# Enable zsh-autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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

alias config='/usr/bin/git --git-dir=/home/jack/.cfg/ --work-tree=/home/jack'
