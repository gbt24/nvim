vim.loader.enable()
require 'custom.options'
require 'custom.keymaps'
require 'custom.autocmds'
require 'custom.filetypes'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-sleuth',
  -- { 'mg979/vim-visual-multi', lazy = true, keys = { { '<C-n>', mode = { 'n', 'x' } } } },
  { 'stevearc/dressing.nvim', event = 'VeryLazy', opts = {} },
  { 'folke/todo-comments.nvim', ft = { 'cpp', 'python', 'sh' }, dependencies = { 'nvim-lua/plenary.nvim' }, opts = {} },
  {
    'christoomey/vim-tmux-navigator',
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },
  { 'numToStr/Comment.nvim', opts = {} },
  { import = 'custom.plugins' },
}, {
  ui = {
    icons = {},
    border = 'single',
  },
})
