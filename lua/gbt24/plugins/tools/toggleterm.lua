---Persist and toggle multiple terminals during an editing session

local custom = require("gbt24.config.custom")

---@type LazyPluginSpec
return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		size = function(term)
			if term.direction == "horizontal" then
				return 10
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
		end,
		open_mapping = [[<c-\>]],
		shell = vim.uv.os_uname().sysname == "Windows_NT" and "pwsh" or "zsh",
		float_opts = {
			border = custom.border,
		},
		winbar = {
			enabled = true,
		},
	},
	keys = function()
		local float_opts = {
			border = custom.border,
		}
		local on_create = function(t)
			local bufnr = t.bufnr
			vim.keymap.set("t", "<Esc>", "<Nop>", { buffer = bufnr })
		end

		local lazygit = require("toggleterm.terminal").Terminal:new({
			cmd = "lazygit",
			hidden = true,
			direction = "float",
			float_opts = float_opts,
			on_create = on_create,
		})
		local lazydocker = require("toggleterm.terminal").Terminal:new({
			cmd = "lazydocker",
			hidden = true,
			direction = "float",
			float_opts = float_opts,
			on_create = on_create,
		})
		local gh_dash = require("toggleterm.terminal").Terminal:new({
			-- https://github.com/dlvhdr/gh-dash/issues/316
			env = { LANG = "en_US.UTF-8" },
			cmd = "gh dash",
			hidden = true,
			direction = "float",
			float_opts = float_opts,
			on_create = on_create,
		})
		local yazi = require("toggleterm.terminal").Terminal:new({
			cmd = "yazi",
			hidden = true,
			direction = "float",
			float_opts = float_opts,
			on_create = on_create,
		})

		return {
			{ "<C-\\>" },
			{ "<leader>tt", "<Cmd>ToggleTermToggleAll<CR>", mode = "n", desc = "All Terminal" },

			-- External programs
			{
				"<leader>pl",
				function()
					lazygit:toggle()
				end,
				desc = "LazyGit",
			},
			{
				"<leader>pd",
				function()
					lazydocker:toggle()
				end,
				desc = "Lazy Docker",
			},
			{
				"<leader>pg",
				function()
					gh_dash:toggle()
				end,
				desc = "GitHub Dash",
			},
			{
				"<leader>pn",
				function()
					yazi:toggle()
				end,
				desc = "File Manager",
			},
		}
	end,
}
