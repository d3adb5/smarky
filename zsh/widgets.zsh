fzf-smarky-pick-command() {
  setopt localoptions noglobsubst noposixbuiltins pipefail 2>/dev/null
  local selected previewcmd="smarky select \$(cut -d' ' -f1 <<< {})"

  type bat >/dev/null 2>&1 && \
    previewcmd="bat -l sh --color always --decorations never <($previewcmd)"

  selected="$(smarky list | fzf --height 40% --tiebreak=index \
    --preview "$previewcmd" | cut -d' ' -f1 | xargs -r smarky select)"

  [ -n "$selected" ] && LBUFFER="$selected"
  zle reset-prompt
}

fzf-smarky-next-field() {
  setopt localoptions noglobsubst noposixbuiltins pipefail 2>/dev/null
  [ -z "$RBUFFER" ] && CURSOR=0
  local subtracted="${RBUFFER#*\{\{}" offset
  offset=$(( ${#RBUFFER} - ${#subtracted} - 2 + $CURSOR ))
  CURSOR=offset; RBUFFER="${RBUFFER#*\}\}}"
}

zle -N fzf-smarky-pick-command
bindkey '^J' fzf-smarky-pick-command

zle -N fzf-smarky-next-field
bindkey '^G' fzf-smarky-next-field
