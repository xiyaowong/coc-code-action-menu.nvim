# coc-code-action-menu.nvim

![demo](https://user-images.githubusercontent.com/47070852/158181148-9a66f624-776a-44fc-914e-e50455591c89.gif)

**Read the readme of [nvim-code-action-menu](https://github.com/weilbith/nvim-code-action-menu)**

## Usage

1. Install `weilbith/nvim-code-action-menu`

2. Add `require 'coc-code-action-menu'` to `nvim-code-action-menu`'s
   configuration

Example using packer.nvim

```lua
use {
  'weilbith/nvim-code-action-menu',
  after = 'coc.nvim',
  requires = 'xiyaowong/coc-code-action-menu.nvim',
  config = function()
    require 'coc-code-action-menu'
  end,
}
```

That's all.
