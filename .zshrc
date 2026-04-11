
export PATH="/Applications/MATLAB_R2022b.app/bin:$PATH"
alias python=python3
alias pip=pip3
export QHOME=~/q
alias q='QHOME=~/q rlwrap -r ~/q/m64/q'
eval "$(starship init zsh)"

source /opt/homebrew/opt/fzf/shell/completion.zsh

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY
setopt inc_append_history_time
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_VERIFY

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview-window=right:50%'
export FZF_CTRL_R_OPTS='--layout=reverse --border --height=40%'

__fzf_history_widget() {
  local selected num cur_time tz_sec
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  cur_time=$(date +%s)
  tz_sec=$(date +%z | awk '{s=substr($0,1,1); h=substr($0,2,2)+0; m=substr($0,4,2)+0; print (s=="-"?-1:1)*(h*3600+m*60)}')
  selected=$(awk -F';' -v cur="$cur_time" -v tz="$tz_sec" -v max_age=2419200 '{
    if($1 ~ /^: [0-9]+:[0-9]+$/) {
      split($1,a,":");
      ts=a[2];
      delta=cur-ts;
      if(delta < 0 || delta > max_age) next
      delta_days=int(delta/86400);
      if(delta<0) { label="+" (-delta_days) "d" }
      else if(delta_days<1 && delta<72000) {
        local_ts=ts+tz
        h=int(local_ts%86400/3600)
        m=int(local_ts%3600/60)
        label=sprintf("%02d:%02d", h, m)
      }
      else if(delta_days==0) { label="1d" }
      else { label=delta_days "d" }
      cmd_start=index($0,$2)
    } else {
      next
    }
    if(cmd_start > 0) {
      cmd=substr($0,cmd_start)
      if(!seen[cmd]++) print label "|" cmd
    }
  }' ~/.zsh_history 2>/dev/null |
    fzf +m --tac --query="${LBUFFER}" --height=40% --layout=reverse --border --with-nth=1.. --delimiter="|" --bind=ctrl-r:toggle-sort,enter:accept)
  local ret=$?
  if [[ $ret == 0 && -n "$selected" ]]; then
    LBUFFER="${selected#*|}"
  fi
  zle redisplay
  return $ret
}
zle     -N   __fzf_history_widget
bindkey '^R' __fzf_history_widget
