local M = {}

function M.setup()
  require("core.loader").load("nvim-lint")
  local lint = require("lint")

  lint.linters_by_ft = {
    python = { "ruff" },
    markdown = { "markdownlint-cli2" },
  }

  local timers = {}
  local function debounce(bufnr)
    if vim.b[bufnr].large_file then
      return
    end
    if timers[bufnr] then
      timers[bufnr]:stop()
      timers[bufnr]:close()
    end
    timers[bufnr] = vim.defer_fn(function()
      timers[bufnr] = nil
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_call(bufnr, function()
          lint.try_lint(nil, { ignore_errors = true })
        end)
      end
    end, 350)
  end

  vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("ConfigLint", { clear = true }),
    callback = function(event)
      debounce(event.buf)
    end,
  })

  vim.api.nvim_create_user_command("Lint", function()
    lint.try_lint()
  end, { desc = "Lint current buffer" })
  vim.keymap.set("n", "<leader>cl", function()
    lint.try_lint()
  end, { desc = "Lint buffer" })
end

return M
