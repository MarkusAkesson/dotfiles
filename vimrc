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
" set t_Co=256
" set termguicolors

" clipboard
set clipboard=unnamedplus " enable system clipboard

" Misc
syntax on
" set textwidth=80
" set noshowmode
set hidden " hide file, dont close it on file switch
set signcolumn=yes " always draw the signcolumn
set mouse=a
set completeopt=longest,menuone,noinsert
"set completeopt+=menu,longest
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
inoremap <expr> <cr> ((pumvisible())?("\<C-Y>"):("<\<cr>"))

""""" Language settings

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
"Plug 'w0rp/ale'
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
call plug#end()

"=========DEOPLETE===========
set runtimepath+=~/.vim/plugged/deoplete.nvim/
let g:deoplete#enable_at_startup=1
let g:deoplete#enable_smart_case=1
let g:deoplete#enable_refresh_always=0
let g:deoplte#max_abbr_width=0
let g:deoplte#max_menu_width=0
"if !exists('g:deoplete#omni#input_patterns')
"    let g:deoplete#omni#input_patterns = {}
"endif
let g:deoplete#sources = {}
"call deoplete#custom#source('_',
"    \ 'disabled_syntaxes', ['Comment', 'String'])
call deoplete#custom#source('LanguageClient',
            \ 'min_pattern_length',
            \ 2)

"==========Neosnippets==========
let g:neosnippet#enable_completed_snippet=1
let g:neosnippet#enable_complete_done=1

imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

"==========Language-client Neovim=================
let g:LanguageClient_autoStart=1
let g:LanguageClient_serverCommands = {
    \ 'rust': ['ra_lsp_server'],
    \ 'cpp': ['clangd-7'],
    \ 'c': ['clangd-7'],
    \ 'python': ['pyls'],
    \ 'python3': ['pyls'],
    \ 'javascript': ['/home/markus/repos/javascript-typescript-langserver/lib/language-server-stdio'],
    \ 'typescript': ['/home/markus/repos/javascript-typescript-langserver/lib/language-server-stdio'],
    \ }
set formatexpr=LanguageClient_textDocument_rangeFormatting()
let g:LanguageClient_hasSnippetSupport=1
"
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
\}

let g:ale_linters = {
\'python3': [ 'pylint'],
\'python': [ 'pylint'],
\'rust' : ['rls', 'cargo'],
\}

"========== Echo doc ============
let g:echodoc_enable_at_startup = 1
let g:echodoc#type = 'signature'

"========== FZF =============
nnoremap <c-p> :FZF<cr>
nnoremap <leader>f :BLines<cr>
nnoremap <leader>F :Lines<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>r :Rg<cr>
nnoremap <leader>t :BTags<cr>
nnoremap <leader>T :Tags<cr>

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
