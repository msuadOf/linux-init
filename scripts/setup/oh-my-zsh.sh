#!/bin/sh
# 安装并配置 Oh My Zsh、主题和插件。

set -eu

# 以下是原始命令：按要求仅注释保留，不删除。
# https://www.haoyep.com/posts/zsh-config-oh-my-zsh/
# sh -c "$(curl -fsSL https://gitee.com/pocmon/ohmyzsh/raw/master/tools/install.sh)"
# sh -c "$(wget -O- https://gitee.com/pocmon/ohmyzsh/raw/master/tools/install.sh)"

# sudo wget -O $ZSH_CUSTOM/themes/haoomz.zsh-theme https://cdn.haoyep.com/gh/leegical/Blog_img/zsh/haoomz.zsh-theme
# sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="haoomz"/g' ~/.zshrc

# git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# sed -i 's|ZSH_THEME="[^"]*"|ZSH_THEME="powerlevel10k/powerlevel10k"|g' ~/.zshrc

# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# sed -i 's/plugins=([^)]*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting z extract web-search)/g' ~/.zshrc

# 处理ll、la命令
# sed -i "s|alias ll='[^']*'|alias ll='ls -alFh'|g" ~/.oh-my-zsh/lib/directories.zsh
# sed -i "s|alias la='[^']*'|alias la='ls -AFh'|g" ~/.oh-my-zsh/lib/directories.zsh
# sed -i "s|alias l='[^']*'|alias l='ls -CFh'|g" ~/.oh-my-zsh/lib/directories.zsh

OH_MY_ZSH_INSTALL_URL=https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh
OH_MY_ZSH_REMOTE=https://gitee.com/mirrors/oh-my-zsh.git
ZSH_DIR=${ZSH:-$HOME/.oh-my-zsh}
ZSH_CUSTOM_DIR=${ZSH_CUSTOM:-$ZSH_DIR/custom}
ZSHRC=${ZDOTDIR:-$HOME}/.zshrc

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "缺少必要命令: $1" >&2
        exit 1
    fi
}

clone_if_missing() {
    repo=$1
    target=$2

    if [ -d "$target/.git" ]; then
        echo "[SKIP] 已存在: $target"
        return 0
    fi

    git clone --depth=1 "$repo" "$target"
}

require_command curl
require_command git
require_command zsh

if [ ! -d "$ZSH_DIR" ]; then
    ZSH=$ZSH_DIR REMOTE=$OH_MY_ZSH_REMOTE RUNZSH=no CHSH=no \
        sh -c "$(curl -fsSL "$OH_MY_ZSH_INSTALL_URL")" "" --unattended
else
    echo "[SKIP] Oh My Zsh 已存在: $ZSH_DIR"
fi

mkdir -p "$ZSH_CUSTOM_DIR/themes" "$ZSH_CUSTOM_DIR/plugins"

clone_if_missing \
    https://gitee.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM_DIR/themes/powerlevel10k"
clone_if_missing \
    https://gitee.com/mirrors/zsh-autosuggestions.git \
    "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
clone_if_missing \
    https://gitee.com/mirrors/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"

if [ ! -f "$ZSHRC" ]; then
    echo "未找到 ${ZSHRC}，Oh My Zsh 安装未生成配置文件" >&2
    exit 1
fi

if ! grep -q '^ZSH_THEME=' "$ZSHRC" || ! grep -q '^plugins=' "$ZSHRC"; then
    echo "${ZSHRC} 缺少 ZSH_THEME 或单行 plugins 配置，请手动配置" >&2
    exit 1
fi

if grep -Fqx 'ZSH_THEME="powerlevel10k/powerlevel10k"' "$ZSHRC" && \
   grep -Fqx 'plugins=(git z extract web-search zsh-autosuggestions zsh-syntax-highlighting)' "$ZSHRC"; then
    echo "[SKIP] ${ZSHRC} 已是目标配置"
else
    # -i.bak 同时兼容 GNU sed 和 macOS BSD sed，并保留修改前备份。
    sed -i.bak \
        -e 's|^ZSH_THEME=.*$|ZSH_THEME="powerlevel10k/powerlevel10k"|' \
        -e 's|^plugins=.*$|plugins=(git z extract web-search zsh-autosuggestions zsh-syntax-highlighting)|' \
        "$ZSHRC"
    echo "[INFO] 修改前配置备份: ${ZSHRC}.bak"
fi

echo "[OK] Oh My Zsh、主题和插件已通过 Gitee 配置完成"
