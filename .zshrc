# --- BASIC SETTINGS ---
export LANG=en_US.UTF-8
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt APPEND_HISTORY
bindkey -e # Use emacs keybindings

# # --- PROMPT ---
# # A very simple, fast prompt. 
# # (You can replace this with 'Starship' later for a better Gruvbox look)
# PROMPT='%F{214}%n%f@%F{142}%m%f %F{109}%~%f %# '

# --- 1. COMPLETION SYSTEM (The "Brain") ---
autoload -Uz compinit
# Cache completions for speed (makes startup instant)
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || echo 0)
if [ $(date +'%j') != $updated_at ]; then
    compinit
else
    compinit -C
fi

# OMZ-style Tab Menu (Arrow key navigation)
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # Case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Colors in menu
zstyle ':completion:*:descriptions' format '[%d]' # Grouping by type

# --- 2. SHELL OPTIONS (The "OMZ logic") ---
setopt AUTO_CD              # Type 'dotfiles' to enter
setopt CORRECT              # "Did you mean...?" for typos
setopt AUTO_LIST            # List choices on ambiguous completion
setopt AUTO_MENU            # Show menu after second tab press
setopt ALWAYS_TO_END        # Move cursor to end of word after completion
setopt SHARE_HISTORY        # Share history between all open terminals
setopt APPEND_HISTORY       # Don't overwrite history file
setopt HIST_IGNORE_ALL_DUPS # Don't record same command twice

# --- 3. ALIASES (The "Shortcuts") ---
alias la='ls -lAh --color=auto'
alias l='ls -lh --color=auto'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'

# --- 4. PLUGINS (Arch System Paths) ---
# Highlighting MUST be last
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- 5. PLUGIN TWEAKS ---
# Use Gruvbox Gray for the "ghost text" suggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=243'

# --- ALIASES ---
alias zshconfig="nvim ~/.zshrc"
alias cls="clear"
alias code="codium"
alias monitor-only='hyprctl keyword monitor eDP-1, disable'

# --- NVM LAZY LOAD ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && {
    nvm() { unset -f nvm node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; nvm "$@"; }
    node() { unset -f nvm node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; node "$@"; }
    npm() { unset -f nvm node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; npm "$@"; }
    npx() { unset -f nvm node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; npx "$@"; }
}

# --- FASTFETCH ---
fastfetch

eval "$(starship init zsh)"
