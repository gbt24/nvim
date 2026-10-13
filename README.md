# Neovim IDE 配置

这是一套从零编写的 Neovim 0.12+ 配置。插件由原生 `vim.pack` 管理，使用 Lua 模块组织，并针对 macOS、Linux 和无图形 SSH 终端提供合理降级。

当前仓库位于 `~/.config/nvim`，直接运行 `nvim` 即会加载它。插件和 Mason 工具使用 Neovim 的标准用户数据目录。

## 功能

- Catppuccin Mocha、状态栏、buffer 标签、快捷键提示和诊断面板
- Snacks Explorer、Oil 与 Snacks Picker 文件/文本/符号/诊断搜索
- Aerial 右侧常驻符号大纲，随当前文件自动更新
- Grug Far 项目级搜索替换
- Treesitter 高亮、缩进和折叠
- 自动识别缩进，扩展文本对象和 surround 编辑
- LSP、Blink.cmp、LazyDev、snippets、保存格式化和延迟 lint
- LSP 初始化时请求 `zh-CN`；支持该参数的服务器会优先返回中文内置信息
- Python、TypeScript、C/C++ 与 Lua 断点调试、变量/调用栈检查和调试 REPL
- Python、Lua、JavaScript 与可选 TypeScript 交互式 REPL，可发送行、选区和代码块
- TypeScript、Python、C、C++、Lua 和 Markdown 工具链
- Gitsigns 与 Diffview，只读查看 diff/历史并辅助处理冲突
- 浮动、底部、右侧命名终端
- OpenCode 对话、上下文注入与 agent 编辑审阅
- 通过 Suda 显式读写需要管理员权限的文件

## 前置依赖

必需：

- Neovim 0.12+
- Git、curl
- C 编译器
- tree-sitter CLI 0.26.1 或更高版本，且不要使用 npm 版

推荐：

- ripgrep、fd
- sudo（使用 Suda 时）
- Nerd Font
- OpenCode CLI 1.17+、`pgrep`、`lsof`
- Node.js、Python 3 与 Lua（对应语言的调试/REPL）
- 项目本地 `tsx`（启动 TypeScript 调试）和 `ts-node`（运行 TypeScript 选区）
- Rust/Cargo 1.88+（仅在需要从源码编译 Blink.cmp matcher 时使用；稳定版通常使用预编译库）

系统工具由你自己的包管理器安装；bootstrap 不修改 shell、字体或系统配置，也不处理 OpenCode 登录。

## 初始化

```bash
./scripts/bootstrap.sh
```

该命令会：

1. 通过 `vim.pack` 安装并锁定插件。
2. 尝试编译 Blink.cmp Rust matcher；工具链过旧时明确警告并使用 Lua fallback。
3. 通过 Mason 安装语言服务器、formatter 和 linter。
4. 安装 Treesitter parsers。
5. 执行启动、模块和健康检查。

首次执行需要访问 GitHub、Mason registry 和各工具的发布源。

## 启动

日常使用直接运行：

```bash
nvim
```

需要从任意位置明确加载这份配置时运行：

```bash
./scripts/nvim.sh
```

这个 wrapper 使用 `-u ~/.config/nvim/init.lua`，与日常直接运行 `nvim` 共用同一套插件、Mason 工具、缓存和状态，避免移动配置后产生两套不同的运行环境。

## 检查

```bash
./scripts/check.sh
./scripts/check-languages.sh
```

Neovim 内也可以运行：

```vim
:ConfigHealth
:checkhealth mason
:checkhealth nvim-treesitter
:OpenCodeHealth
```

## 更新与回滚

运行 `:PluginsUpdate` 获取远端信息并查看候选更新。在确认 buffer 中：

- `:write` 应用更新并刷新 `nvim-pack-lock.json`
- `:quit` 放弃更新

更新后运行：

```vim
:ConfigTreesitterUpdate
```

Blink 稳定 tag 默认使用官方预编译 matcher。只有 `:ConfigHealth` 报告 matcher 不可用、且本机有 Rust/Cargo 1.88+ 时，才需要运行 `:ConfigBuildBlink` 从源码构建。

## 项目本地配置

配置已启用 `exrc`，但陌生项目中的 `.nvim.lua` 不会被静默信任。先检查文件内容，再通过 Neovim 的 `:trust` 命令明确允许或拒绝。

如果更新出现问题，先用 Git 恢复 `nvim-pack-lock.json`，再执行 `:PluginsSync` 并确认恢复到锁文件中的 revision。

## 常用快捷键

Leader 键为 `<Space>`。

