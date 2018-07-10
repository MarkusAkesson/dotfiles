syntax on
set hidden
set signcolumn=yes
set mouse=a
set autoindent
set smartindent
set shiftround
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab 
set smarttab
set number
set relativenumber
"set t_Co=256
set splitright
set splitbelow
set textwidth=80
set termguicolors
set completeopt+=preview
set backspace=indent,eol,start
set rtp+=/usr/local/opt/fzf
set cmdheight=2

"========CHecks if Vim-Plug is installed before loading plugins 

    if empty(glob('~/.vim/autoload/plug.vim')) 
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'arcticicestudio/nord-vim'
Plug 'tpope/vim-surround'
let g:nord_comment_brightness = 20
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug '/usr/local/bin/fzf'
Plug 'junegunn/fzf.vim'
Plug 'Shougo/echodoc'
call plug#end()
"=========DEOPLETE=========== 
set runtimepath+=~/.vim/plugged/deoplete.nvim/
let g:deoplete#enable_at_startup = 1 
let g:deoplete#enable_smart_case = 1
if !exists('g:deoplete#omni#input_patterns') 
    let g:deoplete#omni#input_patterns = {} 
endif 
call deoplete#custom#source('_',
    \ 'disabled_syntaxes', ['Comment', 'String'])
call deoplete#custom#option('sources', {
    \ '_': ['file', 'buffer'],
    \ 'python': ['LanguageClient' ],
    \ 'python3': ['LanguageClient' ],
    \ 'cpp': ['LanguageClient' ],
    \ 'c': ['LanguageClient' ],
    \ 'rust': ['LanguageClient'],
\})
call deoplete#custom#source('LanguageClient',
            \ 'min_pattern_length',
            \ 2)
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ 'cpp': ['/usr/local/bin/cquery', '--log-file=/tmp/cq.log', '--init={"cacheDirectory":"/tmp/cquery/"}'],
    \ 'c': ['/usr/local/bin/cquery', '--log-file=/tmp/cq.log', '--init={"cacheDirectory":"/tmp/cquery/"}'],
    \ 'python': ['pyls'],
    \ }
let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
let g:LanguageClient_settingsPath = '/home/markusakesson/.config/nvim/settings.json'
set completefunc=LanguageClient#complete
set formatexpr=LanguageClient_textDocument_rangeFormatting()
" use tab to forward cycle
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" use tab to backward cycle
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

let g:echodoc_enable_at_startup = 1
nnoremap <F5> :call LanguageClient_contextMenu()<CR>

"========Colorscheme======
colorscheme nord
