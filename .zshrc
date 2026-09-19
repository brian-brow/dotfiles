# ~/.zshrc — ported from ~/.config/fish/config.fish

# --- PATH (was fish_add_path / fish_user_paths) ---
typeset -U path PATH          # keep entries unique, like fish_add_path
path=(
    /opt/cuda/bin
    $HOME/.dotnet/tools
    $HOME/.local/bin
    $HOME/scripts
    $path
)
export PATH

# --- Environment ---
export EDITOR=nvim
export QT_STYLE_OVERRIDE=kvantum
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT=-c

# --- Aliases ---
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias tk="tmux list-sessions -F '#S' | xargs -I{} tmux kill-session -t {}"

# --- History
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS EXTENDED_HISTORY INC_APPEND_HISTORY

# --- Completion ---
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# --- Keys: up/down search history by what you've typed (fish-style) ---
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

# --- Prompt ---
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/brian.omp.json)"

# Reload the prompt on SIGUSR1 (e.g. after a theme/colors.json edit)
TRAPUSR1() {
    eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/brian.omp.json)"
}

fastfetch

# --- Go
export GOPATH="$HOME/.local/share/go"
