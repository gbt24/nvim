local M = {}

M.is_lsp_attached = function()
  local clients = vim.lsp.get_active_clients { bufnr = vim.api.nvim_get_current_buf() }
  return next(clients) ~= nil
end

M.is_mac = function()
  local uname = vim.uv.os_uname()
  return uname.sysname == 'Darwin'
end

-- local actions_state = require 'telescope.actions.state'
-- local utils = require 'telescope.utils'
-- local a = vim.api
-- local Path = require 'plenary.path'
-- local edit_buffer
-- do
--   local map = {
--     edit = 'buffer',
--     new = 'sbuffer',
--     vnew = 'vert sbuffer',
--     tabedit = 'tab sb',
--   }
--
--   edit_buffer = function(command, bufnr)
--     command = map[command]
--     if command == nil then
--       error 'There was no associated buffer command'
--     end
--     vim.cmd(string.format('%s %d', command, bufnr))
--   end
-- end
--
-- M.is_glibc_old = function()
--   -- return vim.startswith(vim.fn.hostname(), 'lhcb-dev4') or vim.fn.hostname() == 'ubuntu-lhcb-devnode-02'
--   return vim.fn.hostname() == 'ubuntu-lhcb-devnode-02'
-- end
--
-- M.reveal_in_neotree = function()
--   local selection = actions_state.get_selected_entry()
--   local filename = selection.filename
--   if filename == nil then
--     filename = selection[1]
--   end
--   require('neo-tree.command').execute {
--     action = 'focus', -- OPTIONAL, this is the default value
--     source = 'filesystem', -- OPTIONAL, this is the default value
--     position = 'left', -- OPTIONAL, this is the default value
--     reveal_file = filename, -- path to file or folder to reveal
--     reveal_force_cwd = true, -- change cwd without asking if needed
--   }
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
-- end
--
-- M.edit_respect_winfixbuf = function(prompt_bufnr)
--   ---@diagnostic disable-next-line: missing-parameter
--   actions_state.get_current_history():append(actions_state.get_current_line(), actions_state.get_current_picker(prompt_bufnr))
--   local command = actions_state.select_key_to_edit_key 'default'
--   local entry = actions_state.get_selected_entry()
--
--   if not entry then
--     utils.notify('actions.set.edit', {
--       msg = 'Nothing currently selected',
--       level = 'WARN',
--     })
--     return
--   end
--
--   local filename, row, col
--
--   if entry.path or entry.filename then
--     filename = entry.path or entry.filename
--
--     -- TODO: Check for off-by-one
--     row = entry.row or entry.lnum
--     col = entry.col
--   elseif not entry.bufnr then
--     -- TODO: Might want to remove this and force people
--     -- to put stuff into `filename`
--     local value = entry.value
--     if not value then
--       utils.notify('actions.set.edit', {
--         msg = 'Could not do anything with blank line...',
--         level = 'WARN',
--       })
--       return
--     end
--
--     if type(value) == 'table' then
--       value = entry.display
--     end
--
--     local sections = vim.split(value, ':')
--
--     filename = sections[1]
--     row = tonumber(sections[2])
--     col = tonumber(sections[3])
--   end
--
--   -- this is telescope promt buffer
--   local entry_bufnr = entry.bufnr
--
--   local picker = actions_state.get_current_picker(prompt_bufnr)
--   require('telescope.pickers').on_close_prompt(prompt_bufnr)
--   pcall(vim.api.nvim_set_current_win, picker.original_win_id)
--   local win_id = picker.get_selection_window(picker, entry)
--
--   if picker.push_cursor_on_edit then
--     vim.cmd "normal! m'"
--   end
--
--   if picker.push_tagstack_on_edit then
--     local from = { vim.fn.bufnr '%', vim.fn.line '.', vim.fn.col '.', 0 }
--     local items = { { tagname = vim.fn.expand '<cword>', from = from } }
--     vim.fn.settagstack(vim.fn.win_getid(), { items = items }, 't')
--   end
--
--   if vim.api.nvim_get_option_value('winfixbuf', { win = win_id }) then
--     local windows = vim.api.nvim_list_wins()
--     for _, winid in ipairs(windows) do
--       if not vim.api.nvim_get_option_value('winfixbuf', { win = winid }) then
--         vim.api.nvim_set_current_win(winid)
--         break
--       end
--     end
--   end
--
--   if entry_bufnr then
--     if not vim.api.nvim_get_option_value('buflisted', { buf = entry_bufnr }) then
--       vim.api.nvim_set_option_value('buflisted', true, { buf = entry_bufnr })
--     end
--     edit_buffer(command, entry_bufnr)
--   else
--     -- check if we didn't pick a different buffer
--     -- prevents restarting lsp server
--     if vim.api.nvim_buf_get_name(0) ~= filename or command ~= 'edit' then
--       filename = Path:new(filename):normalize(vim.loop.cwd())
--       pcall(vim.cmd, string.format('%s %s', command, vim.fn.fnameescape(filename)))
--     end
--   end
--
--   -- HACK: fixes folding: https://github.com/nvim-telescope/telescope.nvim/issues/699
--   if vim.wo.foldmethod == 'expr' then
--     vim.schedule(function()
--       vim.opt.foldmethod = 'expr'
--     end)
--   end
--
--   local pos = vim.api.nvim_win_get_cursor(0)
--   if col == nil then
--     if row == pos[1] then
--       col = pos[2] + 1
--     elseif row == nil then
--       row, col = pos[1], pos[2] + 1
--     else
--       col = 1
--     end
--   end
--
--   if row and col then
--     local ok, err_msg = pcall(a.nvim_win_set_cursor, 0, { row, col })
--     if not ok then
--       log.debug('Failed to move to cursor:', err_msg, row, col)
--     end
--   end
-- end

