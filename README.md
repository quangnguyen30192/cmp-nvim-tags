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
# Credit
[Compe source for tags](https://github.com/hrsh7th/nvim-compe/blob/master/lua/compe_tags/init.lua)
