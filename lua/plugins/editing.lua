local M = {}

local grug_far_ready = false

local function setup_grug_far()
  if grug_far_ready then
    return
  end

  require("core.loader").load({ "grug-far.nvim" })
  require("grug-far").setup({})
  grug_far_ready = true
end

local function open_grug_far(search)
  setup_grug_far()
  local options = {}
  if search and search ~= "" then
    options.prefills = { search = search }
  end
  require("grug-far").open(options)
end

function M.ensure_grug_far()
  setup_grug_far()
end

function M.setup()
  require("core.loader").load({ "guess-indent.nvim", "lazydev.nvim", "mini.nvim", "suda.vim" })

  require("guess-indent").setup({
    auto_cmd = true,
    override_editorconfig = false,
    filetype_exclude = { "help", "oil", "Trouble", "grug-far", "snacks_picker_input", "snacks_picker_list" },
    buftype_exclude = { "help", "nofile", "terminal", "prompt" },
  })

  require("lazydev").setup({
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  })

  require("mini.ai").setup({ n_lines = 500 })
  require("mini.surround").setup({ n_lines = 40 })

  vim.api.nvim_create_user_command("SearchReplace", function(options)
    open_grug_far(options.args)
  end, { nargs = "*", desc = "Search and replace across the project" })

  vim.keymap.set("n", "<leader>fR", function()
    open_grug_far(vim.fn.expand("<cword>"))
  end, { desc = "Search and replace word" })
  vim.keymap.set("x", "<leader>fR", function()
    setup_grug_far()
    require("grug-far").with_visual_selection()
  end, { desc = "Search and replace selection" })
end

return M
