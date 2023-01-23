---@diagnostic disable: unused-local
-- leader 键设置为空格
vim.g.mapleader = " "

-- 默认的键位设置函数太长了，所以这里将它们重新引用一下
local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap


keymap("n", "<A-v>", "<C-v>", opts)

keymap("x", "<", "<gv", opts)
keymap("x", ">", ">gv", opts)
keymap("n", "cw", "bcw", opts)

keymap("n", "K", "5k", opts)
keymap("n", "J", "5j", opts)
keymap("n", "H", "5h", opts)
keymap("n", "L", "5l", opts)
keymap("n", "<C-a>", "$", opts)

keymap("n", "<Leader><cr>", ":nohlsearch<CR>", opts)
keymap("n", "=", "n", opts)
keymap("n", "-", "N", opts)
keymap("n", "W", ":w<cr>", opts)
keymap("n", "Q", ":q<cr>", opts)

keymap("n", "<Leader>sw", "<C-w>o", opts)
keymap("n", "sl", ":set splitright<CR>:vsplit<CR>", opts)
keymap("n", "sh", ":set splitright<CR>:vsplit<CR>", opts)
keymap("n", "sk", ":set nosplitbelow<CR>:split<CR>", opts)
keymap("n", "sj", ":set splitbelow<CR>:split<CR>", opts)
keymap("n", "s<down>", ":res +5<CR>", opts)
keymap("n", "s<up>", ":res -5<CR>", opts)
keymap("n", "s<right>", ":vertical resize-5<CR>", opts)
keymap("n", "s<left>", ":vertical resize+5<CR>", opts)
keymap("n", "<A-l>", "<C-w>l", opts)
keymap("n", "<A-h>", "<C-w>h", opts)
keymap("n", "<A-k>", "<C-w>k", opts)
keymap("n", "<A-j>", "<C-w>j", opts)
keymap("n", "<Leader>tl", ":tabNext<CR>", opts)
keymap("n", "<Leader>th", ":tabprevious<CR>", opts)
keymap("n", "<Leader>tc", ":tabclose<CR>", opts)
keymap("n", "<Leader>tn", ":tabnew<CR>", opts)

--keymap("n", "<Leader>ra", "<cmd>RnvimrToggle<CR>", opts)
keymap("n", "<Leader>gi", ":!touch .gitignore<CR><CR>", opts)
keymap("n", "<LEADER>sc", ":set spell!<CR>", opts)
keymap("n", "<C-x>", "ea<C-x>s", opts)
keymap("i", "<C-x>", "<Esc>ea<C-x>s", opts)
keymap("n", "Y", "\"+y", opts)



-- Bufferline
-- 关闭当前 buffer，由 bufdelete 插件所提供的方法
keymap("n", "<Leader><Tab>", "<cmd>Bdelete!<CR>", opts)
-- 切换上一个缓冲区
keymap("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", opts)
-- 切换下一个缓冲区
keymap("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", opts)
-- 将缓冲区移至下一个位置
keymap("n", "<A->>", "<cmd>BufferLineMoveNext<cr>", opts)
-- 将缓冲区移至上一个位置
keymap("n", "<A-<>", "<cmd>BufferLineMovePrev<cr>", opts)
-- 关闭左侧缓冲区
keymap("n", "<leader>bh", "<cmd>BufferLineCloseLeft<CR>", opts)
-- 关闭右侧缓冲区
keymap("n", "<leader>bl", "<cmd>BufferLineCloseRight<CR>", opts)


-- nvim-notify
-- 显示历史弹窗记录
keymap(
  "n",
  "<leader>fn",
  "<cmd>lua require('telescope').extensions.notify.notify()<CR>",
  opts
)


-- nvim-tree
-- 按 tt 打开文件树
keymap("n", "tt", "<cmd>NvimTreeToggle<CR>", opts)
-- 按 leader fc 在文件树中找到当前以打开文件的位置
keymap("n", "<leader>fc", "<cmd>NvimTreeFindFile<CR>", opts)

-- symbols-outline
keymap("n", "<Leader>v", "<cmd>Lspsaga outline<CR>", opts)

-- Telescope
-- 查找文件
keymap("n", "<A-f>", "<cmd>Telescope find_files<CR>", opts)
-- 查找文字
keymap("n", "<A-G>", "<cmd>Telescope live_grep<CR>", opts)
keymap("n", "<A-g>", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts)
-- 查找特殊符号
keymap("n", "<A-p>", "<cmd>lua require('telescope').extensions.projects.projects(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
-- 查找最近打开的文件
keymap("n", "<A-o>", "<cmd>Telescope oldfiles<CR>", opts)
-- 查找 bookmarks 标记
keymap("n", "<Leader>m", "<cmd>Telescope vim_bookmarks current_file<cr>", opts)
keymap("n", "<Leader>M", "<cmd>Telescope vim_bookmarks all<cr>", opts)
-- 查看可用主题
keymap("n", "<A-c>", "<cmd>Telescope colorscheme<CR>", opts)
-- 查看可用命令
keymap("n", "<A-C>", "<cmd>Telescope commands<CR>", opts)

-- Sessionmanager
keymap("n", "<C-s>", "<cmd>SessionManager save_current_session<cr>", opts)
keymap("n", "<C-o>", "<cmd>SessionManager load_session<cr>", opts)
keymap("n", "<C-d>", "<cmd>SessionManager delete_session<cr>", opts)

-- todo-comment
keymap("n", "<leader>td", "<cmd>TodoTelescope<CR>", opts)

-- Gitsigns
-- Navigation
--keymap('n', '<leader>j', ':Gitsigns next_hunk<CR>', opts)
--keymap('n', '<leader>k', ':Gitsigns prev_hunk<CR>', opts)
--
---- Actions
--keymap('n', '<leader>hs', ':Gitsigns stage_hunk<CR>', opts)
--keymap('n', '<leader>hr', ':Gitsigns reset_hunk<CR>', opts)
--keymap('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>', opts)
--keymap('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>', opts)
--keymap('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>', opts)
--keymap('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>', opts)
--keymap('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', opts)
----keymap('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>',opts)
--keymap('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>', opts)
--keymap('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>', opts)
----keymap('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>',opts)


-- Bookmarks
keymap("n", "<A-m>", "<cmd>BookmarkToggle<cr>", opts)

-- Toggleterm
-- 退出终端插入模式
keymap("t", "<Esc>", "<C-\\><C-n><cmd>q<cr>", opts)
-- 打开普通终端
keymap("n", "<leader>tt", "<cmd>exe v:count.'ToggleTerm'<CR>", opts)
-- 打开浮动终端
keymap("n", "<leader>tf", "<cmd>lua require('toggleterm').float_toggle()<CR>", opts)
-- 打开lazy git 终端
keymap("n", "<C-g>", "<cmd>lua require('toggleterm').lazygit_toggle()<CR>", opts)
-- 打开或关闭所有终端
keymap("n", "<leader>ta", "<cmd>ToggleTermToggleAll<CR>", opts)
-- 要需创建多个终端，可：
-- 1 <键位> leader tt
-- 2 <键位>
-- ... <键位>
-- 另外，上面我们新建了 2 个特殊终端，所以普通终端的顺序应该是从 3 开始
