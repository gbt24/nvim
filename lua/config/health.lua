local M = {}

local function executable(name, required)
  if vim.fn.executable(name) == 1 then
    vim.health.ok(name .. " is available")
  elseif required then
    vim.health.error(name .. " is required")
  else
    vim.health.warn(name .. " is not available")
  end
end

local function version_at_least(command, minimum)
  if vim.fn.executable(command) ~= 1 then
    return
  end

  local result = vim.system({ command, "--version" }, { text = true }):wait(3000)
  local parsed = result.code == 0 and vim.version.parse(result.stdout or "") or nil
  if not parsed then
    vim.health.warn("Could not determine " .. command .. " version")
  elseif vim.version.ge(parsed, vim.version.parse(minimum)) then
    vim.health.ok(command .. " " .. tostring(parsed) .. " satisfies >= " .. minimum)
  else
    vim.health.error(command .. " " .. tostring(parsed) .. " is older than " .. minimum)
  end
end

function M.check()
  vim.health.start("Neovim configuration")

  if vim.fn.has("nvim-0.12") == 1 then
    vim.health.ok("Neovim 0.12+ is available")
  else
    vim.health.error("Neovim 0.12+ is required")
  end

  executable("git", true)
  executable("curl", true)
  executable("rg", false)
  executable("fd", false)
  executable("cc", false)
  executable("tree-sitter", false)
  executable("cargo", false)
  executable("opencode", false)
  executable("pgrep", false)
  executable("lsof", false)
  executable("sudo", false)
  executable("node", false)
  executable("python3", false)
  executable("lua", false)
  version_at_least("tree-sitter", "0.26.1")
  version_at_least("opencode", "1.17.0")

  local matcher_ok = pcall(require, "blink.cmp.fuzzy.rust")
  if matcher_ok then
    vim.health.ok("blink.cmp Rust matcher is available")
  else
    vim.health.warn("blink.cmp is using its Lua matcher; source builds require rustc 1.88+")
  end

  vim.health.start("Language tools")
  for _, name in ipairs({
    "vtsls",
    "vscode-eslint-language-server",
    "pyright-langserver",
    "ruff",
    "clangd",
    "clang-format",
    "lua-language-server",
    "stylua",
    "marksman",
    "prettier",
    "markdownlint-cli2",
    "debugpy-adapter",
    "js-debug-adapter",
    "codelldb",
  }) do
    executable(name, false)
  end

  vim.health.start("Debugging and REPL")
  if vim.fn.executable("tsx") == 1 then
    vim.health.ok("tsx is available for TypeScript debugging")
  else
    vim.health.info("Install tsx in a TypeScript project to launch the current file")
  end
  if vim.fn.executable("ts-node") == 1 then
    vim.health.ok("ts-node is available for the TypeScript REPL")
  else
    vim.health.info("Install ts-node in a TypeScript project to enable its REPL")
  end

  local lua_adapter = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "local-lua-debugger-vscode")
  if vim.uv.fs_stat(lua_adapter) then
    vim.health.ok("local-lua-debugger-vscode is installed")
  else
    vim.health.warn("local-lua-debugger-vscode is not installed")
  end

  local lockfile = vim.fs.joinpath(vim.fn.stdpath("config"), "nvim-pack-lock.json")
  if vim.uv.fs_stat(lockfile) then
    vim.health.ok("vim.pack lockfile exists")
  else
    vim.health.warn("vim.pack lockfile has not been created yet")
  end

  if vim.g.have_nerd_font then
    vim.health.ok("Nerd Font mode is enabled")
  else
    vim.health.info("Set vim.g.have_nerd_font = true when using a Nerd Font")
  end
end

return M
