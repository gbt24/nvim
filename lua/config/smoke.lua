local M = {}

local required_modules = {
  "blink.cmp",
  "catppuccin",
  "conform",
  "gitsigns",
  "guess-indent",
  "lazydev",
  "lint",
  "lualine",
  "mason",
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
    "Format",
    "GitDiff",
    "GitHistory",
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
