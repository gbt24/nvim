local options = {
  encoding = "utf-8",
  list = true,
  hidden = true,
  backup = true,                           -- creates a backup file
  clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
  cmdheight = 1,                           -- keep status bar position close to bottom
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0,                        -- so that `` is visible in markdown files
  fileencoding = "utf-8",                  -- the encoding written to a file
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  mouse = "a",                             -- allow the mouse to be used in neovim
  pumheight = 10,                          -- pop up menu height
  showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
  showtabline = 2,                         -- always show tabs
  smartcase = true,                        -- smart case
  smartindent = true,                      -- make indenting smarter again
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  swapfile = false,                        -- creates a swapfile
  termguicolors = true,                    -- set term gui colors (most terminals support this)
  timeoutlen = 500,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                         -- enable persistent undo
  updatetime = 300,                        -- faster completion (4000ms default)
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  tabstop = 2,                             -- insert 2 spaces for a tab
  cursorline = true,                       -- highlight the current line
  cursorcolumn = false,                    -- cursor column.
  number = true,                           -- set numbered lines
  relativenumber = true,                   -- set relative numbered lines
  numberwidth = 2,                         -- set number column width to 2 {default 4}
  signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  textwidth = 80,
  wrap = true,                            -- !display lines as one long line
  scrolloff = 4,                           -- keep 8 height offset from above and bottom
  sidescrolloff = 4,                       -- keep 8 width offset from left and right
  guifont = "monospace:h17",               -- the font used in graphical neovim applications
  foldmethod = "expr",                     -- fold with nvim_treesitter
  foldexpr = "nvim_treesitter#foldexpr()",
  foldenable = false,                      -- no fold to be applied when open a file
  foldlevel = 99,                          -- if not set this, fold will be everywhere
  spell = false,                            -- add spell support
  spelllang = { 'en_us' },                 -- support which languages?
  diffopt="vertical,filler,internal,context:4",                      -- vertical diff split view
  cscopequickfix="s-,c-,d-,i-,t-,e-",       -- cscope output to quickfix window
}

vim.opt.shortmess:append "c"

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set formatoptions-=cro]] -- TODO: this doesn't seem to work


-- 自动切换输入法（Fcitx5 框架）
vim.g.FcitxToggleInput = function()
    local input_status = tonumber(vim.fn.system("fcitx5-remote"))
    if input_status == 2 then
        vim.fn.system("fcitx5-remote -c")
    end
end
vim.cmd("autocmd InsertLeave * call FcitxToggleInput()")

vim.g.background_transparency = true


vim.api.nvim_exec(
[[
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]],false)

vim.cmd("autocmd BufRead,BufNewFile *.md setlocal spell")

vim.api.nvim_exec(
[[
let g:neoterm_autoscroll = 1
autocmd TermOpen term://* startinsert
tnoremap <C-N> <C-\><C-N>
tnoremap <C-O> <C-\><C-N><C-O>
]],false
)

vim.api.nvim_exec(
[[
silent !mkdir -p $HOME/.config/nvim/tmp/backup
silent !mkdir -p $HOME/.config/nvim/tmp/undo
"silent !mkdir -p $HOME/.config/nvim/tmp/sessions
set backupdir=$HOME/.config/nvim/tmp/backup,.
set directory=$HOME/.config/nvim/tmp/backup,.
if has('persistent_undo')
	set undofile
	set undodir=$HOME/.config/nvim/tmp/undo,.
endif
]],false
)
vim.g.undotree_dir = "$HOME/.config/nvim/tmp/undo"

vim.api.nvim_exec(
[[
set history=2000

if has('nvim') && ! has('win32') && ! has('win64')
	set shada=!,'300,<50,@100,s10,h
else
	set viminfo='300,<10,@50,h,n$DATA_PATH/viminfo
endif

augroup user_persistent_undo
	autocmd!
	au BufWritePre /tmp/*          setlocal noundofile
	au BufWritePre COMMIT_EDITMSG  setlocal noundofile
	au BufWritePre MERGE_MSG       setlocal noundofile
	au BufWritePre *.tmp           setlocal noundofile
	au BufWritePre *.bak           setlocal noundofile
augroup END
]],false
)

vim.api.nvim_exec(
[[
if $SUDO_USER !=# '' && $USER !=# $SUDO_USER
			\ && $HOME !=# expand('~'.$USER)
			\ && $HOME ==# expand('~'.$SUDO_USER)

	if has('nvim')
		set shada="NONE"
	else
		set viminfo="NONE"
	endif
endif
]],false
)

vim.api.nvim_exec(
[[
if has('wildmenu')
	if ! has('nvim')
		set wildmode=list:longest
	endif

	" if has('nvim')
	"		set wildoptions=pum
	" else
	"		set nowildmenu
	"		set wildmode=list:longest,full
	"		set wildoptions=tagfile
	" endif
	set wildignorecase
	set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out,*~,%*
	set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
	set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
	set wildignore+=application/vendor/**,**/vendor/ckeditor/**,media/vendor/**
	set wildignore+=__pycache__,*.egg-info,.pytest_cache,.mypy_cache/**
	set wildcharm=<C-z>  " substitue for 'wildchar' (<Tab>) in macros
endif
]],false
)

vim.cmd("set listchars=tab:»·,nbsp:+,trail:·,extends:→,precedes:←")

vim.cmd("set shortmess+=c")
vim.cmd("set fillchars+=vert:\\|")
vim.cmd("set noruler")


