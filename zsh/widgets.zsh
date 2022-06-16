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

zle -N fzf-smarky-pick-command
bindkey '^J' fzf-smarky-pick-command
