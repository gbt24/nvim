local M = {}

function M.setup()
  require("core.loader").load({ "friendly-snippets", "blink.cmp" })

  require("blink.cmp").setup({
    keymap = { preset = "default" },
    appearance = { nerd_font_variant = "mono" },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 350 },
      menu = { border = "rounded" },
    },
    signature = { enabled = true, window = { border = "rounded" } },
    sources = {
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  })
end

return M
