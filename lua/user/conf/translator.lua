vim.cmd(
[[
nmap <silent> <Leader>d <Plug>TranslateW
vmap <silent> <Leader>d <Plug>TranslateWV
let g:translator_window_max_height=0.3
let g:translator_window_max_width=0.3
let g:translator_default_engines=['youdao' , 'bing']
]],false
)
