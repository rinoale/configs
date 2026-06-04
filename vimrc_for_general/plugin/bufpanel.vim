if exists('g:loaded_bufpanel')
  finish
endif
let g:loaded_bufpanel = 1

let s:bufnr = -1
let s:project_root_cache = {}

function! s:FindMainWin()
  for l:w in range(1, winnr('$'))
    if getwinvar(l:w, '&buftype') ==# '' && getwinvar(l:w, '&filetype') !=# 'nerdtree'
      return l:w
    endif
  endfor
  return 1
endfunction

function! s:Toggle()
  if s:bufnr != -1 && bufexists(s:bufnr)
    let l:win = bufwinnr(s:bufnr)
    if l:win != -1
      execute l:win . 'wincmd w'
      close
      let s:bufnr = -1
      return
    endif
  endif
  botright new
  resize 8
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap cursorline winfixheight
  file [Buffers]
  let s:bufnr = bufnr('%')
  call s:Refresh()
  nnoremap <buffer> <CR>          :call <SID>Select()<CR>
  nnoremap <buffer> <F2>          :call <SID>Toggle()<CR>
  nnoremap <buffer> q             :call <SID>Toggle()<CR>
  nnoremap <buffer> d             :call <SID>Delete()<CR>
  nnoremap <buffer> r             :call <SID>Refresh()<CR>
  nnoremap <buffer> <2-LeftMouse> :call <SID>Select()<CR>
endfunction

function! s:Refresh()
  setlocal modifiable
  silent %delete _
  let l:main_bufnr = winbufnr(s:FindMainWin())
  let l:lines = []
  for l:b in filter(range(1, bufnr('$')), 'buflisted(v:val) && bufexists(v:val) && getbufvar(v:val, "&buftype") !=# "terminal"')
    let l:name = s:BufferDisplayName(l:b)
    let l:mod = getbufvar(l:b, '&modified') ? ' [+]' : ''
    let l:cur = (l:b == l:main_bufnr) ? '>' : ' '
    call add(l:lines, printf('%s %3d  %s%s', l:cur, l:b, l:name, l:mod))
  endfor
  call setline(1, empty(l:lines) ? ['  (no buffers)'] : l:lines)
  setlocal nomodifiable
endfunction

function! s:BufferDisplayName(bufnr)
  let l:name = bufname(a:bufnr)

  if empty(l:name)
    return '[No Name]'
  endif

  let l:path = fnamemodify(l:name, ':p')
  let l:root = s:ProjectRoot(l:path)

  return s:RelativePath(l:path, l:root)
endfunction

function! s:ProjectRoot(path)
  let l:dir = isdirectory(a:path) ? a:path : fnamemodify(a:path, ':h')
  let l:key = fnamemodify(l:dir, ':p')

  if has_key(s:project_root_cache, l:key)
    return s:project_root_cache[l:key]
  endif

  if executable('git')
    let l:roots = systemlist('git -C ' . shellescape(l:dir) . ' rev-parse --show-toplevel')

    if v:shell_error == 0 && !empty(l:roots)
      let s:project_root_cache[l:key] = fnamemodify(l:roots[0], ':p')
      return s:project_root_cache[l:key]
    endif
  endif

  let s:project_root_cache[l:key] = fnamemodify(getcwd(), ':p')
  return s:project_root_cache[l:key]
endfunction

function! s:RelativePath(path, root)
  let l:path = fnamemodify(a:path, ':p')
  let l:root = fnamemodify(a:root, ':p')

  if stridx(l:path, l:root) == 0
    return strpart(l:path, strlen(l:root))
  endif

  let l:cwd = fnamemodify(getcwd(), ':p')

  if stridx(l:path, l:cwd) == 0
    return strpart(l:path, strlen(l:cwd))
  endif

  return l:path
endfunction

function! s:Select()
  let l:bnr = str2nr(matchstr(getline('.'), '\d\+\ze  '))
  if l:bnr > 0 && bufexists(l:bnr)
    let l:curpos = line('.')
    let l:main = s:FindMainWin()
    execute l:main . 'wincmd w'
    execute 'buffer ' . l:bnr
    let l:panel = bufwinnr(s:bufnr)
    if l:panel != -1
      execute l:panel . 'wincmd w'
      call s:Refresh()
      execute l:curpos
    endif
  endif
endfunction

function! s:Delete()
  let l:bnr = str2nr(matchstr(getline('.'), '\d\+\ze  '))
  if l:bnr > 0 && bufexists(l:bnr)
    let l:curpos = line('.')
    execute 'bdelete ' . l:bnr
    call s:Refresh()
    execute min([l:curpos, line('$')])
  endif
endfunction

nnoremap <silent> <F2> :call <SID>Toggle()<CR>