| 快捷键 | 功能 |
| --- | --- |
| `Ctrl+h/j/k/l` | 向左/下/上/右切换 Neovim 分屏；到边缘后切换 tmux pane |
| `<leader>e` / `<leader>E` | 切换文件树 / 定位当前文件 |
| `<leader>fo` | 使用 Oil 编辑当前目录 |
| `<leader>ff` / `<leader>fg` | 搜索文件 / 搜索文本 |
| `<leader>fn` | 搜索通知历史 |
| `<leader>fR` | 项目级搜索替换；Visual 模式使用选区 |
| `<leader>fs` / `<leader>fS` | 当前文件 / 工作区符号 |
| `<leader>so` | 手动切换右侧符号大纲；打开后随当前文件更新 |
| `<leader>xx` / `<leader>xX` | 搜索工作区 / 当前文件诊断 |
| `<leader>xs` | 搜索当前文件 LSP 符号 |
| `<leader>cf` | 格式化 |
| `<leader>dc` / `<leader>db` | 启动或继续调试 / 切换断点 |
| `<leader>dn` / `<leader>di` / `<leader>do` | 单步越过 / 进入 / 跳出 |
| `<leader>de` / `<leader>du` / `<leader>dt` | 求值 / 切换调试界面 / 停止调试 |
| `<leader>rr` / `<leader>rl` / Visual `<leader>rs` | 切换 REPL / 发送当前行 / 发送选区 |
| `<leader>rb` / `<leader>rn` | 发送当前代码块 / 发送后移至下一块 |
| `<leader>gg` / `<leader>gh` | Git diff / 当前文件历史 |
| `<leader>tf` / `<leader>tb` / `<leader>tr` | 浮动 / 底部 / 右侧终端 |
| `<leader>aa` / `<leader>as` | 询问 OpenCode / OpenCode 操作 |
| `<leader>at` | 切换 OpenCode TUI |
| `<leader>pu` | 检查并审阅插件更新 |

在终端模式下按两次 `<Esc>` 返回 Normal 模式。LSP attach 后可使用 `gd`、`grr`、`K`、`<leader>ca`、`<leader>cr` 和 `<leader>ci`。

`vim-tmux-navigator` 提供 Normal 模式下的统一导航；不在 tmux 内时仍可切换 Neovim 分屏。tmux pane 放大时，导航限制在 Neovim 内，不会自动取消放大。Neovim 内置终端中先按两次 `<Esc>`，再使用导航快捷键。

tmux 端需配置插件官方的智能按键转发，见 [vim-tmux-navigator 安装说明](https://github.com/christoomey/vim-tmux-navigator#tmux)。本机 `~/.tmux.conf` 已包含该配置，修改后可执行 `tmux source-file ~/.tmux.conf` 重新加载。tmux 的 window 切换独立于 pane 导航。

所有语言服务器都会收到标准 LSP `locale = "zh-CN"` 初始化参数。`vtsls` 等支持该参数的服务器可将部分诊断和内置提示本地化；`K` 仍直接显示服务器返回的 hover 内容，因此第三方库的英文注释、Python docstring 和 TypeScript 声明文档不会被自动翻译。Python LSP 使用 Pyright，类型检查级别为 `standard`。

使用 `:SudaRead` 和 `:SudaWrite` 显式读取或保存需要管理员权限的文件。配置没有启用 Suda smart edit，因此不会自动触发提权。

### 调试与运行代码

首次 bootstrap 会通过 Mason 安装 `debugpy`、`js-debug-adapter`、`codelldb` 和
`local-lua-debugger-vscode`。Python 会优先使用项目中的 `.venv` 或 `venv`；TypeScript
调试当前文件要求项目安装 `tsx`，也可以使用 attach 配置连接已经启动的 Node 进程。
C/C++ 调试前应使用 `-g` 编译，并在启动时选择生成的可执行文件。

交互式 REPL 按项目目录隔离。Python 的 `# %%` 或 `#%%` 可作为代码块分隔符。
TypeScript REPL 需要项目本地安装 `ts-node`。C/C++ 不支持脱离编译上下文执行任意选区；
请构建并调试完整程序，或在断点暂停时用 `<leader>de` 求值表达式。

调试快捷键：

| 快捷键 | 功能 |
| --- | --- |
| `<leader>dc` | 启动或继续调试，并选择当前语言的启动配置 |
| `<leader>db` / `<leader>dB` | 切换普通断点 / 添加条件断点 |
| `<leader>dn` / `<leader>di` / `<leader>do` | 单步越过 / 进入 / 跳出 |
| `<leader>dl` | 重复上一次调试会话 |
| `<leader>dr` | 切换 DAP 调试 REPL |
| `<leader>de` | 求值光标下表达式；Visual 模式求值选区 |
| `<leader>du` | 手动切换调试面板 |
| `<leader>dt` | 终止调试 |

`<leader>du` 和 `<leader>de` 需要活动调试会话；尚未启动调试时会显示提示，而不会打开空面板。

交互运行快捷键：

| 快捷键 | 模式 | 功能 |
| --- | --- | --- |
| `<leader>rr` | Normal | 切换当前语言 REPL |
| `<leader>rR` | Normal | 重启当前 REPL |
| `<leader>rf` / `<leader>rh` | Normal | 聚焦 / 隐藏 REPL |
| `<leader>rl` | Normal | 发送当前行 |
| `<leader>rs` | Visual | 发送选区 |
| `<leader>rm{motion}` | Normal | 发送一个 motion 范围 |
| `<leader>rF` | Normal | 发送整个文件 |
| `<leader>rb` / `<leader>rn` | Normal | 发送代码块 / 发送并移动到下一块 |
| `<leader>ri` / `<leader>rq` / `<leader>rc` | Normal | 中断 / 退出 / 清空 REPL |

## 目录结构

```text
init.lua
lua/
├── config/       基础选项、命令、健康检查和验证
├── core/         vim.pack 与加载器
├── languages/    语言、Mason 与 Treesitter 清单
└── plugins/      按功能拆分的插件配置
scripts/          隔离启动、bootstrap 和检查脚本
tests/fixtures/   各语言验证文件
```
