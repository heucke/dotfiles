#!/usr/bin/env bash

# environment {{{
export PATH=$HOME/bin:$HOME/.local/bin
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

export LIGHTS="${LIGHTS:-off}"

export PYTHON3_BIN=/usr/bin

# golang
unset goinstall
if [[ -d "$HOME/.go-install" ]]; then
  goinstall="$HOME/.go-install"
elif [[ -d /usr/local/opt/go/libexec ]]; then
  goinstall="/usr/local/opt/go/libexec"
elif [[ -d /usr/local/go ]]; then
  goinstall="/usr/local/go"
elif [[ -d /usr/lib/go ]]; then
  goinstall="/usr/lib/go"
fi
if [[ -n "$goinstall" ]]; then
  unset GOPATH
  export PATH=$goinstall/bin:$HOME/go/bin:$PATH
fi
unset goinstall

# rust
if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# node / n
if [[ -x "$HOME/.n/bin/n" ]]; then
  export N_PREFIX=$HOME/.n
  export PATH=$N_PREFIX/bin:$PATH
fi

# essentials
export EDITOR=vim
command -v nvim >/dev/null 2>&1 \
  && export EDITOR=nvim

export LS_COLORS='ex=00:su=00:sg=00:ca=00:'
if [[ -f ~/bin/gruvbox.dircolors ]] && command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors ~/bin/gruvbox.dircolors)"
fi
if [[ -f ~/setup/gruvbox_256palette.sh ]]; then
  # shellcheck source=/dev/null
  source ~/setup/gruvbox_256palette.sh
fi

# autoupgrade to "better" tools
## cat -> bat
[[ -x /usr/bin/batcat ]] && alias bat=batcat
if command -v bat >/dev/null 2>&1; then
  if [[ "$LIGHTS" == "on" ]]; then
    export BAT_THEME="gruvbox-light"
  else
    export BAT_THEME="gruvbox"
  fi
  alias cat=bat
fi
## find -> fd
fdh() {
  cat <<EOF
fd - find replacement

If {} is foo/bar.jpg:
- {.} is foo/bar
- {/} is bar.jpg
- {//} is foo
- {/.} is bar

fd foo -x convert {} {.}.png is like find -iname '*foo*' -exec 'convert ...'
fd foo -X for batch exec (all results in one exec)
EOF
}
FD_CLI="fd"
if [[ -x /usr/bin/fdfind ]]; then
  alias fd=fdfind
  FD_CLI="fdfind"
fi
# actually use fd
# command -v fd >/dev/null 2>&1 && alias find=fd

# set up fzf
if command -v fd >/dev/null 2>&1; then
  FD_IGNORES="-E '.git'"
  export FZF_DEFAULT_COMMAND="$FD_CLI --type file --hidden --no-ignore --follow $FD_IGNORES"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FD_CLI --type directory --hidden --no-ignore --follow $FD_IGNORES"
elif command -v rg >/dev/null 2>&1; then
  RG_IGNORES='--glob "!.git/*"'
  export FZF_DEFAULT_COMMAND="rg --files --no-ignore --hidden --follow $RG_IGNORES 2>/dev/null"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
export FZF_DEFAULT_OPTS="
--ansi
--layout=reverse
--no-height
--preview-window=hidden
--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
--bind '?:toggle-preview'
--bind 'ctrl-b:preview-up,ctrl-f:preview-down'
"
fzf() {
  if [[ "$(tput cols)" -lt 120 ]]; then
    command fzf --preview-window 'down:60%' $@
  else
    command fzf --preview-window 'right:50%' $@
  fi
}

# git-prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWCOLORHINTS=true

# personal stuff
export BOOKEND_SERVER=hety.io
export SRC_CA_CERT=/home/$USER/certs/prod/myCA.pem
export SRC_TLS_CERT=/home/$USER/certs/prod/duma.in.heucke.io.crt
export SRC_TLS_KEY=/home/$USER/certs/prod/duma.in.heucke.io.key
# }}}

# gpg {{{
egpg() {
  if [[ ! -d /Volumes/T5 ]]; then
    echo "Error: T5 external drive is not mounted." >&2
    return 1
  fi
  gpg --home=/Volumes/T5/gpg/.gnupg "$@"
}

if [[ -d ~/.gnupg ]]; then
  GPG_TTY=$(tty)
  export GPG_TTY
fi

export GPG_KEY="0x36D9A232C37820BF"
# }}}

# aliases {{{
alias e="\$EDITOR"
alias d='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# builtins
alias rm="rm -i"
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias ls=gls
  alias readlink=greadlink
fi
if command -v exa &>/dev/null; then
    alias ll="exa --long --group-directories-first --color=auto"
    alias la="exa -a --long --group-directories-first --color=auto"
    alias lg="exa --long --git --git-ignore --group-directories-first --color=auto"
    alias l="exa --oneline --group-directories-first --color=auto"
else
    alias ll="ls --group-directories-first -Fhl --color=auto"
    alias la="ls --group-directories-first -AFhl --color=auto"
    alias l="ls --group-directories-first -Fh1 --color=auto"
fi
alias less="less -FSRXc"
alias rsync="rsync -ahSH --progress"

# programs
alias dk="docker"
alias dkc="docker-compose"
if ! command -v ffmpeg >/dev/null 2>&1; then
  alias ffmpeg='docker run --rm -v "$(pwd):/tmp/ffmpeg" opencoconut/ffmpeg'
fi
alias pb="xsel --clipboard"
alias kc="kubectl config current-context"
alias hstat="curl -o /dev/null --silent --head --write-out '%{http_code}\n'" $1

# music
alias beet="echo 'Use tbeet for Tyler or mbeet for Mark.'"
alias mbeet="\beet --config=/data/music/mark.config.yaml"
alias tbeet="\beet --config=/data/music/tyler.config.yaml"
# }}}

# functions {{{
italicize() {
  printf "%s%s%s" $'\x1b[3m' "$*" $'\x1b[0m'
}

# create folder if necessary before entering it
cm() { mkdir -p "$1" && builtin cd "$1" || return; }

ssh() {
  if [[ "${TERM}" = screen* || "${TERM}" = tmux* ]]; then
    env TERM=screen-256color ssh "$@"
  else
    command ssh "$@"
  fi
}

tree() {
  if command -v exa &>/dev/null; then
    exa --long --tree --level=3 --group-directories-first --git --git-ignore --ignore-glob 'target|node_modules|.git' --color=always $@ | bat --color
  else
    command tree -I 'target|node_modules|.git' -ash -F -C --dirsfirst
  fi
}
# }}}

export PATH=$PATH:$HOME/bin_last
