# info-window.nvim

Open a small floating window containing a few details about the current buffer.
Useful when you just want to quickly see details about a file like `<c-g>`.

Simple custom mapping:

```vim
nnoremap <silent> <c-g> :InfoWindowToggle<cr>
```

## Install

Any package manager will do.

```vim
Plug 'mcchrish/info-window.nvim'
```

## Configuration

By default, the following information is displayed in the information window:

- Buffer name
- Buffer type
- Buffer format
- Number of lines

But you can use `g:infowindow_lines` to control the lines that you display in
the information window.

```vim
let g:infowindow_lines = [
    \ " Line: " . line('.'),
    \ " Column: " . col('.'),
    \ " File: " . &filetype . ' - ' . &fileencoding . ' [' . &fileformat . ']',
    ]
```

By default, the information window will disappear after 2.5 seconds. You can
change it using `g:infowindow_timeout`. If the timeout is `0`, then it will
not be closed automatically.

### Highlighting

You can change the highlighting of the floating window by setting
`InfoWindowFloat`.

Default:

```vim
highlight link InfoWindowFloat StatusLine
```

<p align="center">
  <img width="934" src="https://user-images.githubusercontent.com/7200153/77721438-dce02780-7025-11ea-9f70-0540eba1fae3.png" alt="sample screenshot">
  <small>colorscheme <a href="https://github.com/pgdouyon/vim-yin-yang">yin</a></small>
</p>


## Contributing

PR is welcome! This plugin is basic as it is. It does not even support vim
popup. So if anyone wants to add some improvements, go ahead.

### Wishlist

- [ ] vim popup
- [ ] borders
- [ ] more file details and customization
- [ ] able to add custom text
- [ ] customize colors/highlighting
- [ ] reactive: display info about whatever current buffer
- [ ] close window on cursor move
