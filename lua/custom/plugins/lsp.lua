---@diagnostic disable: missing-fields
local pip_args
if vim.startswith(vim.fn.hostname(), 'n819') then
  pip_args = { '--proxy', 'http://lbproxy:8080' } -- need LbEnv
else
  pip_args = {}
end

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'LspInfo', 'LspInstall', 'LspUninstall' },
    dependencies = { { 'dnlhc/glance.nvim', cmd = 'Glance' } },
    config = function()
      require 'custom.config.lsp'
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = {
      pip = {
        upgrade_pip = false,
        install_args = pip_args,
      },
      ui = {
        border = 'single',
        width = 0.7,
        height = 0.7,
      },
    },
  },
}
