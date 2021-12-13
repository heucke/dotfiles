#!/usr/bin/env zsh

source ~/.common.bash

# zsh configuration {{{
bindkey -e

export HISTFILE=~/.zsh_history
export HISTORY_IGNORE="(e|l|ls|ll|la|cd|pwd|exit|bg|fg|history|reset|clear)"
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE

# man zshoptions
setopt AUTO_MENU
setopt BANG_HIST
setopt COMPLETE_IN_WORD
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_FUNCTIONS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY # replaces EXTENDED_HISTORY and INC_APPEND_HISTORY
setopt pipefail
# }}}

# prompt {{{
function pipe_status() {
  local stats=( $pipestatus )
  p=false
  for stat in "${stats[@]}"; do
    if [[ $stat != 0 ]]; then
      p=true
    fi
  done
  if [[ "$p" == "true" ]]; then
    echo -n "[Exit "
    for stat in "${stats[@]}"; do
      # If process exited by a signal, determine name of signal.
      if test $stat -gt 128; then
        local signal="$(builtin kill -l $[$stat - 128] 2>/dev/null)"
        test "$signal" && signal=" ($signal)"
      fi
      local red=""
      local nocolor="\033[0m"
      if test $stat -gt 0; then
        red="\033[1;31m"
      fi
      echo -ne "${red}$stat${nocolor}$signal|"
    done
    echo "\b]"
  fi
}
py_ve() { [[ -n "$VIRTUAL_ENV" ]] && echo -n "%{%F{3}%}v%{%f%}"; }
ps_host() { [[ -n "$SSH_CLIENT" ]] && echo -n "%{%F{246}%}%m%{%f%} "; }
source ~/bin/git-prompt.sh
precmd () { __git_ps1 "
%{%F{246}%}╭─[%T]%1(j.z%j.)%{%f%}$(py_ve) $(ps_host)%{%F{4}%}%(6~|.../%5~|%~)%{%f%}" "
%{%F{246}%}╰──▶%{%f%} " }
precmd_functions+=(pipe_status)
# }}}

# load local configurations
[[ -e ~/.local.sh ]] && source ~/.local.sh

### Added by Zinit's installer {{{
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

typeset -gA FAST_HIGHLIGHT_STYLES
lightmodebg=229
darkmodebg=237
currentbg=$darkmodebg
if [[ "$LIGHTS" == "on" ]]; then currentbg=$lightmodebg; fi
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}here-string-text]="fg=blue,bg=$currentbg"
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}here-string-var]="fg=cyan,bg=$currentbg"
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}subtle-bg]="bg=$currentbg"
### End of Zinit's installer chunk }}}

# load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
