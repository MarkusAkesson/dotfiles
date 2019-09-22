" Default indent options
set autoindent
set smartindent
set shiftround
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set smarttab

" Sidecol numbers
set number
set relativenumber

" Buffers
set splitright " horizontal splits open right of the current window
set splitbelow " vertical splits open below the current window

" Colors
syntax on
" set t_Co=256
" set termguicolors

" clipboard
set clipboard=unnamedplus " enable system clipboard

" Misc
" set textwidth=80
" set noshowmode
set hidden " hide file, dont close it on file switch
set signcolumn=yes " always draw the signcolumn
set mouse=a
set completeopt=longest,menuone,noinsert ",noselect
"set completeopt-=preview  " Disable the preview window during the autocomplete process
set backspace=indent,eol,start
set rtp+=/home/markus/repos/fzf
set cmdheight=2
set shortmess+=c " Dont show the "math xx of xx" or other messages during autocomplete
set autoread " automatically update buffer when file changed externally
" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
set timeoutlen=200

let mapleader=","

" Go to previous and next in quickfix list
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>

" Insert blanline above or below
nnoremap oo o<ESC>
nnoremap OO O<ESC>

" reload init and give a message
nnoremap <silent> <leader>lv :so $MYVIMRC<cr>

" Edit vimrc in a vertical split
nnoremap <silent> <leader>ev :edit ~/.vimrc<cr>

" when completion menu is shown, use <cr> to selct an item
" and do not add a newline
" when not in completion menu cr bejaves as expected
" inoremap <expr> <cr> ((pumvisible())?("\<C-Y>"):("\<cr>"))

""""" Language settings
au FileType cpp setlocal shiftwidth=2 softtabstop=2 tabstop=2

" asm settings
au FileType asm setlocal ft=nasm

"""""" Plugins

" Auto install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }
Plug 'joshdick/onedark.vim'
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
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-ultisnips'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'liuchengxu/vista.vim'
Plug 'rhysd/vim-clang-format'
call plug#end()

"========== ncm2 =============
autocmd BufEnter * call ncm2#enable_for_buffer()
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
"inoremap <silent> <expr> <CR> pumvisible() ? ncm2_ultisnips#expand_or("\<CR>", 'n') : "\<CR>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" let g:UltiSnipsExpandTrigger="<c-y>"
" Press enter key to trigger snippet expansion
" The parameters are the same as `:help feedkeys()
inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')
" let g:UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-j>"
let g:UltiSnipsRemoveSelectModeMappings = 0

"==========Language-client Neovim=================
let g:LanguageClient_autoStart=1
let g:LanguageClient_serverCommands = {
    \ 'rust': ['ra_lsp_server'],
    \ 'cpp': ['clangd'],
    \ 'c': ['clangd'],
    \ 'python': ['pyls'],
    \ 'python3': ['pyls'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'typescript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'scala' :[ 'metals-vim'],
    \ }
set formatexpr=LanguageClient_textDocument_rangeFormatting()
let g:LanguageClient_diagnosticsEnable=0
let g:LanguageClient_hasSnippetSupport=1

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gr :call LanguageClient#textDocument_rename()<CR>

"========== Rust.vim ============
let g:rustfmt_autosave = 1
let g:rust_conceal = 1

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
\'javascript': [ 'eslint'],
\'typescript': [ 'eslint'],
\}

let g:ale_linters = {
\'python3': [ 'pylint'],
\'python': [ 'pylint'],
\'rust' : ['rls', 'cargo'],
\'javascript': [ 'eslint'],
\'typescript': [ 'eslint'],
\}

"========== Echo doc ============
let g:echodoc_enable_at_startup = 1
let g:echodoc#type = 'signature'

"========== FZF =============
nnoremap <c-p> :FZF<cr>
nnoremap <leader>f :BLines<cr>
nnoremap <leader>L :Lines<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>r :Rg<cr>
nnoremap <leader>t :BTags<cr>
nnoremap <leader>T :Tags<cr>

"========== Vista ==========
nmap <leader>ct :Vista!!<CR>
let g:vista_fzf_preview = ['right:50%']
"========== Clang-Format ==========
" Google is the default style guide to follow
"let g:clang_format#code_style = "google"
autocmd FileType c,cpp nnoremap <buffer><Leader>c :<C-u>ClangFormat<CR>
autocmd FileType c,cpp vnoremap <buffer><Leader>c :<C-u>ClangFormat<CR>
autocmd FileType c,cpp ClangFormatAutoEnable
nmap <Leader>C :ClangFormatAutoToggle<CR>

"========Colorscheme Nord======
"let g:nord_comment_brightness = 20
"let g:nord_italic_comments = 1
"set background=dark
"colorscheme nord

"========Colorscheme OneDark======
if (has("nvim"))
"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    set termguicolors
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("+termguicolors"))
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
let g:onedark_termcolors=256
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ }

colorscheme onedark
