return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    dependencies = {
      {
        'echasnovski/mini.icons',
        event = 'VeryLazy',
        opts = function(_, opts)
          if vim.g.icons_enabled == false then
            opts.style = 'ascii'
          end
          return opts
        end,
        lazy = true,
        specs = {
          { 'nvim-tree/nvim-web-devicons', enabled = false, optional = true },
        },
        init = function()
          package.preload['nvim-web-devicons'] = function()
            require('mini.icons').mock_nvim_web_devicons()
            return package.loaded['nvim-web-devicons']
          end
        end,
      },
    },
  },
  {
    'echasnovski/mini.icons',
    opts = {
      style = 'glyph',
      file = {
        README = { glyph = '󰆈', hl = 'MiniIconsYellow' },
        ['README.md'] = { glyph = '󰆈', hl = 'MiniIconsYellow' },
      },
      filetype = {
        bash = { glyph = '󱆃', hl = 'MiniIconsGreen' },
        sh = { glyph = '󱆃', hl = 'MiniIconsGrey' },
        toml = { glyph = '󱄽', hl = 'MiniIconsOrange' },
      },
    },
  },
  {
    'echasnovski/mini.surround',
    opts = {
      mappings = {
        add = 'sa', -- Add surrounding in Normal and Visual modes
        delete = 'sd', -- Delete surrounding
        find = 'sf', -- Find surrounding (to the right)
        find_left = 'sF', -- Find surrounding (to the left)
        highlight = 'sh', -- Highlight surrounding
        replace = 'sr', -- Replace surrounding
        update_n_lines = 'sn', -- Update `n_lines`

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      },
    },
  },
  {
    'echasnovski/mini.ai',
    keys = { 'i', 'a', ']', '[', 'c', 'd', 'y' },
    opts = { mappings = {
      goto_left = '[',
      goto_right = ']',
    } },
    specs = {
      {
        'catppuccin',
        optional = true,
        opts = { integrations = { mini = true } },
      },
    },
  },
}
