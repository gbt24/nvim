---Useful plugin to show you pending keybinds.

local custom = require 'gbt24.config.custom'

---@type LazyPluginSpec
return {
    ---@module "which-key"
    'folke/which-key.nvim',
    event = 'VeryLazy', -- Sets the loading event to 'VimEnter'
    ---@type wk.Opts
    opts = {
        preset = 'modern',
        win = {
            border = custom.border,
        },
        spelling = {
            enabled = true, -- enableing this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 21, -- how many suggestions should be shown in the list
        },
        icons = {
            breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
            separator = '', -- symbol used between a key and it's label
            group = '+', -- symbol prepended to a group
            -- mappings = false, -- disable all mappings icons
            ---@type wk.IconRule[]
            rules = {
                -- Verbs
                { pattern = 'insert', icon = ' ', color = 'cyan' },
                { pattern = 'create', icon = ' ', color = 'purple' },
                { pattern = 'new', icon = ' ', color = 'purple' },
                { pattern = 'run', icon = ' ', color = 'green' },
                { pattern = 'launch', icon = ' ', color = 'green' },
                { pattern = 'close', icon = ' ', color = 'red' },
                { pattern = 'stop', icon = ' ', color = 'red' },
                { pattern = 'reset', icon = ' ', color = 'grey' },
                { pattern = 'restore', icon = ' ', color = 'grey' },
                { pattern = 'reload', icon = ' ', color = 'grey' },
                { pattern = 'open', icon = ' ', color = 'green' },
                { pattern = 'delete', icon = ' ', color = 'blue' },
                { pattern = 'top', icon = ' ', color = 'grey' },
                { pattern = 'up', icon = ' ', color = 'grey' },
                { pattern = 'bottom', icon = ' ', color = 'grey' },
                { pattern = 'down', icon = ' ', color = 'grey' },
                { pattern = 'left', icon = ' ', color = 'grey' },
                { pattern = 'right', icon = ' ', color = 'grey' },
                { pattern = 'switch', icon = ' ', color = 'grey' },
                { pattern = 'move', icon = ' ', color = 'grey' },
                { pattern = 'rename', icon = '󰑕', color = 'cyan' },
                -- Nouns
                { pattern = 'fold', icon = ' ', color = 'azure' },
                { pattern = 'color', icon = ' ', color = 'red' },
                { pattern = 'highlight', icon = ' ', color = 'red' },
                { pattern = 'tree', icon = ' ', color = 'green' },
                { pattern = 'mark', icon = ' ', color = 'yellow' },
                { pattern = 'task', icon = ' ', color = 'green' },
                { pattern = 'help', icon = '󰘥 ', color = 'cyan' },
                { pattern = 'info', icon = ' ', color = 'cyan' },
                { pattern = 'blame', icon = ' ', color = 'cyan' },
                { pattern = 'program', icon = ' ', color = 'azure' },
                { pattern = 'plugin', icon = ' ', color = 'azure' },
                { pattern = 'package', icon = ' ', color = 'yellow' },
                { pattern = 'lsp', icon = ' ', color = 'red' },
                { pattern = 'test', icon = ' ', color = 'yellow' },
                { pattern = 'manage', icon = ' ', color = 'orange' },
                { pattern = 'outline', icon = ' ', color = 'purple' },
                { pattern = 'symbol', icon = ' ', color = 'orange' },
                { pattern = 'annotation', icon = ' ', color = 'grey' },
                { pattern = 'comment', icon = ' ', color = 'grey' },
                { pattern = 'term', icon = ' ', color = 'cyan' },
                { pattern = 'grep', icon = ' ', color = 'orange' },
                { pattern = 'quickfix', icon = ' ', color = 'yellow' },
                { pattern = 'list', icon = ' ', color = 'yellow' },
                { pattern = 'workspace', icon = ' ', color = 'yellow' },
                { pattern = 'regex', icon = ' ', color = 'yellow' },
                { pattern = 'file manager', icon = '', color = 'green' },
                -- Override default
                { plugin = 'nvim-spectre', icon = ' ', color = 'blue' },
                { pattern = 'file', icon = ' ', color = 'cyan' },
                { pattern = 'debug', icon = ' ', color = 'red' },
                { pattern = 'find', icon = ' ', color = 'green' },
                { pattern = 'search', icon = ' ', color = 'green' },
                { pattern = 'session', icon = ' ', color = 'azure' },
                { pattern = 'format', icon = ' ', color = 'cyan' },
                { pattern = 'tab', icon = ' ', color = 'purple' },
                { pattern = 'buffer', icon = ' ', color = 'purple' },
                { pattern = 'window', icon = ' ', color = 'purple' },
            },
        },
        spec = {
            { '<leader>b', group = 'Buffer' },
            { '<leader>c', group = 'Code' },
            --{ '<leader>d', group = 'Debug' },
            { '<leader>f', group = 'Fuzzy Search' },
            { '<leader>fd', group = 'Fuzzy Search Debug' },
            { '<leader>fg', group = 'Fuzzy Search Git' },
            { '<leader>g', group = 'Git' },
            { '<leader>gd', group = 'Git Diff' },
            { '<leader>l', group = 'LSP' },
            { '<leader>n', group = 'Neotree' },
            { '<leader>p', group = 'Program' },
            { '<leader>r', group = 'Run' },
            { '<leader>s', group = 'Search' },
            { '<leader>S', group = 'Session' },
            { '<leader>t', group = 'Toggle' },
            { '<leader>T', group = 'Test' },
            { '<leader>w', group = 'Workspace' },
            { '<leader>h', group = 'Git Hunk', mode = 'v' },
        },
    },
}
