-- https://github.com/tami5/lspsaga.nvim
require("lspsaga").setup(
  {
    -- 提示边框样式：round、single、double
    ui = {
      theme = 'round',
      -- border type can be single,double,rounded,solid,shadow.
      border = 'rounded',
      colors = require("catppuccin.groups.integrations.lsp_saga").custom_colors(),
      kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
      error_sign = " ",
      warn_sign = " ",
      hint_sign = " ",
      infor_sign = " ",
      diagnostic_header_icon = " ",
      -- 正在写入的行提示
      --code_action_icon = " ",
    },

    code_action_prompt = {
      -- 显示写入行提示
      -- 如果为 true ，则写代码时会在左侧行号栏中显示你所定义的图标
      enable = true,
      sign = true,
      sign_priority = 40,
      virtual_text = true,
      -- use emoji lightbulb in default
      code_action_icon = "💡",
      -- if true can press number to execute the codeaction in codeaction window
      code_action_num_shortcut = true,
      -- same as nvim-lightbulb but async
      code_action_lightbulb = {
        enable_in_insert = true,
        cache_code_action = true,
        update_time = 150,
      },
      -- show outline
      show_outline = {
        win_position = 'right',
        --set special filetype win that outline window split.like NvimTree neotree
        -- defx, db_ui
        win_with = '',
        win_width = 30,
        auto_enter = true,
        auto_preview = true,
        virt_text = '┃',
        jump_key = 'o',
        -- auto refresh when change buffer
        auto_refresh = true,
      },
    },


    -- 快捷键配置
    code_action_keys = {
      quit = "<Esc>",
      exec = "<CR>"
    },
    rename_action_keys = {
      quit = "<Esc>",
      exec = "<CR>"
    }
  }
)
