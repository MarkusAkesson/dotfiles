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
set completeopt=menuone,noinsert,noselect
"set completeopt-=preview  " Disable the preview window during the autocomplete process
set backspace=indent,eol,start
set rtp+=/home/markus/repos/fzf
set cmdheight=2
set shortmess+=c " Dont show the "math xx of xx" or other messages during autocomplete
set autoread " automatically update buffer when file changed externally
" For conceal markers.
au FileType rust,c,cpp,python setlocal conceallevel=2 concealcursor=niv

set timeoutlen=200

let mapleader=","
let localleader ="\\"

" Go to previous and next in quickfix list
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap <leader>cq :cclose<cr>
nnoremap <leader>co :copen<cr>

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
" cpp
au FileType cpp setlocal shiftwidth=2 softtabstop=2 tabstop=2

" asm settings
au FileType asm setlocal ft=nasm

" Markdown
au FileType markdown setlocal spell spelllang=en_us
"
" TeX
autocmd BufNewFile,BufRead *.tex set filetype=tex
au FileType tex setlocal spell spelllang=en_us
let g:Tex_BibtexFlavor='biber'
let g:Tex_DefaultTargetFormat='pdf'

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
Plug 'itchyny/lightline.vim'
Plug '/home/markus/repos/fzf'
Plug 'junegunn/fzf.vim'
Plug 'Shougo/echodoc'
Plug 'bronson/vim-trailing-whitespace'
Plug 'junegunn/goyo.vim'
"Plug 'dense-analysis/ale'
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'
Plug 'honza/vim-snippets'
Plug 'liuchengxu/vista.vim'
Plug 'rhysd/vim-clang-format'
Plug 'lervag/vimtex'
Plug 'vim-syntastic/syntastic'
Plug 'neovim/nvim-lsp'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'Shougo/deoplete-lsp'
Plug 'Shougo/neosnippet.vim'
call plug#end()

"========== LSP
autocmd Filetype rust,python,c,cpp setl omnifunc=v:lua.vim.lsp.omnifunc
"packadd nvim-lsp
lua << EOF
    local nvim_lsp = require('nvim_lsp')
    require'nvim_lsp'.rust_analyzer.setup{}
    require'nvim_lsp'.clangd.setup{}
    require'nvim_lsp'.pyls.setup{}
EOF

nnoremap <silent> <leader>dc <cmd>:lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>gd <cmd>:lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>h  <cmd>:lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>i  <cmd>:lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>s  <cmd>:lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>K  <cmd>:lua vim.lsp.buf.type_definition()<CR>

"========== Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
call deoplete#custom#option('ignore_sources', {'_': ['around', 'buffer']})
" maximum candidate window length
call deoplete#custom#source('_', 'max_menu_width', 80)
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

"========== Neosnippet
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-y>"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-j>"
let g:UltiSnipsRemoveSelectModeMappings = 0

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
\}
"
"let g:ale_linters = {
\'python3': [ 'pylint'],
\'python': [ 'pylint'],
\}

"========== Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFLag()}
set statusline+=%*

let g:syntastic_always_poopulate_loc_list = 1
let g:syntastic_auto_list = 1
let g:syntastic_check_on_open = 1
let g:syntatsic_check_on_wq = 1

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
let g:clang_format#code_style = "google"
autocmd FileType c,cpp nnoremap <buffer><Leader>c :<C-u>ClangFormat<CR>
autocmd FileType c,cpp vnoremap <buffer><Leader>c :<C-u>ClangFormat<CR>
autocmd FileType c,cpp ClangFormatAutoEnable
nmap <Leader>C :ClangFormatAutoToggle<CR>

"========== VimTex
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_method = 'zathura'
"aaugroup my_cm_setup
"    autocmd!
"    "autocmd BufEnter * call ncm2#enable_for_buffer()
"    autocmd Filetype tex call ncm2#register_source({
"        \ 'name': 'vimtex',
"        \ 'priority': 8,
"        \ 'scope': ['tex'],
"        \ 'mark': 'tex',
"        \ 'word_pattern': '\w+',
"        \ 'complete_pattern': g:vimtex#re#ncm2,
"        \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
"        \ })
"augroup END

"==========Colorscheme Nord======
"let g:nord_comment_brightness = 20
"let g:nord_italic_comments = 1
"set background=dark
"colorscheme nord

"==========Colorscheme OneDark======
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
