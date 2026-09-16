local M = {}

local function skip(bufnr)
  if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat or vim.b[bufnr].large_file then
    return true
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  return name:match("/node_modules/") or name:match("/dist/") or name:match("/build/") or name:match("%.min%.[^.]+$")
end

function M.setup()
  require("core.loader").load("conform.nvim")
  local conform = require("conform")

  conform.setup({
    formatters_by_ft = {
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      python = { "ruff_format" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      lua = { "stylua" },
      markdown = { "prettier" },
      ["markdown.mdx"] = { "prettier" },
    },
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = function(bufnr)
      if skip(bufnr) then
        return
      end
      return { timeout_ms = 1000, lsp_format = "fallback" }
    end,
    notify_on_error = true,
    notify_no_formatters = false,
  })

  vim.api.nvim_create_user_command("Format", function()
    conform.format({ async = true, lsp_format = "fallback" })
  end, { desc = "Format current buffer" })
  vim.api.nvim_create_user_command("FormatToggle", function()
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    vim.notify("Buffer autoformat " .. (vim.b.disable_autoformat and "disabled" or "enabled"))
  end, { desc = "Toggle autoformat for current buffer" })
  vim.keymap.set({ "n", "x" }, "<leader>cf", function()
    conform.format({ async = true, lsp_format = "fallback" })
  end, { desc = "Format buffer or selection" })
end

return M
