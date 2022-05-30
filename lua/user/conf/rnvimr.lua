vim.api.nvim_exec(
[[
let g:rnvimr_ex_enable = 1
let g:rnvimr_pick_enable = 1
" let g:rnvimr_bw_enable = 1
highlight link RnvimrNormal CursorLine
let g:rnvimr_action = {
            \ '<C-t>': 'NvimEdit tabedit',
            \ '<C-b>': 'NvimEdit split',
            \ '<C-r>': 'NvimEdit vsplit',
            \ 'gw': 'JumpNvimCwd',
            \ 'yw': 'EmitRangerCwd'
            \ }
let g:rnvimr_layout = { 'relative': 'editor',
            \ 'width': &columns,
            \ 'height': &lines,
            \ 'col': 0,
            \ 'row': 0,
            \ 'style': 'minimal' }
let g:rnvimr_presets = [{'width': 0.8, 'height': 0.8}]
]],false
)
