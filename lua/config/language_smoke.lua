local M = {}

local cases = {
  { file = "example.ts", filetype = "typescript", clients = { "vtsls" }, formatter = "prettier" },
  {
    file = "example.py",
    filetype = "python",
    clients = { "pyright" },
    formatter = "ruff_format",
    linter = "ruff",
  },
  { file = "example.c", filetype = "c", clients = { "clangd" }, formatter = "clang_format" },
  { file = "example.cpp", filetype = "cpp", clients = { "clangd" }, formatter = "clang_format" },
  { file = "example.lua", filetype = "lua", clients = { "lua_ls" }, formatter = "stylua" },
  {
    file = "example.md",
    filetype = "markdown",
    clients = { "marksman" },
    formatter = "prettier",
    linter = "markdownlint-cli2",
  },
}

local function has_expected_client(bufnr, names)
  local expected = {}
  for _, name in ipairs(names) do
    expected[name] = true
  end

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if expected[client.name] then
      return true
    end
  end
  return false
end

function M.run()
  local root = vim.fn.stdpath("config")
  local failures = {}
  local conform = require("conform")

  for _, case in ipairs(cases) do
    local path = vim.fs.joinpath(root, "tests", "fixtures", case.file)
    vim.cmd.edit(vim.fn.fnameescape(path))
    local bufnr = vim.api.nvim_get_current_buf()

    if vim.bo[bufnr].filetype ~= case.filetype then
      failures[#failures + 1] = case.file .. ": expected filetype " .. case.filetype
    end

    local attached = vim.wait(10000, function()
      return has_expected_client(bufnr, case.clients)
    end, 100)
    if not attached then
      failures[#failures + 1] = case.file .. ": expected LSP did not attach"
    end

    if not conform.get_formatter_info(case.formatter, bufnr).available then
      failures[#failures + 1] = case.file .. ": formatter " .. case.formatter .. " is unavailable"
    else
      local formatted, format_error = pcall(conform.format, {
        bufnr = bufnr,
        async = false,
        timeout_ms = 5000,
        lsp_format = "never",
      })
      if not formatted then
        failures[#failures + 1] = case.file .. ": formatter failed: " .. tostring(format_error)
      end
      vim.bo[bufnr].modified = false
    end

    if case.linter then
      local linted, lint_error = pcall(function()
        vim.api.nvim_buf_call(bufnr, function()
          require("lint").try_lint(case.linter)
        end)
      end)
      if not linted then
        failures[#failures + 1] = case.file .. ": linter failed: " .. tostring(lint_error)
      end
    end
  end

  for _, executable in ipairs({ "ruff", "markdownlint-cli2" }) do
    if vim.fn.executable(executable) ~= 1 then
      failures[#failures + 1] = "linter executable unavailable: " .. executable
    end
  end

  if #failures > 0 then
    error("Language checks failed:\n" .. table.concat(failures, "\n"))
  end

  print("Language checks passed")
end

return M
