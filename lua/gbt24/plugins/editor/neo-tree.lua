return {
	"nvim-neo-tree/neo-tree.nvim",
	event = "VeryLazy",
	keys = {
		{ "B", "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree" },
		{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree" },
		{ "<leader>R", "<cmd>Neotree reveal<cr>", desc = "Reveal in Neotree" },
	},
	dependencies = {
		{ "akinsho/toggleterm.nvim", event = "VeryLazy" },
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("gbt24.config.neo-tree")
	end,
}
