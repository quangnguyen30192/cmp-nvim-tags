# cmp-nvim-tags

tags completion source for [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

```lua
-- Installation
use { 
  'hrsh7th/nvim-cmp',
  requires = {
    {
      'quangnguyen30192/cmp-nvim-tags',
      -- if you want the sources is available for some file types
      ft = {
        'kotlin',
        'java'
      }
    }
  },
  config = function ()
    require'cmp'.setup {
    sources = {
      { name = 'tags' },
      -- more sources
    }
  }
  end
}

```

# Troubleshooting

If you are using `cmp-nvim-lsp` with `cmp-nvim-tags`, you may face a weird error
`method workspace/symbol is not supported by any of the servers registered for the current buffer`.

This is because neovim will register `tagfunc` as `vim.lsp.tagfunc` when lsp is attached, and there's no attached lsps
supports `workspace/symbol` method. To prevent this behavior, add the following code in your config file:

```lua
on_attach = function(bufnr, client)
    vim.bo.tagfunc = nil
end

-- sqls is an example lsp that does not support workspace/symbol
-- change sqls to the lsp where the error happens
require('lspconfig').sqls.setup {
    on_attach = on_attach
}
```

# Credit
[Compe source for tags](https://github.com/hrsh7th/nvim-compe/blob/master/lua/compe_tags/init.lua)
