require("gbt24.options")
require("gbt24.autocmds")
require("gbt24.filetypes")
require("gbt24.keymaps")

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

local custom = require("gbt24.config.custom")
-- [[ Configure and install plugins ]]
require("lazy").setup({

	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	-- quick remedy when tab-complete-then-enter fails you, e.g. `nvim init.l`
	{ "mong8se/actually.nvim", lazy = false },

	-- current best multicursor IMHO
	{ "mg979/vim-visual-multi", lazy = true, keys = { { "<C-n>", mode = { "n", "x" } } } },

	-- kitty conf file highlight
	{ "fladson/vim-kitty", ft = { "kitty" } },

	-- Use `opts = {}` to force a plugin to be loaded.
	{ "stevearc/dressing.nvim", event = "VeryLazy", opts = {} },

	-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	{ import = "gbt24.plugins" },
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		ui = custom.icons.ui,
		border = custom.border,
	},
	diff = {
		cmd = "diffview.nvim",
	},
})
