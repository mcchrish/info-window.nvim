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

But you can use `infowindow#create` or `infowindow#toggle` then pass a custom
funcref/lambda that returns a list of lines.

```vim
" Extend the default content and add current git branch
" Lines can be plain string or a list where the first element is the label and
" the second element is the content. It will be then automatically formatted.
command! InfoWindowCustomToggle call infowindow#toggle({} , { default_lines -> extend(default_lines, [['branch', fugitive#head()]]) })
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
- [x] able to add custom text
- [x] customize colors/highlighting
- [ ] reactive: display info about whatever current buffer
- [ ] close window on cursor move
