if exists('g:loaded_bufpanel')
  finish
endif
let g:loaded_bufpanel = 1

let s:bufnr = -1

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
  for l:b in filter(range(1, bufnr('$')), 'buflisted(v:val) && bufexists(v:val)')
    let l:name = bufname(l:b)
    let l:name = empty(l:name) ? '[No Name]' : fnamemodify(l:name, ':t')
    let l:mod = getbufvar(l:b, '&modified') ? ' [+]' : ''
    let l:cur = (l:b == l:main_bufnr) ? '>' : ' '
    call add(l:lines, printf('%s %3d  %s%s', l:cur, l:b, l:name, l:mod))
  endfor
  call setline(1, empty(l:lines) ? ['  (no buffers)'] : l:lines)
  setlocal nomodifiable
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
