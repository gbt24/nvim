local M = {}

function M.setup()
  require("core.loader").load("aerial.nvim")

  local aerial = require("aerial")
  aerial.setup({
    attach_mode = "global",
    close_automatic_events = {},
    layout = {
      default_direction = "right",
      placement = "edge",
      width = 32,
      min_width = 20,
      max_width = 40,
      resize_to_content = false,
    },
    open_automatic = false,
  })

  vim.keymap.set("n", "<leader>so", function()
    aerial.toggle({ focus = false, direction = "right" })
  end, { desc = "Toggle symbols outline" })
end

return M
