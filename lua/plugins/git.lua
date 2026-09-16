local M = {}

local diffview_ready = false

local function setup_diffview()
  if diffview_ready then
    return
  end

  require("core.loader").load({ "plenary.nvim", "nvim-web-devicons", "diffview.nvim" })
  require("diffview").setup({
    enhanced_diff_hl = true,
    view = {
      merge_tool = {
        layout = "diff3_horizontal",
        disable_diagnostics = true,
        winbar_info = true,
      },
    },
  })
  diffview_ready = true
end

function M.ensure_diffview()
  setup_diffview()
end

function M.setup()
  require("core.loader").load({ "plenary.nvim", "gitsigns.nvim" })
  require("gitsigns").setup({
    current_line_blame = false,
    preview_config = { border = "rounded" },
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local map = function(mode, lhs, rhs, desc, opts)
        vim.keymap.set(
          mode,
          lhs,
          rhs,
          vim.tbl_extend("force", {
            buffer = bufnr,
            desc = desc,
          }, opts or {})
        )
      end

      map("n", "]h", function()
        if vim.wo.diff then
          return "]h"
        end
        vim.schedule(gs.next_hunk)
        return "<Ignore>"
      end, "Next Git hunk", { expr = true })
      map("n", "[h", function()
        if vim.wo.diff then
          return "[h"
        end
        vim.schedule(gs.prev_hunk)
        return "<Ignore>"
      end, "Previous Git hunk", { expr = true })
      map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
      map("n", "<leader>gb", gs.blame_line, "Blame line")
      map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle inline blame")
      map("n", "<leader>gd", gs.diffthis, "Diff current file")
      map({ "o", "x" }, "ih", gs.select_hunk, "Select Git hunk")
    end,
  })

  vim.api.nvim_create_user_command("GitDiff", function(options)
    setup_diffview()
    vim.cmd("DiffviewOpen " .. options.args)
  end, { nargs = "*", complete = "file", desc = "Open repository diff" })
  vim.api.nvim_create_user_command("GitHistory", function(options)
    setup_diffview()
    local args = options.args ~= "" and options.args or "%"
    vim.cmd("DiffviewFileHistory " .. args)
  end, { nargs = "*", complete = "file", desc = "Open Git file history" })
  vim.api.nvim_create_user_command("GitConflicts", function()
    setup_diffview()
    vim.cmd("DiffviewOpen")
  end, { desc = "Open Diffview merge tool" })

  vim.keymap.set("n", "<leader>gg", "<cmd>GitDiff<cr>", { desc = "Repository diff" })
  vim.keymap.set("n", "<leader>gh", "<cmd>GitHistory<cr>", { desc = "File history" })
  vim.keymap.set("n", "<leader>gc", "<cmd>GitConflicts<cr>", { desc = "Resolve conflicts" })
end

return M
