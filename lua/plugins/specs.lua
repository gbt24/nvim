local stable = function(repo, name)
  return {
    src = "https://github.com/" .. repo,
    name = name,
    version = vim.version.range("*"),
  }
end

local branch = function(repo, version, name)
  return {
    src = "https://github.com/" .. repo,
    name = name,
    version = version,
  }
end

return {
  stable("catppuccin/nvim", "catppuccin"),
  branch("nvim-lualine/lualine.nvim", "master"),
  stable("akinsho/bufferline.nvim"),
  stable("folke/which-key.nvim"),
  stable("folke/noice.nvim"),
  stable("MunifTanjim/nui.nvim"),
  branch("nvim-tree/nvim-web-devicons", "master"),
  branch("nvim-lua/plenary.nvim", "master"),

  stable("stevearc/oil.nvim"),

  branch("nvim-treesitter/nvim-treesitter", "main"),
  stable("mason-org/mason.nvim"),
  stable("mason-org/mason-lspconfig.nvim"),
  stable("neovim/nvim-lspconfig"),
  stable("saghen/blink.cmp"),
  branch("rafamadriz/friendly-snippets", "main"),
  stable("folke/lazydev.nvim"),
  stable("stevearc/conform.nvim"),
  branch("mfussenegger/nvim-lint", "master"),

  branch("NMAC427/guess-indent.nvim", "main"),
  stable("nvim-mini/mini.nvim"),
  stable("MagicDuck/grug-far.nvim"),
  branch("lambdalisue/vim-suda", "main", "suda.vim"),

  stable("lewis6991/gitsigns.nvim"),
  branch("sindrets/diffview.nvim", "main"),
  stable("folke/snacks.nvim"),
  stable("nickjvandyke/opencode.nvim"),
}
