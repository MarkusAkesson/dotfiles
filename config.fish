set PATH $HOME/.bin $HOME/.cargo/bin /usr/local/bin /usr/bin /usr/sbin /sbin $HOME/.local/bin $PATH
set fish_function_path $fish_function_path /usr/share/powerline/fish

#set -Ux RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/src
#set -Ux LIBRARY_PATH "$LIBRARY_PATH
#set LD_LIBRARY_PATH /usr/local/gcc-9.1/lib64 $LD_LIBRARY_PATH
set -Ux EDITOR nvim

# make Java applications happy within DWM
set -Ux _JAVA_AWT_WN_NONPARENTING 1
set -Ux AWT_TOOLKIT MToolkit
wmname LG3D

set -Ux GOPATH /me2/repos/go

alias vim nvim

# Cmd aliases
alias vim nvim
alias efishrc "nvim ~/.config/fish/config.fish"
alias evimrc "nvim ~/.vimrc"
alias eterm "nvim ~/.config/alacritty/alacritty.yml"
alias ls "ls -hl --color"
alias gotop ytop

# Launch aliases
# alias ghidra "~/repos/ghidra_9.0.1/ghidraRun"
alias cutter "~/.bin/Cutter-v1.12.0-x64.Linux.AppImage"

# FZF
set -Ux FZF_DEFAULT_COMMAND 'rg --files --color auto --ignore --hidden  --glob "!.git/*"'
#set -Ux FZF_DEFAULT_COMMAND "fd --type file --color=always"
#set -Ux FZF_FIND_FILE_COMMAND "fd --type file --color=always"
set -Ux FZF_DEFAULT_OPTS '--ansi'
set -Ux FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -Ux FZF_CTRL_T_OPTS $FZF_DEFAULT_OPTS

# Enable powerline fonts
# powerline-setup

# Prepare keychain
if status --is-interactive
    keychain --quiet -Q --eval id_rsa id_ed25519 | source
end

# Dev
set -Ux CC clang
set -Ux CXX clang++
# Launch the starship prompt
starship init fish | source
