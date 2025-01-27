---Show the outline of file

---@type LazyPluginSpec
return {
  'hedyhli/outline.nvim',
  lazy = true,
  cmd = { 'Outline', 'OutlineOpen' },
  keys = {
    { '<leader>o', '<Cmd>Outline<CR>', desc = 'Toggle outline' },
  },
  opts = {
    preview_window = {
      border = require('custom.utils').border,
      live = true,
    },
    symbols = {
      icon_source = 'nil',
    },
  },
}
