source /usr/share/cachyos-fish-config/cachyos-config.fish

set -gx GOPATH "$HOME/go"
fish_add_path $GOPATH/bin
fish_add_path $HOME/.local/bin

alias code=vscodium
