fzf-smarky-pick-command() {
  setopt localoptions noglobsubst noposixbuiltins pipefail 2>/dev/null
  local previewcmd="smarky select \$(cut -d' ' -f1 <<< {})"
  local command="$(smarky list | fzf --height 40% --tiebreak=index \
    --preview "$previewcmd" | cut -d' ' -f1 | xargs -r smarky select)"
  LBUFFER="$command"
  zle reset-prompt
}

zle -N fzf-smarky-pick-command
bindkey '^J' fzf-smarky-pick-command
