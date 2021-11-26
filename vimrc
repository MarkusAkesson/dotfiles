" Default indent options
set autoindent
set smartindent
set shiftround
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set smarttab
filetype plugin indent on

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
set clipboard+=unnamedplus " enable system clipboard

" Misc
" set textwidth=80
" set noshowmode
set hidden " hide file, dont close it on file switch
set signcolumn=yes " always draw the signcolumn
set mouse=a
set completeopt=menuone,noinsert,noselect
"set completeopt-=preview  " Disable the preview window during the autocomplete process
set backspace=indent,eol,start
set rtp+=/usr/bin/fzf
set cmdheight=2
set shortmess+=c " Dont show the "math xx of xx" or other messages during autocomplete
"set autoread " automatically update buffer when file changed externally
"
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

" TeX
autocmd BufNewFile,BufRead *.tex set filetype=tex
au FileType tex setlocal spell spelllang=en_us
let g:Tex_BibtexFlavor='biber'
let g:Tex_DefaultTargetFormat='pdf'
let g:tex_flavor = 'latex'

"""""" Plugins

" Auto install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
"Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do' : { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'dense-analysis/ale'
Plug 'rust-lang/rust.vim'
Plug 'liuchengxu/vista.vim'
Plug 'rhysd/vim-clang-format'
Plug 'lervag/vimtex'
Plug 'neovim/nvim-lsp'
Plug 'nvim-lua/completion-nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'tjdevries/lsp_extensions.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'morhetz/gruvbox'
call plug#end()

" Configure LSP
" https://github.com/neovim/nvim-lspconfig#rust_analyzer
lua <<EOF

-- nvim_lsp object
local nvim_lsp = require('lspconfig')

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Disable virtual text
        virtual_text = false,

        -- Show signs
        signs = true,

        -- Update while in insert mode
        update_in_insert = false,
    }
)

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- Enable rust_analyzer
require'lspconfig'.rust_analyzer.setup({ on_attach=on_attach })
require'lspconfig'.clangd.setup({ on_attach=on_attach })

EOF

" Configure TreeSitter
lua << EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
        highlight = {
            enable = true,
    },
}
EOF

" Code navigation shortcuts
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <leader>dn     <cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>
nnoremap <leader>dp     <cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Visualize diagnostics
let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_trimmed_virtual_text = '40'
" Don't show diagnostics while in insert mode
let g:diagnostic_insert_delay = 1

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>PrevDiagnosticCycle<cr>
nnoremap <silent> g] <cmd>NextDiagnosticCycle<cr>

" Enable type inlay hints
"autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
"\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment" }

"========== Rust.vim ============
let g:rustfmt_autosave = 1
"let g:rust_conceal = 1

"========== ALE =================
let g:ale_lint_text_changed = 'never'
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 0
let g:ale_fixers = {
\'*': ['remove_trailing_lines', 'trim_whitespace'],
\'python3': ['autopep8', 'yapf'],
\'python': ['autopep8', 'yapf'],
\}
"
let g:ale_linters = {
\'python3': [ 'pylint'],
\'python': [ 'pylint'],
\}

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
"let g:vimtex_compiler_progname = 'latexmk'
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-pdf',
    \   '-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}

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
  \ 'colorscheme': 'gruvbox',
  \ }

colorscheme gruvbox
