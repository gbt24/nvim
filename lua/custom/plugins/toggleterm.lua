---Persist and toggle multiple terminals during an editing session

local custom = require 'custom.utils'

---@type LazyPluginSpec
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<c-\>]],
    shell = vim.uv.os_uname().sysname == 'Windows_NT' and 'pwsh' or 'zsh',
    float_opts = {
      border = custom.border,
    },
    winbar = {
      enabled = true,
    },
  },
  keys = function()
    local float_opts = {
      border = custom.border,
    }
    local on_create = function(t)
      local bufnr = t.bufnr
      vim.keymap.set('t', '<Esc>', '<Nop>', { buffer = bufnr })
    end

    local lf = require('toggleterm.terminal').Terminal:new {
      cmd = 'lf',
      hidden = true,
      direction = 'float',
      float_opts = float_opts,
      on_create = on_create,
    }

    return {
      { '<C-\\>' },
      { '<leader>tt', '<Cmd>ToggleTermToggleAll<CR>', mode = 'n', desc = 'All Terminal' },

      -- External programs
    }
  end,
}
