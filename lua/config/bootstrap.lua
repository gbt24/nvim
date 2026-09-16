local M = {}

local function install_mason_packages()
  local registry = require("mason-registry")
  assert(registry.refresh(), "Mason registry refresh failed")

  local pending = 0
  local failures = {}

  for _, name in ipairs(require("languages").mason_packages) do
    local ok, package = pcall(registry.get_package, name)
    if not ok then
      failures[#failures + 1] = name .. ": not present in Mason registry"
    elseif not package:is_installed() then
      pending = pending + 1
      package:install({}, function(success, err)
        if not success then
          failures[#failures + 1] = name .. ": " .. tostring(err)
        end
        pending = pending - 1
      end)
    end
  end

  assert(
    vim.wait(600000, function()
      return pending == 0
    end, 100),
    "Timed out installing Mason packages"
  )
  assert(#failures == 0, table.concat(failures, "\n"))
end

function M.run()
  local matcher_available = pcall(require, "blink.cmp.fuzzy.rust")
  if not matcher_available then
    local rustc = vim.fn.executable("rustc") == 1 and vim.system({ "rustc", "--version" }, { text = true }):wait(3000)
      or nil
    local rust_version = rustc and rustc.code == 0 and vim.version.parse(rustc.stdout or "") or nil
    local can_build_blink = rust_version and vim.version.ge(rust_version, vim.version.parse("1.88.0"))
    if can_build_blink then
      local built, build_error = pcall(require("core.pack").build_blink)
      if not built then
        vim.notify("Blink is using the Lua matcher:\n" .. tostring(build_error), vim.log.levels.WARN)
      end
    else
      vim.notify("Blink is using the Lua matcher; source builds require rustc 1.88+", vim.log.levels.WARN)
    end
  end
  install_mason_packages()
  require("plugins.treesitter").install()
  vim.notify("Bootstrap completed", vim.log.levels.INFO)
end

return M
