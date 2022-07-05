---@diagnostic disable: lowercase-global
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  --packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  packer_bootstrap = fn.system({ "git", "clone", "--depth", "1", "https://codechina.csdn.net/mirrors/wbthomason/packer.nvim.git", install_path })
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- vim.cmd [[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerSync
--   augroup end
-- ]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

packer.init {
  max_jobs = 16,
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}



--  useage
-- use {
--   "myusername/example",        -- The plugin location string
--   -- The following keys are all optional
--   disable = boolean,           -- Mark a plugin as inactive
--   as = string,                 -- Specifies an alias under which to install the plugin
--   installer = function,        -- Specifies custom installer. See "custom installers" below.
--   updater = function,          -- Specifies custom updater. See "custom installers" below.
--   after = string or list,      -- Specifies plugins to load before this plugin. See "sequencing" below
--   rtp = string,                -- Specifies a subdirectory of the plugin to add to runtimepath.
--   opt = boolean,               -- Manually marks a plugin as optional.
--   branch = string,             -- Specifies a git branch to use
--   tag = string,                -- Specifies a git tag to use. Supports "*" for "latest tag"
--   commit = string,             -- Specifies a git commit to use
--   lock = boolean,              -- Skip updating this plugin in updates/syncs. Still cleans.
--   run = string, function, or table, -- Post-update/install hook. See "update/install hooks".
--   requires = string or list,   -- Specifies plugin dependencies. See "dependencies".
--   rocks = string or list,      -- Specifies Luarocks dependencies for the plugin
--   config = string or function, -- Specifies code to run after this plugin is loaded.
--   -- The setup key implies opt = true
--   setup = string or function,  -- Specifies code to run before this plugin is loaded.
--   -- The following keys all imply lazy-loading and imply opt = true
--   cmd = string or list,        -- Specifies commands which load this plugin. Can be an autocmd pattern.
--   ft = string or list,         -- Specifies filetypes which load this plugin.
--   keys = string or list,       -- Specifies maps which load this plugin. See "Keybindings".
--   event = string or list,      -- Specifies autocommand events which load this plugin.
--   fn = string or list          -- Specifies functions which load this plugin.
--   cond = string, function, or list of strings/functions,   -- Specifies a conditional test to load this plugin
--   module = string or list      -- Specifies Lua module names for require. When requiring a string which starts
--                                -- with one of these module names, the plugin will be loaded.
--   module_pattern = string/list -- Specifies Lua pattern of Lua module names for require. When
--   requiring a string which matches one of these patterns, the plugin will be loaded.
-- }


return packer.startup(function(use)
  use "wbthomason/packer.nvim"
  use "lewis6991/impatient.nvim" -- Speed up loading Lua modules    TODO: figure out how to use this
  use "yianwillis/vimcdoc"
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use "rcarriga/nvim-notify" -- notify
  use "kyazdani42/nvim-tree.lua"
  use "kyazdani42/nvim-web-devicons"
  use "nvim-lualine/lualine.nvim" -- status line
  use "lewis6991/gitsigns.nvim"
  use "norcalli/nvim-colorizer.lua"
  use "akinsho/toggleterm.nvim"
  use "mbbill/undotree"
  use "folke/todo-comments.nvim" -- todo comments
  use "voldikss/vim-translator"
  use "windwp/nvim-autopairs"
  use "lambdalisue/suda.vim"
  use "simrat39/symbols-outline.nvim" -- outline
  use "lukas-reineke/indent-blankline.nvim"
  use "kevinhwang91/rnvimr"
  use "goolord/alpha-nvim" -- welcome page


  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/nvim-lsp-installer" -- simple to use language server installer
  use "kosayoda/nvim-lightbulb" -- code action
  use "ray-x/lsp_signature.nvim" -- show function signature when typing
  use "tami5/lspsaga.nvim"
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets"


  use {
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "saadparwaiz1/cmp_luasnip" },
      { "f3fora/cmp-spell" }
    }
  }

  use {
    "tpope/vim-commentary",
    ft = { "lua", "c", "h", "cpp", "py", "json", "go", "java", "vim", "hs", "sh" }
  }

    use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use {
    "nvim-treesitter/nvim-treesitter-textobjects",
  } -- enhance texetobject selection
  use "romgrk/nvim-treesitter-context" -- show class/function at the top


  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && yarn install",
    ft = { "markdown" },
  }
  use {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown" },
  }

  use {
    "akinsho/bufferline.nvim",
    requires = {
      "famiu/bufdelete.nvim" -- 删除 buffer 时不影响现有布局
    },
  }

  use {
    "catppuccin/nvim",
    -- 改个别名，因为它的名字是 nvim，可能会冲突
    as = "catppuccin",
  }

  use {
    "projekt0n/github-nvim-theme",
    tag = "v0.0.4",
  }
  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    tag = "nvim-0.6",
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  }
  use "nvim-telescope/telescope-ui-select.nvim"
  use "MattesGroeger/vim-bookmarks"
  use "tom-anders/telescope-vim-bookmarks.nvim"

  use "Shatur/neovim-session-manager"
  use "ahmedkhalf/project.nvim" -- project manager

  use {
    "ur4ltz/surround.nvim",
    ft = { "lua", "c", "h", "cpp", "py", "json", "go", "java", "vim", "hs" },
  }

  -- use {
  --   "RRethy/vim-illuminate",
  --   ft = {"lua", "c", "h", "cpp", "py", "json", "go", "java", "vim", "hs"},
  -- }

  use {
    "mg979/vim-visual-multi",
    ft = { "lua", "c", "h", "cpp", "py", "json", "go", "java", "vim", "hs" },
  }

  if packer_bootstrap then
    require("packer").sync()
  end
end)
