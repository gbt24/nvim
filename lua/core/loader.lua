local M = {}

local loaded = {}

function M.load(names)
  if type(names) == "string" then
    names = { names }
  end

  for _, name in ipairs(names) do
    if not loaded[name] then
      vim.cmd.packadd(name)
      loaded[name] = true
    end
  end
end

function M.once(key, callback)
  local initialized = false
  return function(...)
    if not initialized then
      callback()
      initialized = true
    end
    return require(key)
  end
end

function M.is_loaded(name)
  return loaded[name] == true
end

return M
