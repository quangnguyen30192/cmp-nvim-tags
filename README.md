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
      {
        name = 'tags',
        option = {
          -- this is the default options, change them if you want.
          -- Delayed time after user input, in milliseconds.
          complete_defer = 100,
          -- Max items when searching `taglist`.
          max_items = 10,
          -- The number of characters that need to be typed to trigger
          -- auto-completion.
          keyword_length = 3,
          -- Use exact word match when searching `taglist`, for better searching
          -- performance.
          exact_match = false,
          -- Prioritize searching result for current buffer.
          current_buffer_only = false,
        },
      },
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

Besides, `vim.lsp.tagfunc` may also have performance issue since it is calling
the lsp `workspace/symbol` method firstly and fallback to the default when the
former one returns no result.

If you feel that use `cmp-nvim-tags` is laggy, then you can consider to set `tagfunc` to nil.

```lua
on_attach = function(bufnr, client)
    vim.bo.tagfunc = nil
end

-- sqls is an example lsp that does not support workspace/symbol
-- change sqls to the lsp where the error happens
require('lspconfig').sqls.setup {
    on_attach = on_attach
}


-- Occasionally, due to potential execution order issues: you might set tagfunc
-- to nil, but the LSP could re-register it later. So that you may need a
-- "brute force way" to ask neovim will always fallback to the default tag
-- search method immediately.
TAGFUNC_ALWAYS_EMPTY = function()
    return {}
end

-- if tagfunc is already registered, nvim lsp will not try to set tagfunc as vim.lsp.tagfunc.
vim.o.tagfunc = "v:lua.TAGFUNC_ALWAYS_EMPTY"
```

# Credit
[Compe source for tags](https://github.com/hrsh7th/nvim-compe/blob/master/lua/compe_tags/init.lua)
