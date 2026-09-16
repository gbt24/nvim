local M = {}

local initialized = false

local function ensure()
  if initialized then
    return
  end

  require("plugins.terminal").ensure()
  vim.o.autoread = true
  vim.g.opencode_opts = {
    server = {
      start = function()
        require("snacks.terminal").open("opencode --port", {
          win = { position = "right", enter = false, width = 0.4 },
        })
      end,
    },
    ask = {
      snacks = {
        win = { relative = "cursor", row = -3, col = 0, title_pos = "left" },
      },
    },
  }
  require("core.loader").load("opencode.nvim")
  initialized = true
end

local function call(method, ...)
  ensure()
  return require("opencode")[method](...)
end

function M.ensure()
  ensure()
end

function M.setup()
  vim.keymap.set({ "n", "x" }, "<leader>aa", function()
    call("ask")
  end, { desc = "Ask OpenCode" })
  vim.keymap.set("n", "<leader>as", function()
    call("select")
  end, { desc = "OpenCode actions" })
  vim.keymap.set({ "n", "t" }, "<leader>at", function()
    ensure()
    require("snacks.terminal").toggle("opencode --port", { win = { position = "right", width = 0.4 } })
  end, { desc = "Toggle OpenCode" })
  vim.keymap.set("n", "<leader>ao", function()
    ensure()
    return require("opencode").operator("@this ")
  end, { expr = true, desc = "Send motion to OpenCode" })

  vim.api.nvim_create_user_command("OpenCodeHealth", function()
    ensure()
    vim.cmd.checkhealth("opencode")
  end, { desc = "Check OpenCode integration" })
end

return M
