local custom = require("gbt24.config.custom")

---@type LazyPluginSpec
return {
	"Bekaboo/dropbar.nvim",
	event = {
		"BufRead",
		"BufNewFile",
	},
	opts = {
		icons = {
			kinds = {
				symbols = vim.tbl_extend("keep", { Folder = " " }, custom.icons.kind_with_space),
			},
		},
		sources = {
			path = {
				modified = function(sym)
					return sym:merge({
						name = sym.name .. " [+]",
						name_hl = "DiffAdded",
					})
				end,
			},
		},
	},
}
