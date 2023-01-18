-- https://github.com/terryma/vim-multiple-cursors
-- 关闭默认键位绑定
--vim.g.multi_cursor_use_default_mapping = 0
-- 应用键位
-- 开始选择单词
--vim.g.multi_cursor_start_word_key = "<C-n>"
-- 向后选择
--vim.g.multi_cursor_next_key = "<C-n>"
-- 取消当前选择
--vim.g.multi_cursor_prev_key = "<C-p>"
-- 跳过选择
--vim.g.multi_cursor_skip_key = "<C-b>"
-- 退出选择
--vim.g.multi_cursor_quit_key = "<ESC>"

vim.api.nvim_exec(
[[
let g:VM_leader                     = {'default': ',', 'visual': ',', 'buffer': ','}
let g:VM_maps                       = {}
let g:VM_custom_motions             = {'n': 'h', 'i': 'l', 'u': 'k', 'e': 'j', 'N': '0', 'I': '$', 'h': 'e'}
let g:VM_maps['Find Under']         = '<C-n>'
let g:VM_maps['Find Subword Under'] = '<C-n>'
let g:VM_maps['Find Next']          = ''
let g:VM_maps['Find Prev']          = ''
let g:VM_maps['Remove Region']      = 'q'
let g:VM_maps['Skip Region']        = '<c-q>'
let g:VM_maps["Undo"]               = 'l'
let g:VM_maps["Redo"]               = '<C-r>'
]],false
)
