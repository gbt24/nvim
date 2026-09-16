local M = {}

local required_modules = {
  "aerial",
  "blink.cmp",
  "catppuccin",
  "conform",
  "gitsigns",
  "guess-indent",
  "lazydev",
  "lint",
  "lualine",
  "mason",
  "dap",
  "dapui",
  "nio",
  "iron.core",
  "mini.ai",
  "mini.surround",
  "nvim-treesitter",
  "oil",
  "snacks",
  "snacks.bigfile",
  "snacks.bufdelete",
  "snacks.explorer",
  "snacks.indent",
  "snacks.notifier",
  "snacks.picker",
  "snacks.words",
}

function M.run()
  local failures = {}

  local debug_ok, debug_error = pcall(require("plugins.debug").ensure)
  if not debug_ok then
    failures[#failures + 1] = "debug lazy setup: " .. tostring(debug_error)
  end

  for _, module in ipairs(required_modules) do
    local ok, err = pcall(require, module)
    if not ok then
      failures[#failures + 1] = module .. ": " .. tostring(err)
    end
  end

  local lualine_theme = require("lualine").get_config().options.theme
  if type(lualine_theme) == "string" and lualine_theme ~= "auto" then
    local ok = pcall(require, "lualine.themes." .. lualine_theme)
    if not ok then
      failures[#failures + 1] = "missing lualine theme: " .. lualine_theme
    end
  end

  local required_commands = {
    "ConfigHealth",
    "DapContinue",
    "Format",
    "GitDiff",
    "GitHistory",
    "IronRepl",
    "Lint",
    "PluginsUpdate",
    "SearchReplace",
    "SudaRead",
    "SudaWrite",
    "TerminalFloat",
  }
  for _, command in ipairs(required_commands) do
    if vim.fn.exists(":" .. command) ~= 2 then
      failures[#failures + 1] = "missing command: " .. command
    end
  end

  local outline_map = vim.fn.maparg("<leader>so", "n", false, true)
  if type(outline_map.callback) ~= "function" then
    failures[#failures + 1] = "missing symbols outline keymap: <leader>so"
  end

  for _, adapter in ipairs({ "python", "pwa-node", "codelldb", "local-lua" }) do
    if require("dap").adapters[adapter] == nil then
      failures[#failures + 1] = "missing DAP adapter: " .. adapter
    end
  end

  for _, lhs in ipairs({ "<leader>dc", "<leader>db", "<leader>rr", "<leader>rl" }) do
    local mapping = vim.fn.maparg(lhs, "n", false, true)
    if vim.tbl_isempty(mapping) then
      failures[#failures + 1] = "missing keymap: " .. lhs
    end
  end

  local ui_map = vim.fn.maparg("<leader>du", "n", false, true)
  local original_notify = vim.notify
  local no_session_notice = false
  vim.notify = function(message, level, options)
    if tostring(message):find("No active debug session", 1, true) then
      no_session_notice = true
    else
      original_notify(message, level, options)
    end
  end
  local ui_ok, ui_error = pcall(ui_map.callback)
  vim.notify = original_notify
  if not ui_ok then
    failures[#failures + 1] = "debug UI without a session: " .. tostring(ui_error)
  elseif not no_session_notice then
    failures[#failures + 1] = "debug UI did not guard a missing session"
  end

  for name, callback in pairs({
    grug_far = require("plugins.editing").ensure_grug_far,
    navigation = require("plugins.navigation").ensure_all,
    diffview = require("plugins.git").ensure_diffview,
    terminal = require("plugins.terminal").ensure,
    opencode = require("plugins.ai").ensure,
  }) do
    local ok, err = pcall(callback)
    if not ok then
      failures[#failures + 1] = name .. " lazy setup: " .. tostring(err)
    end
  end

  if #failures > 0 then
    error("Smoke checks failed:\n" .. table.concat(failures, "\n"))
  end

  print("Smoke checks passed")
end

return M
