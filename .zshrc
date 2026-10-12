# --- PATH ---
export PATH="/Applications/MATLAB_R2022b.app/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# --- Aliases ---
alias python=python3
alias pip=pip3

# --- q / kdb ---
export QHOME=~/q
alias q='QHOME=~/q rlwrap -r ~/q/m64/q'

# --- History ---
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY        # other open shells see new commands
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS # keep only the latest copy of each command
setopt HIST_VERIFY

# --- Starship prompt ---
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# --- fzf ---
if command -v fzf &>/dev/null; then
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview-window=right:50%'
  source <(fzf --zsh)   # Ctrl+R, Ctrl+T, Alt+C, plus completion
fi

export CLAUDE_CODE_NO_FLICKER=1
