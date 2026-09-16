vim.api.nvim_create_user_command("PluginsUpdate", function()
  require("core.pack").update()
end, { desc = "Fetch and review plugin updates" })

vim.api.nvim_create_user_command("PluginsSync", function()
  require("core.pack").sync_lockfile()
end, { desc = "Synchronize plugins to the lockfile" })

vim.api.nvim_create_user_command("ConfigBuildBlink", function()
  require("core.pack").build_blink()
end, { desc = "Build the blink.cmp Rust matcher" })

vim.api.nvim_create_user_command("ConfigHealth", function()
  vim.cmd.checkhealth("config")
end, { desc = "Run configuration health checks" })
