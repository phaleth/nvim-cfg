--[[
  Dependencies:

  Completion:
  https://github.com/hrsh7th/nvim-cmp
  https://github.com/hrsh7th/cmp-buffer
  https://github.com/hrsh7th/cmp-path
  https://github.com/saadparwaiz1/cmp_luasnip

  Snippets:
  https://github.com/L3MON4D3/LuaSnip
  https://github.com/rafamadriz/friendly-snippets
]]

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

local cmp = require('cmp')
local luasnip = require('luasnip')

local snippets = require('luasnip.loaders.from_vscode')

luasnip.config.set_config({region_check_events = 'InsertEnter'})

snippets.lazy_load()
snippets.load({include = {vim.bo.filetype}})

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

cmp.setup({
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  sources = {
    {name = 'path'},
    {name = 'buffer'},
    {name = 'luasnip'}
  },
  window = {
    documentation = {
      maxheight = 15,
      maxwidth = 50,
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    }
  },
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({select = true}),
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-d>'] = cmp.mapping.scroll_docs(5),
    ['<C-u>'] = cmp.mapping.scroll_docs(-5),

    ['<C-e>'] = function()
      if cmp.visible() then
        cmp.close()
      else
        cmp.complete()
      end
    end,

    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({select = true})
      elseif luasnip.jumpable(1) then
        luasnip.jump(1)
      elseif check_back_space() then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),

    ['<S-Tab>'] = cmp.mapping(function() luasnip.jump(-1) end, {'i', 's'}),
  }
})

