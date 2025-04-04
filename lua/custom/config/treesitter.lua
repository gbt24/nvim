---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'bash',
    'python',
    'cpp',
    'c',
    'diff',
    'html',
    'xml',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
    'snakemake',
  },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { 'ruby' },
  },
  disable = function(lang, bufnr)
    return lang == 'yaml' and vim.api.nvim_buf_line_count(bufnr) > 5000
  end,
  indent = { enable = true, disable = { 'ruby' } },
}
