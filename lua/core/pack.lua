local M = {}

local function build_blink()
  if vim.fn.executable("cargo") ~= 1 then
    error("cargo is required to build the blink.cmp Rust matcher")
  end

  local plugins = vim.pack.get({ "blink.cmp" })
  local plugin = plugins[1]
  if not plugin then
    error("blink.cmp is not managed by vim.pack")
  end

  local result = vim
    .system({ "cargo", "build", "--release" }, {
      cwd = plugin.path,
      text = true,
    })
    :wait(300000)
  if result.code ~= 0 then
    error("blink.cmp build failed:\n" .. (result.stderr or result.stdout or "unknown error"))
  end
end

local function register_build_hooks()
  local group = vim.api.nvim_create_augroup("ConfigPackBuild", { clear = true })

  vim.api.nvim_create_autocmd("PackChanged", {
    group = group,
    callback = function(event)
      local data = event.data or {}
      local spec = data.spec or {}

      if data.kind == "update" and spec.name == "nvim-treesitter" then
        vim.schedule(function()
          require("core.loader").load("nvim-treesitter")
          require("nvim-treesitter").update():wait(300000)
        end)
      end
    end,
  })
end

function M.setup()
  register_build_hooks()
  vim.pack.add(require("plugins.specs"), { confirm = false, load = false })
end

function M.update()
  vim.pack.update()
end

function M.sync_lockfile()
  vim.pack.update(nil, { target = "lockfile" })
end

function M.build_blink()
  build_blink()
end

return M