-- Where a tab is a tabpage or buffer
M.prefer_tabpage = true

-- Border style of floating windows
M.border = 'rounded'

-- Width of side windows
M.width = function()
  local columns = vim.go.columns
  return math.floor(columns * 0.2) > 25 and math.floor(columns * 0.2) or 25
end

local append_space = function(icons)
  local result = {}
  for k, v in pairs(icons) do
    result[k] = v .. ' '
  end
  return result
end

local kind_icons = {
  Array = '',
  Boolean = '',
  Class = '',
  Color = '',
  Constant = '',
  Constructor = '',
  Enum = '',
  EnumMember = '',
  Event = '',
  Field = '',
  File = '',
  Folder = '',
  Function = '',
  Interface = '',
  Key = '',
  Keyword = '',
  Method = '',
  Module = '',
  Namespace = '',
  Null = '',
  Number = '',
  Object = '',
  Operator = '',
  Package = '',
  Property = '',
  Reference = '',
  Snippet = '',
  String = '',
  Struct = '',
  Text = '',
  TypeParameter = '',
  Unit = '',
  Value = '',
  Variable = '',
}

local misc_icons = {
  close = '',
}

M.icons = {
  -- LSP diagnostic
  diagnostic = {
    error = '󰅚 ',
    warn = '󰀪 ',
    hint = '󰌶 ',
    info = '󰋽 ',
  },
  ui = {
    cmd = ' ',
    config = '',
    event = ' ',
    ft = ' ',
    init = ' ',
    import = ' ',
    keys = ' ',
    lazy = '󰒲 ',
    loaded = '●',
    not_loaded = '○',
    plugin = ' ',
    runtime = ' ',
    require = '󰢱 ',
    source = ' ',
    start = ' ',
    task = '✔ ',
    list = {
      '●',
      '➜',
      '★',
      '‒',
    },
  },
  -- LSP kinds
  kind = kind_icons,
  kind_with_space = append_space(kind_icons),
  misc = misc_icons,
}

M.cmp_format = {
  mode = 'symbol',
  maxwidth = 50,
  menu = {
    luasnip = '[SNP]',
    nvim_lsp = '[LSP]',
    nvim_lua = '[VIM]',
    buffer = '[BUF]',
    path = '[PTH]',
    calc = '[CLC]',
    latex_symbols = '[TEX]',
    orgmode = '[ORG]',
  },
}

return M
