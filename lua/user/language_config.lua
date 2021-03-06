vim.api.nvim_exec(
[[
noremap <A-r> :call CompileRuncode()<CR>
func! CompileRuncode()
  exec "w"
  if &filetype == 'c'
    set splitbelow
    exec "!gcc -std=c99 % -o %<"
    :sp
    :res -8 
    :term ./%<
  elseif &filetype == 'rust'
    set splitbelow
    :sp
    :res -8
    :term cargo run
  elseif &filetype == 'cpp'
    set splitbelow
    exec "!g++ -std=c++11 % -Wall -o %<"
    :sp
    :res -8
    :term ./%<
    exec "!rm -rf ./%<"
  elseif &filetype == 'java'
    exec "!javac %"
    exec "!time java %<"
  elseif &filetype == 'sh'
    :!time bash %
  elseif &filetype == 'python'
    set splitbelow
    :sp
    :res -8
    :term python3 %
  elseif &filetype == 'html'
    silent! exec "!" chromium " % &"
  elseif &filetype == 'markdown'
    exec "MarkdownPreview"
  elseif &filetype == 'tex'
    silent! exec "VimtexStop"
    silent! exec "VimtexCompile"
  elseif &filetype == 'dart'
    exec "CocCommand flutter.run -d ".g:flutter_default_device
    CocCommand flutter.dev.openDevLog
  elseif &filetype == 'javascript'
    set splitbelow
    :sp
    :term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
  elseif &filetype == 'go'
    set splitbelow
    :sp
    :term go run .
  endif
endfunc
]],false
)
