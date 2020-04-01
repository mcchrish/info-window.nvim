if !exists('g:infowindow_timeout')
  let g:infowindow_timeout = 2500
endif

let s:bufnr = -1
let s:timer = v:null
let s:win_id = v:null

highlight link InfoWindowFloat StatusLine

function! s:timer_handler(timer)
  call infowindow#destroy()
endfunction

function! s:add_padding(text, padding)
  let l:count = 0
  let l:padded_text = a:text . ': '
  while l:count < a:padding
    let l:padded_text = l:padded_text . ' '
    let l:count = l:count + 1
  endwhile
  return l:padded_text
endfunction

function! s:setup_window(win, buf, opts)
  call nvim_buf_set_name(a:buf, '1_infowindow_1')
  call setwinvar(a:win, '&winhighlight', 'NormalFloat:'..'InfoWindowFloat')
  call setwinvar(a:win, '&colorcolumn', '')
  call nvim_win_set_config(a:win, a:opts)
endfunction

function! infowindow#get_default_lines() abort
  let l:lines = []
  let buffilename = expand("%:t")
  call add(l:lines, ['name', strlen(l:buffilename) > 0 ? l:buffilename : '[No Name]'])
  call add(l:lines, ['type', strlen(&filetype) > 0 ? &filetype : 'unknown'])
  call add(l:lines, ['format',&fileformat ])
  call add(l:lines, ['lines', line('$') ])
  return l:lines
endfunction

function! infowindow#create(...) abort
  let l:lines = []
  let l:opts = get(a:, 1, {})
  let l:Custom_content_func = get(a:, 2, v:null)
  if type(l:Custom_content_func) == v:t_func
    let l:lines = call(l:Custom_content_func, [infowindow#get_default_lines()])
  else
    let l:lines = infowindow#get_default_lines()
  endif

  let l:timeout = get(l:opts, 'timeout', g:infowindow_timeout)

  if (bufexists(s:bufnr) && s:timer != v:null)
    call timer_stop(s:timer)
    let s:timer = v:null
  endif

  let l:max_label_len = 0
  for l:line in l:lines
    if type(l:line) == v:t_list && strlen(l:line[0]) > l:max_label_len
      let l:max_label_len = strlen(l:line[0])
    endif
  endfor

  let l:formatted_lines = []
  for l:line in l:lines
    if type(l:line) == v:t_list 
      call add(l:formatted_lines, ' ' . <SID>add_padding(l:line[0], l:max_label_len - strlen(l:line[0])) . l:line[1] . ' ')
    else
      call add(l:formatted_lines, ' ' . l:line . ' ')
    endif
  endfor

  let l:lengths = []
  for l:line in l:formatted_lines
    call add(l:lengths, strlen(l:line))
  endfor

  let l:width = min([
        \ max(l:lengths),
        \ &columns / 2
        \ ])

  if !bufexists(s:bufnr)
    let l:buf = nvim_create_buf(v:false, v:true)
    let s:bufnr = l:buf
  else
    let l:buf = s:bufnr
  endif

  let l:win_opts = {
        \ 'relative': 'editor',
        \ 'style': 'minimal',
        \ 'row': 2,
        \ 'col': &columns - (l:width + 4),
        \ 'width': l:width,
        \ 'height': len(l:lines)
        \ }

  let l:last_idx = nvim_buf_line_count(buf)
  call nvim_buf_set_lines(l:buf, 0, l:last_idx, v:true, l:formatted_lines)
  if s:win_id == v:null
    let s:win_id = nvim_open_win(l:buf, v:false, l:win_opts)
  endif
  call <SID>setup_window(s:win_id, l:buf, l:win_opts)

  if l:timeout > 0
    let s:timer = timer_start(l:timeout, function('s:timer_handler'))
  endif
endfunction

function! infowindow#destroy() abort
  if s:win_id != v:null
    call nvim_win_close(s:win_id, v:false)
    let s:win_id = v:null
  endif
  if (bufexists(s:bufnr))
    execute 'bwipeout ' . s:bufnr
    let s:bufnr = -1
  endif
  if s:timer != v:null
    call timer_stop(s:timer)
    let s:timer = v:null
  endif
endfunction

function! infowindow#toggle(...) abort
    if s:bufnr != -1
        call infowindow#destroy()
    else
      let l:opts = get(a:, 1, {})
      let l:Custom_content_func = get(a:, 2, v:null)
        call infowindow#create(l:opts, l:Custom_content_func)
    endif
endfunction
