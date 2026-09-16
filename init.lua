vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.fn.has("nvim-0.12") ~= 1 then
  error("This configuration requires Neovim 0.12 or newer")
end

require("config.options")
require("config.autocmds")
require("core.pack").setup()
require("plugins").setup()
require("config.keymaps")
require("config.commands")
