---@diagnostic disable: missing-fields
require('snacks').setup {
  styles = { notification = { border = 'single' }, notification_history = { border = 'single', width = 0.9, height = 0.9, minimal = true } },
  indent = {
    indent = {
      char = ' ',
      only_scope = true,
      only_current = true,
      hl = {
        'SnacksIndent1',
        'SnacksIndent2',
        'SnacksIndent3',
        'SnacksIndent4',
        'SnacksIndent5',
        'SnacksIndent6',
        'SnacksIndent7',
        'SnacksIndent8',
      },
    },
    animate = {
      duration = {
        step = 10,
        duration = 100,
      },
    },
    scope = {
      enabled = true, -- enable highlighting the current scope
      priority = 200,
      char = '┊',
      underline = false, -- underline the start of the scope
      only_current = true, -- only show scope in the current window
      hl = {
        'SnacksIndent1',
        'SnacksIndent2',
        'SnacksIndent3',
        'SnacksIndent4',
        'SnacksIndent5',
        'SnacksIndent6',
        'SnacksIndent7',
        'SnacksIndent8',
      },
    },
  },
  lazygit = {},
  notifier = {},
  bufdelete = {},
  dashboard = {
    preset = {
      keys = {
        {
          icon = '󰈞 ',
          key = 'f',
          desc = 'Find files',
          action = function()
            require('telescope.builtin').find_files()
          end,
        },
        {
          icon = ' ',
          key = 'o',
          desc = 'Find history',
          action = function()
            require('telescope.builtin').oldfiles()
          end,
        },
        { icon = ' ', key = 'n', desc = 'New file', action = ':enew' },
        { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
        { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
        { icon = ' ', key = 'M', desc = 'Mason', action = ':Mason', enabled = package.loaded.lazy ~= nil },
        { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
      },
      header = [[
░  ░░░░░░░░  ░░░░  ░░░      ░░░  ░░░░░░░
▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒▒▒▒
▓  ▓▓▓▓▓▓▓▓        ▓▓  ▓▓▓▓▓▓▓▓       ▓▓
█  ████████  ████  ██  ████  ██  ████  █
█        ██  ████  ███      ███       ██
    ]],
    },
    sections = {
      { section = 'header' },
      { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
      { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
      { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
      -- { section = 'startup' },
    },
  },
  statuscolumn = {
    folds = {
      open = true, -- show open fold icons
      git_hl = false, -- use Git Signs hl for fold icons
    },
  },
}
