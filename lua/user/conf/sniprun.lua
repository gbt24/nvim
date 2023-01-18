local status_ok, sniprun = pcall(require, "sniprun")
if not status_ok then
  vim.notify("sniprun not found!")
  return
end

sniprun.setup({
  display = { "Classic" },
})

