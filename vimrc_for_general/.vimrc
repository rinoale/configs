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
" Rust (loaded only for rust files)
" ---------------------------------------------------------------------------
Plug 'rust-lang/rust.vim',         { 'for': 'rust' }
Plug 'neoclide/coc.nvim',          { 'for': 'rust', 'branch': 'release'}

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
nmap <silent> <C-l> :nohlsearch<CR>

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
nmap <silent> <C-f> :Rg<CR>

" --- NERDTree ---
let g:NERDTreeMinimalUI = 1
map <C-e> :NERDTreeToggle<CR>

" --- Easy Align ---
" Visual mode: select lines, press Enter, then alignment char (= : | ,)
vmap <Enter> <Plug>(EasyAlign)
" Normal mode: ga + motion + alignment char
nmap ga <Plug>(EasyAlign)

" --- coc.nvim ---
let g:coc_global_extensions = ['coc-rust-analyzer']
if executable('wslview')
  let g:coc_open_url_command = 'wslview'
endif

augroup rust_coc_mappings
  autocmd!
  " Hover docs for the symbol under cursor.
  autocmd FileType rust nnoremap <silent><buffer> K :call CocActionAsync('doHover')<CR>
  " Open external rustdoc/docs.rs page for the symbol under cursor.
  autocmd FileType rust nnoremap <silent><buffer> ,d :CocCommand rust-analyzer.openDocs<CR>
