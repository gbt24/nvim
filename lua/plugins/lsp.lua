local M = {}

local function with_chinese_locale(config)
  local before_init = config.before_init
  config.before_init = function(params, client_config)
    if before_init then
      before_init(params, client_config)
    end
    params.locale = "zh-CN"
  end
  return config
end

local function on_attach(event)
  local buffer = event.buf
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = buffer, desc = desc })
  end

  map("gd", vim.lsp.buf.definition, "Go to definition")
  map("gD", vim.lsp.buf.declaration, "Go to declaration")
  map("grr", Snacks.picker.lsp_references, "References")
  map("gri", vim.lsp.buf.implementation, "Implementations")
  map("gy", vim.lsp.buf.type_definition, "Type definition")
  map("K", vim.lsp.buf.hover, "Hover documentation")
  map("<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
  map("<leader>cs", vim.lsp.buf.signature_help, "Signature help")
  map("<leader>ci", function()
    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buffer })
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = buffer })
  end, "Toggle inlay hints")

  if client and client:supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
  end

  map("]r", function()
    Snacks.words.jump(vim.v.count1)
  end, "Next reference")
  map("[r", function()
    Snacks.words.jump(-vim.v.count1)
  end, "Previous reference")
end

function M.setup()
  require("core.loader").load({ "mason.nvim", "mason-lspconfig.nvim", "nvim-lspconfig" })

  require("mason").setup({
    ui = { border = "rounded" },
  })
  require("mason-lspconfig").setup({ automatic_enable = false })

  local capabilities = require("blink.cmp").get_lsp_capabilities()
  capabilities.workspace = capabilities.workspace or {}
  capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = false }
  local configs = {
    vtsls = {
      capabilities = capabilities,
      settings = {
        typescript = { inlayHints = { parameterNames = { enabled = "literals" } } },
        javascript = { inlayHints = { parameterNames = { enabled = "literals" } } },
      },
    },
    eslint = {
      capabilities = capabilities,
      settings = { workingDirectory = { mode = "auto" } },
    },
    basedpyright = {
      capabilities = capabilities,
      settings = {
        basedpyright = {
          analysis = { typeCheckingMode = "standard", autoImportCompletions = true },
        },
      },
    },
    clangd = {
      capabilities = capabilities,
      cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
    },
    lua_ls = {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim", "Snacks" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    },
    marksman = { capabilities = capabilities },
  }

  for name, config in pairs(configs) do
    vim.lsp.config(name, with_chinese_locale(config))
  end
  vim.lsp.enable(require("languages").servers)

  vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = false,
    underline = true,
    virtual_text = { spacing = 2, source = "if_many" },
    float = { border = "rounded", source = true },
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("ConfigLspAttach", { clear = true }),
    callback = on_attach,
  })

  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, { desc = "Previous diagnostic" })
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, { desc = "Next diagnostic" })
  vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
end

return M
