if exists('g:infowindow_loaded')
  finish
endif
let g:infowindow_loaded = 1

if !exists('g:infowindow_create_default_commands')
  let g:infowindow_create_default_commands = 1
endif

if g:infowindow_create_default_commands == 1
  command! InfoWindowShow call infowindow#create()
  command! InfoWindowClose call infowindow#destroy()
  command! InfoWindowToggle call infowindow#toggle()
endif
