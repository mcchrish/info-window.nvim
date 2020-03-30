if exists('g:infowindow_loaded')
  finish
endif
let g:infowindow_loaded = 1

command! InfoWindowShow call infowindow#create_default(2500)
command! InfoWindowClose call infowindow#destroy()
command! InfoWindowToggle call infowindow#toggle()
