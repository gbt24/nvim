-- [[ Import Plugins ]]
-- See lazy.nvim document to get more information
--     https://github.com/folke/lazy.nvim
return {
	-- INFO: This format will automatically import
	-- the plugins in specific folder.

	{ import = "gbt24.plugins.tools" },

	{ import = "gbt24.plugins.git" },

	--{ import = "abel.plugins.efficiency" },

	{ import = "gbt24.plugins.treesitter" },

	--{ import = "abel.plugins.mini" },

	{ import = "gbt24.plugins.editor" },

	{ import = "gbt24.plugins.ui" },

	{ import = "gbt24.plugins.dap" },
}
