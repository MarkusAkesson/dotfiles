
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
set completeopt=noinsert,menuone,noselect
set backspace=indent,eol,start
set rtp+=/usr/local/opt/fzf
set cmdheight=2
let mapleader=","
set shortmess+=c


" linux c kernel style
au FileType c setlocal autoindent noexpandtab tabstop=8 shiftwidth=8 colorcolumn=80
"
" LLVM style
au FileType cpp setlocal autoindent expandtab tabstop=2 shiftwidth=2 softtabstop=2 colorcolumn=80

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" LLVM Makefiles can have names such as Makefile.rules or TEST.nightly.Makefile,
" so it's important to categorize them as such.
augroup filetype
  au! BufRead,BufNewFile *Makefile* set filetype=make
augroup END

" Enable syntax highlighting for LLVM files. To use, copy
" utils/vim/syntax/llvm.vim to ~/.vim/syntax .
augroup filetype
  au! BufRead,BufNewFile *.ll     set filetype=llvm
augroup END

call plug#begin()
Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }
Plug 'joshdick/onedark.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'roxma/nvim-yarp'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'itchyny/lightline.vim'
Plug '/usr/local/bin/fzf'
Plug 'junegunn/fzf.vim'
Plug 'Shougo/echodoc'
Plug 'majutsushi/tagbar'
Plug 'bronson/vim-trailing-whitespace'
Plug 'junegunn/goyo.vim'
Plug 'rhysd/vim-clang-format'
Plug 'rhysd/vim-llvm'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'w0rp/ale'
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'rust-lang/rust.vim'
Plug 'ncm2/ncm2-ultisnips'
call plug#end()


"=========ALE=================
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'rust': ['ra_lsp_server'],
\}
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 0


"========= ncm2 =============
autocmd BufEnter * call ncm2#enable_for_buffer()

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<c-y>"
" Press enter key to trigger snippet expansion
" The parameters are the same as `:help feedkeys()
inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-j>"
let g:UltiSnipsRemoveSelectModeMappings = 0


"=========Language-client Neovim=================
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
    \ 'rust': ['ra_lsp_server'],
    \ 'cpp': ['/usr/local/Cellar/llvm/8.0.0/bin/clangd'],
    \ 'c': ['/usr/local/Cellar/llvm/8.0.0/bin/clangd'],
    \ 'python': ['pyls'],
    \ 'python3': ['pyls'],
    \ 'typescript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ }
let g:LanguageClient_diagnosticsEnable = 1
"let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
"let g:LanguageClient_settingsPath = '/home/markusakesson/.config/nvim/settings.json'
"let g:LanguageClient_hasSnippetSupport = 0
"set completefunc=LanguageClient#complete
"set formatexpr=LanguageClient_textDocument_rangeFormatting()
" use tab to forward cycle
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" use tab to backward cycle
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

nnoremap <F5> :call LanguageClient_contextMenu()<CR>

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gr :call LanguageClient#textDocument_rename()<CR>

"========== Echo doc ============
let g:echodoc_enable_at_startup = 1

"========== FZF =============

nnoremap <c-p> :FZF<cr>
nnoremap <leader>f :BLines<cr>
nnoremap <leader>F :Lines<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>r :Rg<cr>
nnoremap <leader>t :BTags<cr>

"======== Rust.vim ======
let g:rustfmt_autosave = 1



" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

"========Statusline=======
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ }

"=======Clang-format=====
let g:clang_format#code_style="llvm"
nnoremap <leader>c :ClangFormat<cr>

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
