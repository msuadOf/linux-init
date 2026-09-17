#!/bin/sh

find_brew() {
    if command -v brew >/dev/null 2>&1; then
        command -v brew
        return 0
    fi

    case "$(uname -s)" in
        Darwin)
            for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
                [ -x "$candidate" ] && printf '%s\n' "$candidate" && return 0
            done
            ;;
        Linux)
            for candidate in /home/linuxbrew/.linuxbrew/bin/brew "$HOME/.linuxbrew/bin/brew" /usr/local/bin/brew; do
                [ -x "$candidate" ] && printf '%s\n' "$candidate" && return 0
            done
            ;;
    esac

    return 1
}

init_brew() {
    if [ "$#" -ne 1 ]; then
        echo "用法: $0 <shell-config>" >&2
        return 2
    fi

    brew_bin=$(find_brew) || {
        echo "未找到 Homebrew，请先安装 Homebrew" >&2
        return 1
    }

    target=$1
    line="eval \"\$($brew_bin shellenv)\""
    touch "$target"

    if grep -Fqx "$line" "$target"; then
        echo "[OK] Homebrew 初始化已存在于 $target"
    else
        printf '\n%s\n' "$line" >> "$target"
        echo "[OK] 已添加 Homebrew 初始化到 $target"
    fi
}

if [ "${0##*/}" = "homebrew.sh" ]; then
    set -eu
    init_brew "$@"
fi
