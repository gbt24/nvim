local M = {}

local initialized = {
  oil = false,
}

local function setup_oil()
  if initialized.oil then
    return
  end

  require("core.loader").load({ "nvim-web-devicons", "oil.nvim" })
  require("oil").setup({
    default_file_explorer = false,
    delete_to_trash = vim.fn.executable("trash") == 1 or vim.fn.executable("trash-put") == 1,
    skip_confirm_for_simple_edits = false,
    view_options = { show_hidden = true, natural_order = true },
    float = { padding = 3, border = "rounded" },
  })
  initialized.oil = true
end

function M.ensure_all()
  require("plugins.snacks").ensure()
  setup_oil()
end

function M.setup()
  local map = vim.keymap.set

  map("n", "<leader>e", function()
    Snacks.explorer()
  end, { desc = "Toggle file explorer" })
  map("n", "<leader>E", function()
    Snacks.explorer.reveal()
  end, { desc = "Reveal current file" })
  map("n", "<leader>fo", function()
    setup_oil()
    require("oil").open_float()
  end, { desc = "Edit containing directory" })

  map("n", "<leader>ff", Snacks.picker.files, { desc = "Find files" })
  map("n", "<leader>fg", Snacks.picker.grep, { desc = "Find text" })
  map("n", "<leader>fb", Snacks.picker.buffers, { desc = "Find buffers" })
  map("n", "<leader>fh", Snacks.picker.help, { desc = "Find help" })
  map("n", "<leader>fr", Snacks.picker.recent, { desc = "Recent files" })
  map("n", "<leader>fn", Snacks.picker.notifications, { desc = "Notification history" })
  map("n", "<leader>fc", Snacks.picker.commands, { desc = "Find commands" })
  map("n", "<leader>fs", Snacks.picker.lsp_symbols, { desc = "Document symbols" })
  map("n", "<leader>fS", Snacks.picker.lsp_workspace_symbols, { desc = "Workspace symbols" })
  map("n", "grr", Snacks.picker.lsp_references, { desc = "References" })
end

return M
