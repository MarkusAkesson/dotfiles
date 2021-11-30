eval (/opt/homebrew/bin/brew shellenv)
set PATH $HOME/.cargo/bin /usr/local/bin /usr/bin /usr/sbin /sbin $PATH
#set -Ux RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/src
#set -Ux LDFLAGS "-L/usr/local/opt/llvm/lib"
#set -Ux CPPFLAGS "-I/usr/local/opt/llvm/include"
#set -Ux LIBRARY_PATH "$LIBRARY_PATH:/opt/local/lib/"
set -Ux LIBRARY_PATH ""
set -Ux EDITOR nvim

set -Ux GOPATH $HOME/Programming/go

alias vim nvim

alias aceproxy "docker run -t -p 8000:8000 ikatson/aceproxy"
alias efishrc "nvim ~/.config/fish/config.fish"
alias evimrc "nvim ~/.vimrc"
#set -U FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'
set -Ux FZF_DEFAULT_COMMAND "fd --type file --color=always"
set -Ux FZF_FIND_FILE_COMMAND "fd --type file --color=always"
set -Ux FZF_DEFAULT_OPTS '--ansi'
set -Ux FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -Ux FZF_CTRL_T_OPTS $FZF_DEFAULT_OPTS

# Prepare keychain
if status --is-interactive
    keychain --quiet -Q --eval id_rsa id_ed25519 | source
end

starship init fish | source
