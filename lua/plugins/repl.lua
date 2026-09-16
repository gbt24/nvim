local M = {}

local function project_root(bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr or 0)
  local start = file ~= "" and vim.fs.dirname(file) or vim.uv.cwd()
  return vim.fs.root(start, { "pyproject.toml", "package.json", ".git" }) or vim.uv.cwd()
end

local function python_command(meta)
  local root = project_root(meta.current_bufnr)
  local candidates = {
    vim.fs.joinpath(root, ".venv", "bin", "python"),
    vim.fs.joinpath(root, "venv", "bin", "python"),
    vim.env.VIRTUAL_ENV and vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python") or nil,
    vim.env.CONDA_PREFIX and vim.fs.joinpath(vim.env.CONDA_PREFIX, "bin", "python") or nil,
    vim.fn.exepath("python3"),
    vim.fn.exepath("python"),
  }
  for _, candidate in ipairs(candidates) do
    if candidate and candidate ~= "" and vim.fn.executable(candidate) == 1 then
      return { candidate }
    end
  end
  return { "python3" }
end

local function typescript_command(meta)
  local local_ts_node = vim.fs.joinpath(project_root(meta.current_bufnr), "node_modules", ".bin", "ts-node")
  if vim.fn.executable(local_ts_node) == 1 then
    return { local_ts_node }
  end

  local global_ts_node = vim.fn.exepath("ts-node")
  if global_ts_node ~= "" then
    return { global_ts_node }
  end

  vim.notify("TypeScript REPL requires project-local ts-node", vim.log.levels.ERROR)
  return { "sh", "-c", "printf 'Install ts-node in this project to use the TypeScript REPL.\\n' >&2; exit 127" }
end

function M.setup()
  require("core.loader").load("iron.nvim")
  local iron = require("iron.core")
  local common = require("iron.fts.common")

  iron.setup({
    config = {
      scratch_repl = true,
      close_window_on_exit = true,
      dap_integration = true,
      repl_definition = {
        python = {
          command = python_command,
          format = common.bracketed_paste_python,
          block_dividers = { "# %%", "#%%" },
          env = { PYTHON_BASIC_REPL = "1" },
        },
        lua = { command = { "lua" } },
        javascript = { command = { "node" } },
        typescript = {
          command = typescript_command,
          open = ".editor\n",
          close = "\4",
        },
      },
      repl_open_cmd = require("iron.view").bottom(15),
    },
    keymaps = {
      toggle_repl = "<leader>rr",
      restart_repl = "<leader>rR",
      send_motion = "<leader>rm",
      visual_send = "<leader>rs",
      send_file = "<leader>rF",
      send_line = "<leader>rl",
      send_code_block = "<leader>rb",
      send_code_block_and_move = "<leader>rn",
      interrupt = "<leader>ri",
      exit = "<leader>rq",
      clear = "<leader>rc",
    },
    highlight = { italic = true },
    ignore_blank_lines = true,
  })

  vim.keymap.set("n", "<leader>rf", "<cmd>IronFocus<cr>", { desc = "Focus REPL" })
  vim.keymap.set("n", "<leader>rh", "<cmd>IronHide<cr>", { desc = "Hide REPL" })
end

return M
