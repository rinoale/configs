" =============================================================================
" General .vimrc — lightweight, multi-language
" Plugin manager: vim-plug (https://github.com/junegunn/vim-plug)
" Install: curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" Then run :PlugInstall
" =============================================================================

set nocompatible

call plug#begin('~/.vim/plugged')

" ---------------------------------------------------------------------------
" Core (loaded on startup — all lightweight)
" ---------------------------------------------------------------------------
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'itchyny/lightline.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'junegunn/vim-easy-align'

" ---------------------------------------------------------------------------
" Fuzzy finder (loaded on command)
" ---------------------------------------------------------------------------
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim',       { 'on': ['Files', 'Buffers', 'Rg', 'GFiles'] }

" ---------------------------------------------------------------------------
" File tree (loaded on command)
" ---------------------------------------------------------------------------
Plug 'scrooloose/nerdtree',    { 'on': 'NERDTreeToggle' }

" ---------------------------------------------------------------------------
" Ruby (loaded only for ruby files)
" ---------------------------------------------------------------------------
Plug 'vim-ruby/vim-ruby',      { 'for': 'ruby' }

" ---------------------------------------------------------------------------
" Python (loaded only for python files)
" ---------------------------------------------------------------------------
Plug 'vim-python/python-syntax',       { 'for': 'python' }
Plug 'Vimjas/vim-python-pep8-indent',  { 'for': 'python' }

" ---------------------------------------------------------------------------
" JavaScript / TypeScript (loaded only for js/ts files)
" ---------------------------------------------------------------------------
Plug 'pangloss/vim-javascript',        { 'for': ['javascript', 'javascriptreact'] }
Plug 'leafgarland/typescript-vim',     { 'for': ['typescript', 'typescriptreact'] }
Plug 'MaxMEllon/vim-jsx-pretty',       { 'for': ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'] }

" ---------------------------------------------------------------------------
" C# (loaded only for cs files)
" ---------------------------------------------------------------------------
Plug 'oranget/vim-csharp',         { 'for': 'cs' }

call plug#end()

filetype plugin indent on
syntax on

" Enhanced % matching (if/end, do/end, HTML tags, etc.)
if !exists('g:loaded_matchit')
  source $VIMRUNTIME/macros/matchit.vim
endif

" =============================================================================
" General settings
" =============================================================================
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,mac,dos
set t_Co=256
colorscheme jellybeans

set number
set nowrap
set incsearch
set hlsearch
set ignorecase
set smartcase
set backspace=start,indent,eol
set mouse=a
set laststatus=2
set noshowmode
" Fast ESC in terminal mode (fzf, etc). Does not affect key mappings.
set ttimeoutlen=10

" Indent
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent

" Keep visual selection after indent
vnoremap < <gv
vnoremap > >gv

" Clear search highlight
nmap <Esc><Esc> :nohlsearch<CR>

" Backup/swap
set backup
set swapfile
set backupdir=~/.vim/backup
set directory=~/.vim/swap

" Folding
set foldmethod=syntax
set foldlevel=100

" =============================================================================
" Plugin settings
" =============================================================================

" --- lightline ---
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left':  [['mode', 'paste'], ['readonly', 'filename', 'modified']],
      \   'right': [['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype']]
      \ }
      \ }

" --- fzf ---
nmap <silent> <C-p> :Files<CR>
nmap <silent> ,b    :Buffers<CR>
nmap <silent> ,rg   :Rg<CR>

" --- NERDTree ---
let g:NERDTreeMinimalUI = 1
map <C-e> :NERDTreeToggle<CR>

" --- Easy Align ---
" Visual mode: select lines, press Enter, then alignment char (= : | ,)
vmap <Enter> <Plug>(EasyAlign)
" Normal mode: ga + motion + alignment char
nmap ga <Plug>(EasyAlign)

" --- Python syntax ---
let g:python_highlight_all = 1

" =============================================================================
" Key mappings
" =============================================================================

" Buffer/Tab navigation (,+ arrow keys)
nmap <silent> ,<Up>    :bnext<CR>
nmap <silent> ,<Down>  :bprevious<CR>
nmap <silent> ,<Right> :tabnext<CR>
nmap <silent> ,<Left>  :tabprevious<CR>
nmap <silent> bd :bdelete<CR>

" Zoom: open current buffer fullscreen, close to return
nmap <silent> ,z :tab split<CR>
nmap <silent> ,Z :tabclose<CR>

" Quick vimrc edit/reload
noremap <Space>. :<C-u>edit $MYVIMRC<CR>
noremap <Space>s. :<C-u>source $MYVIMRC<CR>

" =============================================================================
" Cheatsheet — :Cheat to open
" =============================================================================
command! Cheat call s:ShowCheat()
function! s:ShowCheat()
  new
  setlocal buftype=nofile bufhidden=wipe noswapfile nowrap
  file [Cheatsheet]
  call setline(1, [
    \ '=== Cheatsheet ===',
    \ '',
    \ '--- Commentary ---',
    \ '  gcc        toggle comment (line)',
    \ '  gc         toggle comment (visual)',
    \ '  gcap       comment paragraph',
    \ '',
    \ '--- fzf ---',
    \ '  Ctrl-p     find files',
    \ '  ,b         list buffers',
    \ '  ,rg        search text (ripgrep)',
    \ '',
    \ '--- Easy Align ---',
    \ '  Enter      align selection (visual mode, then =/:.|,)',
    \ '  ga         align with motion (e.g. gaip=)',
    \ '',
    \ '--- NERDTree ---',
    \ '  Ctrl-e     toggle file tree',
    \ '  Enter      open in current window',
    \ '  s          open in vertical split',
    \ '  i          open in horizontal split',
    \ '  t          open in new tab',
    \ '',
    \ '--- Buffer/Tab ---',
    \ '  ,Up        next buffer',
    \ '  ,Down      previous buffer',
    \ '  ,Right     next tab',
    \ '  ,Left      previous tab',
    \ '  bd         delete buffer',
    \ '',
    \ '--- Zoom ---',
    \ '  ,z         zoom current window (fullscreen)',
    \ '  ,Z         close zoom (back to splits)',
    \ '',
    \ '--- Misc ---',
    \ '  Esc Esc    clear search highlight',
    \ '  Space .    edit vimrc',
    \ '  Space s.   reload vimrc',
    \ '  :Cheat     this cheatsheet',
    \ ])
endfunction
