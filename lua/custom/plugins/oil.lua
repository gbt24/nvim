return {
  {
    'stevearc/oil.nvim',
    keys = {
      '-',
    },
    lazy = false,
    -- dependencies = { { 'nvim-tree/nvim-web-devicons', event = 'VeryLazy' } },
    dependencies = {
      {
        'echasnovski/mini.icons',
        lazy = false,
      },
    },
    config = function()
      require 'custom.config.oil'
    end,
  },
}