augroup END

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
command! -nargs=0 Tabr :.+1,$tabdo :q

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
  setlocal buftype=nofile bufhidden=wipe noswapfile nowrap filetype=markdown
  syntax match CheatCode /`[^`]\+`/
  highlight CheatCode ctermfg=cyan guifg=#56b6c2
  file [Cheatsheet]
  call setline(1, [
    \ '# Cheatsheet',
    \ '',
    \ '## Commentary',
    \ '- `gcc` — toggle comment (line)',
    \ '- `gc` — toggle comment (visual)',
    \ '- `gcap` — comment paragraph',
    \ '',
    \ '## fzf',
    \ '- `Ctrl-p` — find files',
    \ '- `,b` — list buffers',
    \ '- `,rg` / `C-f` — search text (ripgrep)',
    \ '',
    \ '## Easy Align',
    \ '- `Enter` — align selection (visual mode, then `=` `/` `:` `.` `|` `,`)',
    \ '- `ga` — align with motion (e.g. `gaip=`)',
    \ '',
    \ '## Substitute',
    \ '- `:%s/old/new/g` — replace every `old` in file',
    \ '- `:s/old/new/g` — replace every `old` on current line',
    \ '- `:%s/value: [^,]*,/value: '''',/g` — replace value only up to comma',
    \ '- `:%s/\(value:\s*\)[^,]*,/\1'''',/g` — preserve spacing after `value:`',
    \ '- `.\{-}` — Vim non-greedy match, e.g. `:%s/value: .\{-},/value: '''',/g`',
    \ '',
    \ '## Selection',
    \ '- `{` / `}` — move to previous/next paragraph',
    \ '- `v{` — select to start of paragraph (characterwise)',
    \ '- `v}` — select to end of paragraph (characterwise)',
    \ '- `V{` — select to start of paragraph (linewise)',
    \ '- `V}` — select to end of paragraph (linewise)',
    \ '- `vip` — select inner paragraph',
    \ '- `vap` — select paragraph including surrounding blank line',
    \ '- `b` / `B` — move to start of word / whitespace-separated WORD',
    \ '- `vb` / `vB` — select to start of word / whitespace-separated WORD',
    \ '- `e` / `E` — move to end of word / whitespace-separated WORD',
    \ '- `vE` — select to end of whitespace-separated WORD',
    \ '- `viW` — select inner whitespace-separated WORD',
    \ '- `vaW` — select WORD plus surrounding space',
    \ '',
    \ '## NERDTree',
    \ '- `Ctrl-e` — toggle file tree',
    \ '- `Enter` — open in current window',
    \ '- `s` — open in vertical split',
    \ '- `i` — open in horizontal split',
    \ '- `t` — open in new tab',
    \ '',
    \ '## Buffer Panel',
    \ '- `F2` — toggle buffer panel (bottom)',
    \ '- `Enter` — open selected buffer in main window',
    \ '- `d` — delete selected buffer (in panel)',
    \ '- `r` — refresh list (in panel)',
    \ '- `q` / `F2` — close panel',
    \ '- `dbl-click` — open selected buffer (mouse)',
    \ '',
    \ '## Buffer/Tab',
    \ '- `,Up` — next buffer',
    \ '- `,Down` — previous buffer',
    \ '- `,Right` — next tab',
    \ '- `,Left` — previous tab',
    \ '- `:tabm -1` / `:tabm +1` — move current tab left/right',
    \ '- `:tabm 0` — move current tab to first position',
    \ '- `:tabm` — move current tab to last position',
    \ '- `:tabm {N}` — move current tab after tab number N',
    \ '- `:Tabr` — close tabs to the right',
    \ '- `bd` — delete buffer',
    \ '',
    \ '## Window Move',
    \ '- `Ctrl-W H` — move window to far left (vertical)',
    \ '- `Ctrl-W J` — move window to bottom (horizontal)',
    \ '- `Ctrl-W K` — move window to top (horizontal)',
    \ '- `Ctrl-W L` — move window to far right (vertical)',
    \ '',
    \ '## Folding',
    \ '- `zc` — close fold under cursor',
    \ '- `zo` — open fold under cursor',
    \ '- `za` — toggle fold under cursor',
    \ '- `zC` — close folds recursively under cursor',
    \ '- `zO` — open folds recursively under cursor',
    \ '- `zM` — close all folds',
    \ '- `zR` — open all folds',
    \ '',
    \ '## Zoom',
    \ '- `,z` — zoom current window (fullscreen)',
    \ '- `,Z` — close zoom (back to splits)',
    \ '',
    \ '## coc.nvim (commands)',
    \ '- `:CocInstall {ext}` — install extension (e.g. coc-rust-analyzer)',
    \ '- `:CocUninstall {ext}` — uninstall extension',
    \ '- `:CocList extensions` — list installed extensions',
    \ '- `:CocUpdate` — update all extensions',
    \ '- `:CocConfig` — open coc-settings.json',
    \ '- `:CocRestart` — restart coc server',
    \ '- `:CocInfo` — show coc info/log',
    \ '- `:CocDiagnostics` — list all diagnostics',
    \ '- `:CocList commands` — list available commands',
    \ '- `:CocList outline` — symbol outline of current file',
    \ '- `:CocList symbols` — workspace symbols',
    \ '- `:CocAction` — pick a code action',
    \ '- `:CocFix` — apply quickfix for current line',
    \ '- `:CocCommand` — run a coc command',
    \ '- `K` — show hover docs for symbol under cursor in Rust buffers',
    \ '- `,d` — open Rust docs for symbol under cursor in Rust buffers',
    \ '',
    \ '## coc.nvim (rust-analyzer)',
    \ '- `:CocCommand rust-analyzer.run` — run file',
    \ '- `:CocCommand rust-analyzer.runFlycheck` — run flycheck',
    \ '- `:CocCommand rust-analyzer.expandMacro` — expand macro',
    \ '- `:CocCommand rust-analyzer.joinLines` — join lines',
    \ '- `:CocCommand rust-analyzer.parentModule` — go to parent module',
    \ '- `:CocCommand rust-analyzer.openDocs` — open docs.rs for symbol',
    \ '- `:CocCommand rust-analyzer.reload` — reload workspace',
    \ '- `:CocCommand rust-analyzer.syntaxTree` — show syntax tree',
    \ '- `:CocCommand rust-analyzer.matchingBrace` — jump to matching brace',
    \ '- `:CocCommand rust-analyzer.upgrade` — upgrade rust-analyzer',
    \ '',
    \ '## Terminal',
    \ '- `:below term` — open terminal (horizontal split below)',
    \ '- `:vert rightb term` — open terminal (vertical split right)',
    \ '- `:vert lefta term` — open terminal (vertical split left)',
    \ '- `:tab term` — open terminal (new tab)',
    \ '- `Ctrl-W N` — terminal → normal mode (scroll/yank)',
    \ '- `i` / `a` — normal → terminal mode (type commands)',
    \ '',
    \ '## Misc',
    \ '- `Ctrl-L` — clear search highlight',
    \ '- `Space .` — edit vimrc',
    \ '- `Space s.` — reload vimrc',
    \ '- `:Cheat` — this cheatsheet',
    \ ])
endfunction
