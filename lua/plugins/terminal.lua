local M = {}

local function ensure()
  require("plugins.snacks").ensure()
end

local function toggle(name, position)
  ensure()
  require("snacks.terminal").toggle(nil, {
    env = { NVIM_TERMINAL_NAME = name },
    win = position == "float" and { style = "terminal", position = "float", border = "rounded" } or {
      style = "terminal",
      position = position,
      height = position == "bottom" and 0.35 or nil,
      width = position == "right" and 0.4 or nil,
    },
  })
end

function M.ensure()
  ensure()
end

function M.setup()
  vim.keymap.set({ "n", "t" }, "<C-`>", function()
    toggle("shell", "float")
  end, { desc = "Toggle floating terminal" })
  vim.keymap.set("n", "<leader>tf", function()
    toggle("shell-float", "float")
  end, { desc = "Floating terminal" })
  vim.keymap.set("n", "<leader>tb", function()
    toggle("shell-bottom", "bottom")
  end, { desc = "Bottom terminal" })
  vim.keymap.set("n", "<leader>tr", function()
    toggle("shell-right", "right")
  end, { desc = "Right terminal" })
  vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })

  vim.api.nvim_create_user_command("TerminalFloat", function()
    toggle("shell-float", "float")
  end, { desc = "Toggle floating terminal" })
  vim.api.nvim_create_user_command("TerminalBottom", function()
    toggle("shell-bottom", "bottom")
  end, { desc = "Toggle bottom terminal" })
  vim.api.nvim_create_user_command("TerminalRight", function()
    toggle("shell-right", "right")
  end, { desc = "Toggle right terminal" })
end

return M
