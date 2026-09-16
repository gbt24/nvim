local M = {}
local initialized = false

local function data_path(...)
  return vim.fs.joinpath(vim.fn.stdpath("data"), ...)
end

local function mason_bin(name)
  local suffix = vim.fn.has("win32") == 1 and ".cmd" or ""
  local path = data_path("mason", "bin", name .. suffix)
  if vim.fn.executable(path) == 1 then
    return path
  end
  return name
end

local function project_root(bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr or 0)
  local start = file ~= "" and vim.fs.dirname(file) or vim.uv.cwd()
  return vim.fs.root(start, { "pyproject.toml", "package.json", "CMakeLists.txt", "Makefile", ".git" }) or vim.uv.cwd()
end

local function executable(candidates)
  for _, candidate in ipairs(candidates) do
    if candidate and candidate ~= "" and vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end
end

local function python_path()
  local root = project_root(0)
  return executable({
    vim.fs.joinpath(root, ".venv", "bin", "python"),
    vim.fs.joinpath(root, "venv", "bin", "python"),
    vim.env.VIRTUAL_ENV and vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python") or nil,
    vim.env.CONDA_PREFIX and vim.fs.joinpath(vim.env.CONDA_PREFIX, "bin", "python") or nil,
    vim.fn.exepath("python3"),
    vim.fn.exepath("python"),
  }) or "python3"
end

local function node_runtime(name)
  local root = project_root(0)
  local local_runtime = vim.fs.joinpath(root, "node_modules", ".bin", name)
  if vim.fn.executable(local_runtime) == 1 then
    return local_runtime
  end

  local global_runtime = vim.fn.exepath(name)
  if global_runtime ~= "" then
    return global_runtime
  end

  vim.notify(
    name .. " is required. Install it in this project (for example: npm install --save-dev " .. name .. ")",
    vim.log.levels.ERROR
  )
  return name
end

local function lua_adapter_paths()
  local root = data_path("mason", "packages", "local-lua-debugger-vscode")
  local candidates = {
    { vim.fs.joinpath(root, "debugAdapter.js"), root },
    { vim.fs.joinpath(root, "extension", "debugAdapter.js"), vim.fs.joinpath(root, "extension") },
    {
      vim.fs.joinpath(root, "extension", "extension", "debugAdapter.js"),
      vim.fs.joinpath(root, "extension"),
    },
  }
  for _, candidate in ipairs(candidates) do
    if vim.uv.fs_stat(candidate[1]) then
      return candidate[1], candidate[2]
    end
  end
  return candidates[1][1], candidates[1][2]
end

