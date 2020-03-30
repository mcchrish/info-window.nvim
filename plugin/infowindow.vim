function! infowindow#create_default(timeout)
  let lines = get(g:, 'infowindow_lines', [])
  let duration = get(g:, 'infowindow_timeout', a:timeout)
  if len(lines) != 0
    call infowindow#create(lines, duration)
    return
  endif

  let cbuf = bufnr('')
  let buffilename = expand("%:t")
  call add(lines,
        \ ' name: ' . (strlen(buffilename) > 0 ? buffilename
        \                                      : '[No Name]') . ' ')

  call add(lines,
        \ ' type: ' . (strlen(&filetype) > 0 ? &filetype : 'unknown') . ' ')

  call add(lines, ' format: ' . &fileformat . ' ')
  call add(lines, ' lines: ' . line('$') . ' ')

  call infowindow#create(lines, duration)
endfunction

function! infowindow#toggle()
    if g:infowindow_buffnr != -1
        call infowindow#destroy()
    else
        call infowindow#create_default(-1)
    endif
endfunction

command! InfoWindowShow call infowindow#create_default(2500)
command! InfoWindowClose call infowindow#destroy()

command! InfoWindowToggle call infowindow#toggle()
