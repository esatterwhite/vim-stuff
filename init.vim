filetype off
filetype plugin indent on
syntax on
set nocompatible
set cursorline
set termguicolors
set list
set number
set expandtab
set t_Co=256
set encoding=UTF-8
set shiftwidth=2
set tabstop=2
set laststatus=2
set mouse=a
set colorcolumn=85
set background=dark
set completeopt=menu,menuone,preview,noselect,noinsert
let g:python3_host_prog = '/usr/bin/python3'
let g:loaded_python_provider = 1
let g:go_bin_path = '/home/esatterwhite/local/go'
let g:enable_bold_font = 1

" ALE
let g:ale_go_langserver_executable = 'gopls'
let g:ale_rust_rls_executable = 'rls'
let g:ale_rust_analyzer_executable = 'rust-analyzer'
let g:ale_completion_enabled = 1
let g:ale_linters = {
\ 'python': ['flake8', 'yapf', 'pycodestyle'],
\ 'go' : ['gopls'],
\ 'lua': ['selene'],
\ 'rust': ['analyzer'],
\ 'swagger': ['spectral']
\ }
let g:ale_fixers = {
\  'go': ['gofmt', 'goimports'],
\  'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'],
\  'javascript': ['eslint'],
\  'sh': ['shfmt'],
\  'python': ['yapf', 'autopep8'],
\  'lua': ['stylua']
\ }

" Gruvbox
let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_background = 'medium'
let g:gruvbox_material_enable_bold = 1
let gruvbox_material_ui_contrast = 'high'

" Istanbul
let g:istanbul#jsonPath = ['coverage/coverage-final.json', 'coverage/coverage.json']


" Airline
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 'on'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_symbols.branch = '⎇ '
let g:airline_right_sep = ''
let g:airline_left_sep = ''
let g:airline_theme = 'gruvbox_material' " 'base16_gruvbox_dark_soft'

" indentline
let g:indentLine_char = '⦙'
let g:indentLine_enabled = 0

let g:vim_markdown_folding_disabled = 1
let g:gitgutter_max_signs = 1000
let g:ctrlp_custom_ignore = {
\ 'dir':  '\v[\/](\.)?(git|hg|svn|node_modules)$',
\ 'file': '\v\.(exe|so|dll)$',
\ }

" enable 24 bit color support if supported
if (has("termguicolors"))
    if (!(has("nvim")))
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
    set termguicolors
endif

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release --locked
    else
      !cargo build --release --locked --no-default-features --features json-rpc
    endif
  endif
endfunction

autocmd BufNewFile,BufRead Jenkinsfile set syntax=groovy
autocmd BufNewFile,BufRead *.yaml.envsubst set syntax=yaml
autocmd BufNewFile,BufRead *.swagger set syntax=json

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd User Node if &filetype == "javascript" | setlocal expandtab | endif

set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

"esearch git history

" Show the popup with git-show information on CursorMoved is a git revision context is hovered.
let g:GitShow = {ctx -> ctx().rev &&
  \ esearch#preview#shell('git show ' . split(ctx().filename, ':')[0], {
  \   'let': {'&filetype': 'git', '&number': 0},
  \   'row': screenpos(0, ctx().begin, 1).row,
  \   'col': screenpos(0, ctx().begin, col([ctx().begin, '$'])).col,
  \   'width': 47, 'height': 3,
  \ })
  \}
" Debounce the popup updates using 70ms timeout.
autocmd User esearch_win_config
      \  let b:git_show = esearch#async#debounce(g:GitShow, 70)
      \| autocmd CursorMoved <buffer> call b:git_show.apply(b:esearch.ctx)

nnoremap <leader>fh :call esearch#init({'paths': esearch#xargs#git_log()})<cr>

call plug#begin('~/.config/nvim/plugins')
 " Plugins
" Plug 'nvim-tree/nvim-tree.lua'
" Plug 'airblade/vim-gitgutter'
" Plug 'ctrlpvim/ctrlp.vim'
" Plug 'nvim-tree/nvim-web-devicons'
" Plug 'tpope/vim-fugitive'
" Plug 'terryma/vim-multiple-cursors'
" Plug 'vim-airline/vim-airline'
" Plug 'retorillo/istanbul.vim'
" Plug 'preservim/tagbar'
" Plug 'tpope/vim-surround'
" Plug 'tpope/vim-obsession'
" Plug 'tpope/vim-dispatch'
" Plug 'eugen0329/vim-esearch'
" Plug 'mzlogin/vim-markdown-toc'
" Plug 'dense-analysis/ale'
" Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
" Plug 'Yggdroot/indentLine'
" Plug 'vim-airline/vim-airline-themes'
" Plug 'dhruvasagar/vim-table-mode'
" Plug 'tpope/vim-rhubarb'
" Plug 'elzr/vim-json'
" Plug 'liuchengxu/vista.vim'
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'akinsho/toggleterm.nvim', {'tag' : 'v2.*'}
" Plug 'echasnovski/mini.animate', { 'branch': 'stable' }
" Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
"
" " Rust Things
" Plug 'neovim/nvim-lspconfig'
" Plug 'simrat39/rust-tools.nvim'
" Plug 'rust-lang/rust.vim'
"
" " Language Server Protocol things
" Plug 'hrsh7th/nvim-cmp'
" Plug 'hrsh7th/cmp-nvim-lsp'
" Plug 'hrsh7th/cmp-path'
" Plug 'hrsh7th/cmp-buffer'
"
" " Syntax
" Plug 'towolf/vim-helm'
" Plug 'tbastos/vim-lua'
" Plug 'plasticboy/vim-markdown'
" Plug 'moll/vim-node'
" Plug 'chr4/nginx.vim'
" Plug 'pangloss/vim-javascript'
" Plug 'rust-lang/rust.vim'
" Plug 'fatih/vim-go'
" Plug 'cappyzawa/starlark.vim'
" Plug 'mustache/vim-mustache-handlebars'
" Plug 'cespare/vim-toml'
"
" " Themes
"" Plug 'ellisonleao/gruvbox.nvim'
" Plug 'sainnhe/gruvbox-material'
" Plug 'kristijanhusak/vim-hybrid-material'
" Plug 'EdenEast/nightfox.nvim'
" Plug 'projekt0n/github-nvim-theme'
" Plug 'vim-airline/vim-airline-themes'
call plug#end()

lua require('bootstrap')
lua require('config')
