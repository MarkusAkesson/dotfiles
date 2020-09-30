set PATH $HOME/.bin $HOME/.cargo/bin /usr/local/bin /usr/bin /usr/sbin /sbin $HOME/.local/bin $PATH
set fish_function_path $fish_function_path /usr/share/powerline/fish

#set -Ux RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/src
#set -Ux LIBRARY_PATH "$LIBRARY_PATH
#set LD_LIBRARY_PATH /usr/local/gcc-9.1/lib64 $LD_LIBRARY_PATH
set -Ux EDITOR nvim

# make Java applications happy within DWM
#set -Ux _JAVA_AWT_WN_NONPARENTING 1
#set -Ux AWT_TOOLKIT MToolkit
#wmname LG3D

#set -Ux GOPATH /me2/repos/go

alias vim nvim

# Cmd aliases
#alias aceproxy "docker run -t -p 8000:8000 ikatson/aceproxy"
alias efishrc "nvim ~/.config/fish/config.fish"
alias evimrc "nvim ~/.vimrc"
alias eterm "nvim ~/.config/alacritty/alacritty.yml"
alias ls "ls -hl --color"
alias gotop ytop

# Launch aliases
#alias cutter "~/bin/Cutter-v1.8.1-x64.Linux.AppImage"
#alias ghidra "~/repos/ghidra_9.0.1/ghidraRun"
#alias matlab "/usr/local/MATLAB/R2019a/bin/matlab"
#alias intellij "~/bin/idea-IC-191.6707.61/bin/idea.sh"

set -Ux FZF_DEFAULT_COMMAND 'rg --files --color auto --ignore --hidden  --glob "!.git/*"'
#set -Ux FZF_DEFAULT_COMMAND "fd --type file --color=always"
#set -Ux FZF_FIND_FILE_COMMAND "fd --type file --color=always"
set -Ux FZF_DEFAULT_OPTS '--ansi'
set -Ux FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -Ux FZF_CTRL_T_OPTS $FZF_DEFAULT_OPTS

# Default rusflags, generates faster binaries
# set -Ux RUSTFLAGS "-C target-cpu=native"

# Enable powerline fonts
# powerline-setup

# Launch the starship prompt
eval (starship init fish)
