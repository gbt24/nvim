local M = {}

M.servers = {
  "vtsls",
  "eslint",
  "basedpyright",
  "clangd",
  "lua_ls",
  "marksman",
}

M.mason_packages = {
  "vtsls",
  "eslint-lsp",
  "basedpyright",
  "ruff",
  "clangd",
  "clang-format",
  "lua-language-server",
  "stylua",
  "marksman",
  "prettier",
  "markdownlint-cli2",
}

M.treesitter_parsers = {
  "bash",
  "c",
  "cpp",
  "css",
  "diff",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "html",
  "javascript",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

return M
