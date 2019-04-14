syntax on
set noshowmode
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
"set termguicolors
set completeopt+=preview
set backspace=indent,eol,start
set rtp+=/home/markus/repos/fzf
set cmdheight=2
set shortmess+=c

let mapleader=","

" linux c kernel style
au FileType c,h setlocal autoindent noexpandtab tabstop=8 shiftwidth=8 colorcolumn=80
au FileType asm setlocal ft=nasm

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    "autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }
Plug 'joshdick/onedark.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
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
Plug 'itchyny/lightline.vim'
Plug '/home/markus/repos/fzf'
Plug 'junegunn/fzf.vim'
Plug 'Shougo/echodoc'
Plug 'bronson/vim-trailing-whitespace'
Plug 'junegunn/goyo.vim'
Plug 'w0rp/ale'
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'
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
call deoplete#custom#source('LanguageClient',
            \ 'min_pattern_length',
            \ 2)

"=========Language-client Neovim=================
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ 'cpp': ['clangd-7'],
    \ 'c': ['clangd-7'],
    \ 'python': ['pyls'],
    \ 'python3': ['pyls'],
    \ 'javascript': ['/home/markus/repos/javascript-typescript-langserver/lib/language-server-stdio'],
    \ 'typescript': ['/home/markus/repos/javascript-typescript-langserver/lib/language-server-stdio'],
    \ }
let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
let g:LanguageClient_settingsPath = '/home/markus/.config/nvim/settings.json'
let g:LanguageClient_hasSnippetSupport = 0
set completefunc=LanguageClient#complete
set formatexpr=LanguageClient_textDocument_rangeFormatting()
" use tab to forward cycle
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" use tab to backward cycle
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

nnoremap <F5> :call LanguageClient_contextMenu()<CR>

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gr :call LanguageClient#textDocument_rename()<CR>

"========== Rust.vim ============
let g:rustfmt_autosave = 1

"========== ALE =================
let g:ale_lint_text_changed = 'never'
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 0
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
let g:ale_fixers = {
\'*': ['remove_trailing_lines', 'trim_whitespace'],
\'python3': ['autopep8', 'yapf'],
\'python': ['autopep8', 'yapf'],
\'rust' : ['rustfmt'],
\}

let g:ale_linters = {
\'python3': [ 'pylint'],
\'python': [ 'pylint'],
\'rust' : ['rls', 'cargo'],
\}

"========== Echo doc ============
let g:echodoc_enable_at_startup = 1

"========== FZF =============
nnoremap <c-p> :FZF<cr>
nnoremap <leader>f :BLines<cr>
nnoremap <leader>F :Lines<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>r :Rg<cr>
nnoremap <leader>t :BTags<cr>
nnoremap <leader>T :Tags<cr>

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

"========Statusline=======
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ }

"========Colorscheme Nord======
"let g:nord_comment_brightness = 20
"let g:nord_italic_comments = 1
"set background=dark
"colorscheme nord

"========Colorscheme OneDark======
syntax on
if (has("nvim"))
"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("+termguicolors"))
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
let g:onedark_termcolors=16
colorscheme onedark
