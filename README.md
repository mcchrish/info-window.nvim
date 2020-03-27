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
- [ ] able to add custom text
- [ ] customize colors/highlighting
