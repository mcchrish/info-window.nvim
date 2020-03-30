let g:infowindow_buffnr = -1

function infowindow#destroy()
  if (bufexists(g:infowindow_buffnr))
    execute 'bdelete ' . g:infowindow_buffnr
    let g:infowindow_buffnr = -1
    unlet g:infowindow_mainwindow
  endif
  if (exists("g:infowindow_timer"))
    call timer_stop(g:infowindow_timer)
    unlet g:infowindow_timer
  endif
endfunction

function infowindow#timer_handler(timer)
  call infowindow#destroy()
endfunction

function s:setup_window(win, buf, opts)
  call nvim_buf_set_name(a:buf, '1_infowindow_1')
  call setwinvar(a:win, '&winhighlight', 'NormalFloat:'..'StatusLine')
  call setwinvar(a:win, '&colorcolumn', '')
  call nvim_win_set_config(a:win, a:opts)
endfunction

function infowindow#create(lines, timeout)
  if (bufexists(g:infowindow_buffnr) && exists("g:infowindow_timer"))
    call timer_stop(g:infowindow_timer)
    unlet g:infowindow_timer
  endif

  let lengths = []
  for lines in a:lines
    call add(lengths, strlen(lines))
  endfor

  let width = min([
        \ max(lengths),
        \ &columns / 2
        \ ])

  if !bufexists(g:infowindow_buffnr)
    let buf = nvim_create_buf(v:false, v:true)
    let g:infowindow_buffnr = buf
  else
    let buf = g:infowindow_buffnr
  endif

  let opts = {
        \ 'relative': 'editor',
        \ 'style': 'minimal',
        \ 'row': 2,
        \ 'col': &columns - (width + 4),
        \ 'width': width,
        \ 'height': len(a:lines)
        \ }

  let last_index = nvim_buf_line_count(buf)
  call nvim_buf_set_lines(buf, 0, last_index, v:true, a:lines)
  if !exists("g:infowindow_mainwindow")
    let g:infowindow_mainwindow = nvim_open_win(buf, v:false, opts)
  endif
  call <SID>setup_window(g:infowindow_mainwindow, buf, opts)

  if a:timeout > 0
    let g:infowindow_timer = timer_start(a:timeout, 'infowindow#timer_handler')
  endif
endfunction

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
        \ ' name:   ' . (strlen(buffilename) > 0 ? buffilename : '[No Name]') . ' ')

  call add(lines,
        \ ' type:   ' . (strlen(&filetype) > 0 ? &filetype : 'unknown') . ' ')

  call add(lines, ' format: ' . &fileformat . ' ')
  call add(lines, ' lines:  ' . line('$') . ' ')

  call infowindow#create(lines, duration)
endfunction

function! infowindow#toggle()
    if g:infowindow_buffnr != -1
        call infowindow#destroy()
    else
        call infowindow#create_default(-1)
    endif
endfunction
