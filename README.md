# nvim-swm

Smart window movement in neovim.

You can move the current cursor position to the nearest window (including
floating windows, taking z-index into account) with `h, j, k, l`.

## Usage

```lua
local swm = require('swm')
vim.keymap.set('n', '<C-w>h', swm.h)
vim.keymap.set('n', '<C-w>j', swm.j)
vim.keymap.set('n', '<C-w>k', swm.k)
vim.keymap.set('n', '<C-w>l', swm.l)
```
