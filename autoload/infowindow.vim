let g:infowindow_buffnr = -1
let g:infowindow_loaded = 1

function infowindow#destroy()
  if (bufexists(g:infowindow_buffnr))
    execute 'bdelete ' . g:infowindow_buffnr
    let g:infowindow_buffnr = -1
  endif
endfunction

function infowindow#timer_handler(timer)
  call infowindow#destroy()
endfunction

function infowindow#create(lines, timeout)
  if (bufexists(g:infowindow_buffnr))
    if exists("g:infowindow_timer")
      call timer_stop(g:infowindow_timer)
    endif

    call infowindow#destroy()
  endif

  let lengths = []
  for lines in a:lines
    call add(lengths, strlen(lines))
  endfor

  let width = min([
        \ max(lengths),
        \ &columns / 2
        \ ])

  let buf = nvim_create_buf(v:false, v:true)
  let g:infowindow_buffnr = buf

  let opts = {
        \ 'relative': 'editor',
        \ 'style': 'minimal',
        \ 'row': 2,
        \ 'col': &columns - (width + 4),
        \ 'width': width,
        \ 'height': len(a:lines)
        \ }
  call nvim_buf_set_name(buf, '1_infowindow_1')
  call nvim_buf_set_lines(buf, 0, 0, v:true, a:lines)
  let win = nvim_open_win(buf, v:false, opts)
  call setwinvar(win, '&winhighlight', 'NormalFloat:'..'StatusLine')
  call setwinvar(win, '&colorcolumn', '')

  if a:timeout > 0
    let g:infowindow_timer = timer_start(a:timeout, 'infowindow#timer_handler')
  endif
endfunction
