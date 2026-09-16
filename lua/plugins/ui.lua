local M = {}

function M.setup()
  local loader = require("core.loader")
  loader.load({
    "catppuccin",
    "nvim-web-devicons",
    "nui.nvim",
    "noice.nvim",
    "lualine.nvim",
    "bufferline.nvim",
    "which-key.nvim",
  })

  vim.g.have_nerd_font = vim.g.have_nerd_font ~= false

  require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = false,
    integrations = {
      blink_cmp = true,
      diffview = true,
      gitsigns = true,
      mason = true,
      native_lsp = { enabled = true },
      noice = true,
      snacks = { enabled = true, indent_scope_color = "lavender" },
      treesitter = true,
      which_key = true,
    },
  })
  vim.cmd.colorscheme("catppuccin-mocha")

  require("noice").setup({
    lsp = {
      progress = { enabled = true },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
  })

  require("lualine").setup({
    options = {
      theme = "auto",
      globalstatus = true,
      component_separators = { left = "│", right = "│" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
    },
  })

  require("bufferline").setup({
    options = {
      diagnostics = "nvim_lsp",
      separator_style = "slant",
      show_buffer_close_icons = false,
      show_close_icon = false,
      always_show_bufferline = false,
    },
  })

  local wk = require("which-key")
  wk.setup({ preset = "modern", delay = 350 })
  wk.add({
    { "<leader>a", group = "AI" },
    { "<leader>b", group = "buffer" },
    { "<leader>c", group = "code" },
    { "<leader>f", group = "find" },
    { "<leader>g", group = "git" },
    { "<leader>p", group = "packages" },
    { "<leader>t", group = "terminal" },
    { "<leader>x", group = "diagnostics" },
  })

  vim.keymap.set("n", "<leader>xx", Snacks.picker.diagnostics, { desc = "Workspace diagnostics" })
  vim.keymap.set("n", "<leader>xX", Snacks.picker.diagnostics_buffer, { desc = "Buffer diagnostics" })
  vim.keymap.set("n", "<leader>xs", Snacks.picker.lsp_symbols, { desc = "Document symbols" })
end

return M
