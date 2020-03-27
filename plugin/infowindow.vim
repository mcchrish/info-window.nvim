function! infowindow#create_default()
  let lines = get(g:, 'infowindow_lines', [])
  let timeout = get(g:, 'infowindow_timeout', 2500)
  if len(lines) != 0
    call infowindow#create(lines, timeout)
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

  call infowindow#create(lines, timeout)
endfunction

command! InfoWindowShow call infowindow#create_default()
command! InfoWindowClose call infowindow#destroy()
