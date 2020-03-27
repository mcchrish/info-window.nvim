let g:_infobuf_1 = -1

function infowindow#toggle()
  if (bufexists(g:_infobuf_1))
    execute 'bdelete ' g:_infobuf_1
    let g:_infobuf_1 = -1
    return
  endif
  let cbuf = bufnr('')
  let buffilename = bufname(cbuf)
  let filename = ' name:   ' . (strlen(buffilename) > 0 ? buffilename : '[No Name]') . ' '
  let filetype = ' type:   ' . (strlen(&filetype) > 0 ? &filetype : 'unknown') . ' '
  let fileformat = ' format: ' . &fileformat . ' '
  let numlines = ' lines:  ' . line('$') . ' '
  let width = min([
        \ max([strlen(filename), strlen(filetype)]), 
        \ &columns / 2
        \ ])
  let buf = nvim_create_buf(v:false, v:true)
  let g:_infobuf_1 = buf
  let opts = { 
        \ 'relative': 'editor',
        \ 'style': 'minimal',
        \ 'row': 2,
        \ 'col': &columns - (width + 4),
        \ 'width': width,
        \ 'height': 5
        \ }
  call nvim_buf_set_name(buf, '1_infowindow_1')
  call nvim_buf_set_lines(buf, 0, 0, v:true, [filename, filetype, fileformat, numlines])
  let win = nvim_open_win(buf, v:false, opts)
  call setwinvar(win, '&winhighlight', 'NormalFloat:'..'StatusLine')
  call setwinvar(win, '&colorcolumn', '')
endfunction
