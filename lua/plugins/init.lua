local M = {}

function M.setup()
  require("plugins.snacks").setup()
  require("plugins.ui").setup()
  require("plugins.treesitter").setup()
  require("plugins.editing").setup()
  require("plugins.completion").setup()
  require("plugins.lsp").setup()
  require("plugins.outline").setup()
  require("plugins.format").setup()
  require("plugins.lint").setup()
  require("plugins.git").setup()
  require("plugins.navigation").setup()
  require("plugins.terminal").setup()
  require("plugins.ai").setup()
end

return M
