local M = {}

local initialized = false

function M.setup()
  if initialized then
    return
  end

  require("core.loader").load("snacks.nvim")
  require("snacks").setup({
    bigfile = {
      enabled = true,
      size = 1024 * 1024,
      setup = function(ctx)
        vim.b[ctx.buf].large_file = true
        vim.bo[ctx.buf].swapfile = false
        vim.bo[ctx.buf].undofile = false
        vim.b[ctx.buf].completion = false
        vim.b[ctx.buf].minianimate_disable = true
        vim.b[ctx.buf].minihipatterns_disable = true
        Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ctx.buf) then
            vim.bo[ctx.buf].syntax = ctx.ft
          end
        end)
      end,
    },
    explorer = { enabled = true, trash = true },
    indent = {
      enabled = true,
      indent = { char = "│" },
      scope = { enabled = true, char = "│" },
      animate = { enabled = false },
      filter = function(buf)
        return not vim.b[buf].large_file and vim.bo[buf].buftype == ""
      end,
    },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 2500,
      style = "compact",
    },
    picker = {
      enabled = true,
      ui_select = true,
      sources = {
        explorer = {
          watch = false,
          hidden = true,
          ignored = false,
          exclude = { ".DS_Store" },
          layout = { preset = "sidebar", preview = false, layout = { width = 34 } },
        },
        files = { hidden = true, ignored = false },
        grep = { hidden = true, ignored = false },
      },
    },
    quickfile = { enabled = true },
    terminal = { enabled = true },
    words = { enabled = true },
  })

  initialized = true
end

function M.ensure()
  M.setup()
end

return M
