return {
  'yetone/avante.nvim',
  cmd = { 'AvanteChat', 'AvanteAsk' },
  keys = { '<leader>aa', '<leader>af' },
  version = false, -- set this if you want to always pull the latest change
  opts = { provider = 'openai', file_selector = {
    provider = 'telescope',
  } },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make',
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'echasnovski/mini.icons',
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
