# environment {{{
set fish_greeting
set fish_prompt_pwd_dir_length 4

set -x PATH $HOME/bin $HOME/.local/bin /usr/local/bin /usr/bin /bin /usr/sbin /sbin $HOME/.fzf/bin
set -x PATH $PATH $HOME/bin_last

set -q LIGHTS || set -x LIGHTS off

set -q PYTHON3_BIN || set -x PYTHON3_BIN /usr/bin

set -e goinstall
if test -d $HOME/.go-install
    set goinstall $HOME/.go-install
else if test -d /usr/local/opt/go/libexec
    set goinstall /usr/local/opt/go/libexec
else if test -d /usr/local/go
    set goinstall /usr/local/go
else if test -d /usr/lib/go
    set goinstall /usr/lib/go
end
if set -q goinstall
    set -e GOPATH
    set -x PATH $goinstall/bin $HOME/go/bin $PATH
    set -e goinstall
end

if test -d $HOME/.cargo/bin
    set -x PATH $HOME/.cargo/bin $PATH
end

if test -x $HOME/.n/bin/n
    set -x N_PREFIX $HOME/.n
    set -x PATH $N_PREFIX/bin $PATH
end

if type -f nvim >/dev/null 2>&1
    set -x EDITOR nvim
else
    set -x EDITOR vim
end

set -x LS_COLORS 'ex=00:su=00:sg=00:ca=00:'
if test -f $HOME/setup/gruvbox_256palette.sh
    sh $HOME/setup/gruvbox_256palette.sh
end

if test -x /usr/bin/batcat
    alias bat batcat
end
if type bat >/dev/null 2>&1
    if test "$LIGHTS" = on
        set -x BAT_THEME gruvbox-light
    else
        set -x BAT_THEME gruvbox-dark
    end
    alias cat bat
end

if test -x /usr/bin/fdfind
    alias fd fdfind
    set -x FD_CLI fdfind
else
    set -x FD_CLI fd
end

if type fd >/dev/null 2>&1
    set FD_IGNORES "-E '.git'"
    set -x FZF_DEFAULT_COMMAND "$FD_CLI --type file --hidden --no-ignore --follow $FD_IGNORES"
    set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -x FZF_ALT_C_COMMAND "$FD_CLI --type directory --hidden --no-ignore --follow $FD_IGNORES"
else if type rg >/dev/null 2>&1
    set RG_IGNORES '--glob "!.git/*"'
    set -x FZF_DEFAULT_COMMAND "rg --files --no-ignore --hidden --follow $RG_IGNORES 2>/dev/null"
    set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
end
set -x FZF_DEFAULT_OPTS "
--ansi
--layout=reverse
--no-height
--preview-window=hidden
--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
--bind '?:toggle-preview'
--bind 'ctrl-b:preview-up,ctrl-f:preview-down'
"
function fzf
    if test (tput cols) -lt 120
        command fzf --preview-window 'down:60%' $argv
    else
        command fzf --preview-window 'right:50%' $argv
    end
end

# personal stuff
set -x HOMEPAGE_SERVER https://rip.ac
# environment }}}

# gpg {{{
function egpg
    if ! test -d /Volumes/T5
        echo "Error: T5 external drive is not mounted." >&2
        return 1
    end
    gpg --home/Volumes/T5/gpg/gnupg $argv
end
if test -d $HOME/.gnupg
    set -x GPG_TTY (tty)
end
set -x GPG_KEY 0x36D9A232C37820BF
# gpg }}}

# aliases {{{
alias e "\$EDITOR"
alias d 'git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# builtins
alias rm "rm -i"
if test "$OSTYPE" = "darwin*"
    alias ls gls
    alias readlink greadlink
end
if command -sq exa
    alias ll "exa --long --group-directories-first --color=auto"
    alias la "exa -a --long --group-directories-first --color=auto"
    alias lg "exa --long --git --git-ignore --group-directories-first --color=auto"
    alias l "exa --oneline --group-directories-first --color=auto"
else
    alias ll "ls --group-directories-first -Fhl --color=auto"
    alias la "ls --group-directories-first -AFhl --color=auto"
    alias l "ls --group-directories-first -Fh1 --color=auto"
end
alias less "less -FSRXc"
alias rsync "rsync -ahSH --progress"

# programs
alias dk docker
alias dkc docker-compose
if ! type -f ffmpeg >/dev/null 2>&1
    alias ffmpeg 'docker run --rm -v "(pwd):/tmp/ffmpeg" opencoconut/ffmpeg'
end
alias pb "xsel --clipboard"
alias kc "kubectl config current-context"
# https://github.com/DanielFGray/fzf-scripts
alias jqfzf="fzrepl -c 'jq -r {q}' -q ."

# music
alias beet "echo 'Use tbeet for Tyler or mbeet for Mark.'"
alias mbeet "command beet --config=/flash/drive/mark/Music/mark-beets-config.yml"
alias tbeet "command beet --config=/flash/drive/tyler/Music/tyler-beets-config.yml"
# aliases }}}

# functions {{{
function merge_history --on-event fish_prompt
    # read shell commands from other active shell sessions after pressing enter
    # this lets you press up to get the last command from the current session,
    # or up + enter to get the last command from any session, just like how zsh
    # operates (the way I have it configured)
    history merge
end

function cm
    mkdir -p $argv[1] && builtin cd $argv[1] || return
end

function hstat
    curl -o /dev/null --silent --head --write-out '%{http_code}\n' $argv
end

function ssh
    if test "$TERM" = "screen*" || test "$TERM" = "tmux*"
        env TERM=screen-256color command ssh $argv
    else
        command ssh $argv
    end
end

function tree
    if command -sq exa
        exa --long --tree --level=3 --group-directories-first --git --git-ignore --ignore-glob 'target|node_modules|.git' --color=always $argv | bat --color
    else
        command tree -I 'target|node_modules|.git' -ash -F -C --dirsfirst
    end
end
# functions }}}

# more lscolors {{{
if test -f $HOME/bin/gruvbox.dircolors && type -f dircolors >/dev/null 2>&1
    # generated with dircolors ~/bin/gruvbox.dircolors
    set -x LS_COLORS 'no=0;38;15:rs=0:di=1;34:ln=01;35:mh=00:pi=40;33'\
':so=1;38;211:do=01;35:bd=40;33;01:cd=40;33;01'\
':or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42'\
':ow=30;42:st=37;44:ex=1;30;32:*.tar=01;31:*.tgz=01;31:'\
'*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:'\
'*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31'\
':*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31'\
':*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31'\
':*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31'\
':*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31'\
':*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31'\
':*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35'\
':*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35'\
':*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35'\
':*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35'\
':*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35'\
':*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35'\
':*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35'\
':*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35'\
':*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35'\
':*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35'\
':*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35'\
':*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35'\
':*.ogx=01;35:*.aac=01;33:*.au=01;33:*.flac=01;33'\
':*.mid=01;33:*.midi=01;33:*.mka=01;33:*.mp3=01;33'\
':*.mpc=01;33:*.ogg=01;33:*.ra=01;33:*.wav=01;33'\
':*.axa=01;33:*.oga=01;33:*.spx=01;33:*.xspf=01;33'\
':*.doc=01;91:*.ppt=01;91:*.xls=01;91:*.docx=01;91'\
':*.pptx=01;91:*.xlsx=01;91:*.odt=01;91:*.ods=01;91'\
':*.odp=01;91:*.pdf=01;91:*.tex=01;91:*.md=01;91:'
end
# }}}
