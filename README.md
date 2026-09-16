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
| `<leader>gg` / `<leader>gh` | Git diff / 当前文件历史 |
| `<leader>tf` / `<leader>tb` / `<leader>tr` | 浮动 / 底部 / 右侧终端 |
| `<leader>aa` / `<leader>as` | 询问 OpenCode / OpenCode 操作 |
| `<leader>at` | 切换 OpenCode TUI |
| `<leader>pu` | 检查并审阅插件更新 |

在终端模式下按两次 `<Esc>` 返回 Normal 模式。LSP attach 后可使用 `gd`、`grr`、`K`、`<leader>ca`、`<leader>cr` 和 `<leader>ci`。

使用 `:SudaRead` 和 `:SudaWrite` 显式读取或保存需要管理员权限的文件。配置没有启用 Suda smart edit，因此不会自动触发提权。

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
