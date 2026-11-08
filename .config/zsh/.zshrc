export PATH="$HOME/bin:/usr/local/bin:$PATH"
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="$HOME/.local/bin:$PATH" ;; esac
export EDITOR="nvim"

stty -ixon #Disable ctrl s pause and ctrl q resume

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

eval "$(fzf --zsh)"

# 1. Enable prompt substitution & load vcs_info
setopt PROMPT_SUBST
autoload -Uz vcs_info

# 2. Configure Git status (Clean = green, Dirty = yellow ! or +)
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '!'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' %F{green}(%b%F{yellow}%u%c%F{green})%f'
zstyle ':vcs_info:git:*' actionformats ' %F{green}(%b|%a%F{yellow}%u%c%F{green})%f'

# 3. Precmd hook: update git info & print blank line between commands
precmd() {
    vcs_info
}

# 4. Contextual Identity: keep your yellow/blue %n@%m, but ONLY over SSH or as root
prompt_context() {
    if [[ -n "$SSH_CONNECTION" || "$EUID" -eq 0 ]]; then
        echo "%F{yellow}%n%f%F{blue}@%m%f "
    fi
}

# 5. Python Venv indicator (optional, hides when inactive)
export VIRTUAL_ENV_DISABLE_PROMPT=1
prompt_venv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "%F{cyan}[${VIRTUAL_ENV:t}]%f "
    fi
}

PROMPT='%B$(prompt_context)$(prompt_venv)%F{blue}%1~%f${vcs_info_msg_0_}%(?.%F{33}.%F{red}) ❯%f%b '

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
bindkey -s ^f "~/bin/scripts/tmux-sessionizer\n"

alias vim="nvim"
alias audiotui="ncpamixer"
alias monitors="nvim ~/.config/hypr/monitors.lua"
export QT_LOGGING_RULES=qt.qpa.wayland.*.warning=false

alias ls='ls -N --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias history='history 1'

export JAVA_HOME=/usr/lib/jvm/default

autoload -U select-word-style
select-word-style bash

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  eval "$(ssh-agent -s)"
fi

#use keychain to load my github key
if command -v keychain >/dev/null 2>&1 && [[ -f ~/.keychain/${HOST}-sh ]]; then
    eval "$(keychain --quiet --eval "$GITHUB_KEY_NAME")"
fi


alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