local function setup_adapters(dap)
  dap.adapters.python = {
    type = "executable",
    command = mason_bin("debugpy-adapter"),
  }
  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "Launch current file",
      program = "${file}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      pythonPath = python_path,
    },
    {
      type = "python",
      request = "attach",
      name = "Attach to process",
      processId = require("dap.utils").pick_process,
      pythonPath = python_path,
    },
  }

  dap.adapters["pwa-node"] = {
    type = "server",
    host = "127.0.0.1",
    port = "${port}",
    executable = {
      command = mason_bin("js-debug-adapter"),
      args = { "${port}" },
    },
  }

  local attach_node = {
    type = "pwa-node",
    request = "attach",
    name = "Attach to Node process",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
    sourceMaps = true,
  }
  dap.configurations.javascript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch current JavaScript file",
      program = "${file}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      sourceMaps = true,
    },
    attach_node,
  }
  dap.configurations.javascriptreact = dap.configurations.javascript
  dap.configurations.typescript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch current TypeScript file (tsx)",
      runtimeExecutable = function()
        return node_runtime("tsx")
      end,
      program = "${file}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      sourceMaps = true,
      skipFiles = { "<node_internals>/**" },
    },
    attach_node,
  }
  dap.configurations.typescriptreact = dap.configurations.typescript

  dap.adapters.codelldb = {
    type = "executable",
    command = mason_bin("codelldb"),
  }
  dap.configurations.cpp = {
    {
      type = "codelldb",
      request = "launch",
      name = "Launch executable",
      program = function()
        return vim.fn.input("Executable: ", project_root(0) .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
  }
  dap.configurations.c = dap.configurations.cpp

  local lua_adapter, lua_extension = lua_adapter_paths()
  dap.adapters["local-lua"] = {
    type = "executable",
    command = executable({ vim.fn.exepath("node") }) or "node",
    args = { lua_adapter },
    enrich_config = function(config, on_config)
      local final = vim.deepcopy(config)
      final.extensionPath = final.extensionPath or lua_extension
      on_config(final)
    end,
  }
  dap.configurations.lua = {
    {
      type = "local-lua",
      request = "launch",
      name = "Launch current Lua file",
      cwd = "${workspaceFolder}",
      program = {
        lua = executable({ vim.fn.exepath("lua"), vim.fn.exepath("luajit") }) or "lua",
        file = "${file}",
      },
    },
  }
end

local function setup_ui(dap)
  local dapui = require("dapui")
  dapui.setup({
    layouts = {
      {
        position = "left",
        size = 40,
        elements = {
          { id = "scopes", size = 0.45 },
          { id = "stacks", size = 0.25 },
          { id = "breakpoints", size = 0.15 },
          { id = "watches", size = 0.15 },
        },
      },
      {
        position = "bottom",
        size = 12,
        elements = {
          { id = "repl", size = 0.55 },
          { id = "console", size = 0.45 },
        },
      },
    },
  })

  dap.listeners.before.attach.config_ui = function()
    dapui.open()
  end
  dap.listeners.before.launch.config_ui = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated.config_ui = function()
    dapui.close()
  end
  dap.listeners.before.event_exited.config_ui = function()
    dapui.close()
  end
end

local function setup_keymaps()
  local map = vim.keymap.set

  local function with_session(callback)
    local dap = M.ensure()
    if not dap.session() then
      vim.notify("No active debug session; press <leader>dc to start one", vim.log.levels.WARN)
      return
    end
    callback(dap)
  end

  map("n", "<leader>dc", function()
    M.ensure().continue()
  end, { desc = "Debug continue/start" })
  map("n", "<leader>db", function()
    M.ensure().toggle_breakpoint()
  end, { desc = "Toggle breakpoint" })
  map("n", "<leader>dB", function()
    M.ensure().set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, { desc = "Conditional breakpoint" })
  map("n", "<leader>dn", function()
    M.ensure().step_over()
  end, { desc = "Step over" })
  map("n", "<leader>di", function()
    M.ensure().step_into()
  end, { desc = "Step into" })
  map("n", "<leader>do", function()
    M.ensure().step_out()
  end, { desc = "Step out" })
  map("n", "<leader>dl", function()
    M.ensure().run_last()
  end, { desc = "Run last debug session" })
  map("n", "<leader>dr", function()
    M.ensure().repl.toggle()
  end, { desc = "Toggle debug REPL" })
  map("n", "<leader>dt", function()
    M.ensure().terminate()
  end, { desc = "Terminate debugging" })
  map("n", "<leader>du", function()
    with_session(function()
      require("dapui").toggle()
    end)
  end, { desc = "Toggle debug UI" })
  map({ "n", "v" }, "<leader>de", function()
    with_session(function()
      require("dapui").eval()
    end)
  end, { desc = "Evaluate expression" })
end

function M.ensure()
  if initialized then
    return require("dap")
  end

  -- nvim-dap and dap-ui still call vim.tbl_flatten while creating their log paths.
  -- Use the 0.12 replacement only for their synchronous initialization.
  local original_flatten = vim.tbl_flatten
  vim.tbl_flatten = function(value)
    return vim.iter(value):flatten(math.huge):totable()
  end
  local ok, dap_or_error = xpcall(function()
    require("core.loader").load({ "nvim-nio", "nvim-dap", "nvim-dap-ui" })
    local dap = require("dap")

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticSignInfo", linehl = "Visual" })

    setup_adapters(dap)
    setup_ui(dap)
    return dap
  end, debug.traceback)
  vim.tbl_flatten = original_flatten
  if not ok then
    error(dap_or_error)
  end

  initialized = true
  return dap_or_error
end

function M.setup()
  setup_keymaps()
end

return M
