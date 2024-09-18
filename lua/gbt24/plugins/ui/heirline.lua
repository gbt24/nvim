return {
	"rebelot/heirline.nvim",
	event = "VeryLazy",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		require("heirline").setup({
			--statusline = require("gbt24.config.heirline.statusline"),
			tabline = require("gbt24.config.heirline.tabline"),
		})
	end,
}
