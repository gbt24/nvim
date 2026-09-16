local M = {}

function M.install()
  require("nvim-treesitter").install(require("languages").treesitter_parsers):wait(300000)
end

function M.update()
  require("nvim-treesitter").update():wait(300000)
end

function M.setup()
  require("core.loader").load("nvim-treesitter")
  require("nvim-treesitter").setup({})
  vim.treesitter.language.register("json", "jsonc")

  local group = vim.api.nvim_create_augroup("ConfigTreesitter", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(event)
      if vim.b[event.buf].large_file then
        return
      end

      local ok = pcall(vim.treesitter.start, event.buf)
      if ok then
        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })

  vim.api.nvim_create_user_command("ConfigTreesitterInstall", M.install, {
    desc = "Install configured Treesitter parsers",
  })
  vim.api.nvim_create_user_command("ConfigTreesitterUpdate", M.update, {
    desc = "Update installed Treesitter parsers",
  })
end

return M
