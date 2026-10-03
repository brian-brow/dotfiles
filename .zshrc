# PATH
typeset -U path PATH
path=(
  $HOME/.local/bin
  $HOME/Scripts
  $path
)
export PATH

# ENVIRONMENT
export EDITOR=nvim
export MANPAGER="sh -c 'col =bx | bat -l man =p'"
export MANROFFOPT=-c

# ALIAS
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# HISTORY
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS EXTENDED_HISTORY INC_APPEND_HISTORY

# COMPLETION
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# PROMPT
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/brian.omp.json)"
TRAPUSR1() {
  eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/brian.omp.json)"
}

fastfetch

. "$HOME/.local/share/../bin/env"

# Word movement in Ghostty
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
