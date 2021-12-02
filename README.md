# Dotfiles

Setup from https://news.ycombinator.com/item?id=20142395

Setup:
```
git init --bare $HOME/.dotfiles
alias d='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
d config status.showUntrackedFiles no
```

Usage:
```
d status
d add .vimrc
d commit -m "Add vimrc"
d push
```

Replicate:
```
git clone --separate-git-dir ~/.dotfiles https://heuc.net/t/dotfiles ~/dotfiles-tmp
rm -rf ~/dotfiles-tmp
alias d='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
d config status.showUntrackedFiles no
d reset --hard HEAD
```

## Python for Vim

Whichever python you use, set `$PYTHON3_BIN` to point to the `python3` executable with `pynvim` installed in it.

## Clipboard

Getting a consistent clipboard between macOS, SSH, tmux, and vim is rather annoying. I've chosen to use `pbcopy` and `pbpaste` as the universal copy and paste commands. On macOS, use the system `/usr/bin/pb{copy,paste}`.

Elsewhere (e.g. Linux), use this setup.

On your Mac, configure `pb{copy,paste}` to listen for data on a local port
```
mkdir -p ~/Library/LaunchAgents/
cp -t ~/Library/LaunchAgents/ ~/setup/pbcopy.plist ~/setup/pbpaste.plist
launchctl load ~/Library/LaunchAgents/pbcopy.plist
launchctl load ~/Library/LaunchAgents/pbpaste.plist
```
And configure your ssh connection to forward our two required ports
```
Host myhost
    HostName 192.168.1.123
    User myname
    RemoteForward 2224 127.0.0.1:2224
    RemoteForward 2225 127.0.0.1:2225
```

Now, `~/bin_last/pb{copy,paste}` work remotely!
