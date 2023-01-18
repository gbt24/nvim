local status_ok, catppuccin = pcall(require, "catppuccin")
if not status_ok then
  return
end

catppuccin.setup(
{
  transparent_background = false,
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
}
)

