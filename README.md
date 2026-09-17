# linux-init

同时支持 Linux 与 macOS 的 bash/zsh 初始化配置。

## 目录与职责

```text
linux-init/
├── init.sh                 # 安装入口：写入用户 shell 配置
├── entryrc                 # 运行时入口：统一组织加载顺序
├── common/                 # 公共环境、别名、代理和 Homebrew 的 *rc 模块
├── platform/
│   ├── linux/              # Linux 环境、Homebrew 和快照命令
│   └── macos/              # macOS 环境和 Homebrew
├── shell/
│   ├── bash/               # Bash 专用钩子
│   └── zsh/                # Zsh 选项和钩子
├── profiles/               # 按需启用的个人开发环境 *rc 模块
│   └── .ysyxrc
├── scripts/
│   ├── setup/              # 手动执行的安装/配置脚本
│   └── linux/              # Linux Btrfs 可执行工具
└── examples/linux/         # 配置样本与操作笔记
```

`entryrc` 按「common → 当前平台 → 可选 profile → 当前 shell」的顺序显式加载模块。
`common/`、`platform/`、`shell/`、`profiles/` 内由 `entryrc` 加载的配置模块统一以
`*rc` 命名；`scripts/` 内可独立执行的程序统一使用 `.sh`。`examples/` 不参与启动加载。

公共功能放入 `common/`，操作系统差异放入 `platform/<os>/`，shell 选项和钩子放入
`shell/<shell>/`。新增模块时在 `entryrc` 中明确注册，避免依赖文件名排序自动加载。

## 快速开始

```sh
git clone https://gitee.com/msuad/linux-init.git
cd linux-init
./init.sh
```

`init.sh` 根据 `$SHELL` 判断登录 shell：zsh 写入 `~/.zshrc`，bash 写入 `~/.bashrc`。重复执行不会重复添加。

启用调试输出：

```sh
DEBUG=1 bash -c 'source ./entryrc'
DEBUG=1 zsh -c 'source ./entryrc'
```

## Oh My Zsh

安装脚本继续使用 Gitee，并支持 Linux 与 macOS：

```sh
./scripts/setup/oh-my-zsh.sh
./init.sh
```

脚本安装 Powerlevel10k、zsh-autosuggestions 和 zsh-syntax-highlighting。原来的安装命令保留在脚本中，但已注释，不会执行。

## Homebrew

通过 `entryrc` 加载时会自动发现已有 Homebrew。若仅需为其他 shell 配置文件添加
Homebrew 初始化，可单独运行（不负责安装 Homebrew）：

```sh
./scripts/setup/homebrew.sh /path/to/shell-config
```

## 可选 YSYX 环境

Linux 上需要 YSYX、CAD 和 RISC-V 开发环境时，在 `.bashrc` 或 `.zshrc` 中的
`source /path/to/linux-init/entryrc` **之前**添加：

```sh
export LINUX_INIT_ENABLE_YSYX=1
```

默认不加载 `profiles/.ysyxrc`；可以提前设置 `YSYX_HOME` 覆盖工作区位置。

## 代理命令

```sh
on                         # 127.0.0.1:7890
on 8080                    # 127.0.0.1:8080
on 192.168.1.100           # 192.168.1.100:7890
on 192.168.1.100:8080
on 192.168.1.100 8080
off
proxy_test
```

Linux/WSL 会自动尝试使用 WSL 网关地址和端口 7897；macOS 使用本机默认地址。

## 平台说明

- Linux：支持 Linuxbrew、可选的 nix-portable、按需启用的 YSYX 工具链和 Btrfs 快照命令。
- macOS：支持 Apple Silicon `/opt/homebrew` 与 Intel `/usr/local` Homebrew；仅在检测到 JDK 时设置 `JAVA_HOME`；不加载 Btrfs 命令。
- `scripts/linux/` 的 Btrfs 工具和 `examples/linux/` 的示例只适用于 Linux。

## 旧布局迁移

`init.sh` 和 `entryrc` 路径保持不变，已有的 `source /path/to/linux-init/entryrc` 无需修改。
YSYX 环境改为显式启用，见上文。

| 原路径 | 新路径 / 用法 |
| --- | --- |
| 根目录 `.envrc` | `common/.envrc` 和 `common/.aliasrc` |
| 根目录 `.proxyrc` | `common/.proxyrc` |
| `bash/.gitrc`、`zsh/.gitrc` | `shell/<shell>/.gitrc` |
| `zsh/env.sh` | `shell/zsh/.optionsrc` |
| `init_brew.sh` | `scripts/setup/homebrew.sh` |
| `init_oh-my-zsh.sh` | `scripts/setup/oh-my-zsh.sh` |
| `resource/btrfs_*_snapshot.sh` | `scripts/linux/btrfs-*-snapshot.sh` |
| `examples/*` | `examples/linux/`，分区笔记改为 `btrfs-repartition.md` |

根目录旧入口 `.snapshotrc` 以及旧文件 `bash/brew.sh`、`zsh/brew.sh` 已移除，
对应模块统一放在分类目录中并通过 `entryrc` 加载。
空的 `bash/env.sh` 和仅占位的 `platform/macos/snapshot.sh` 也已移除。
