#!/usr/bin/env bash

set -euo pipefail

get_repo_dir() {
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1
    pwd -P
}

detect_os() {
    case "$(uname -s)" in
        Linux)  echo linux ;;
        Darwin) echo macos ;;
        *)      echo unsupported ;;
    esac
}

# 检测用户的登录 shell，而不是执行本脚本的 bash。
detect_login_shell() {
    local shell_name
    shell_name=$(basename -- "${SHELL:-}")

    case "$shell_name" in
        bash|zsh) echo "$shell_name" ;;
        *)
            echo "不支持的登录 shell: ${SHELL:-未设置}（仅支持 bash/zsh）" >&2
            return 1
            ;;
    esac
}

get_shell_config() {
    case "$(detect_login_shell)" in
        bash) printf '%s\n' "$HOME/.bashrc" ;;
        zsh)  printf '%s\n' "${ZDOTDIR:-$HOME}/.zshrc" ;;
    esac
}

main() {
    local repo_dir shell_file source_line

    repo_dir=$(get_repo_dir)
    shell_file=$(get_shell_config)
    printf -v source_line 'source %q' "${repo_dir}/entryrc"

    echo "OS: $(detect_os)"
    echo "SHELL: $(detect_login_shell)"
    echo "WORK_DIR: $repo_dir"

    mkdir -p -- "$(dirname -- "$shell_file")"
    touch -- "$shell_file"

    if grep -Fqx -- "$source_line" "$shell_file"; then
        echo "[OK] '$source_line' 已存在于 $shell_file"
        return 0
    fi

    printf '\n%s\n' "$source_line" >> "$shell_file"
    echo "[OK] 已添加 '$source_line' 到 $shell_file"
}

main "$@"
