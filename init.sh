#!/bin/bash

get_dir_name() {
  echo $(dirname $(realpath $0))
}
# 检测当前运行的 shell
detect_shell() {
    if [ -n "$BASH_VERSION" ]; then
        echo bash
    elif [ -n "$ZSH_VERSION" ]; then
        echo zsh
    else
        # fallback 方法（适用于 Linux）
        basename "$(readlink /proc/$$/exe 2>/dev/null)" || echo unknown
    fi
}
get_shell_config() {
    local shell_type=$(detect_shell)
    
    case $shell_type in
        bash)
            echo "$HOME/.bashrc"
            ;;
        zsh)
            echo "$HOME/.zshrc"
            ;;
        fish)
            echo "$HOME/.config/fish/config.fish"
            ;;
        ksh)
            echo "$HOME/.kshrc"
            ;;
        tcsh)
            echo "$HOME/.tcshrc"
            ;;
        *)
			return 1
            ;;
    esac
}

main() {
  WORK_DIR=$(get_dir_name $0)
  echo "WORK_DIR: ${WORK_DIR}"
  
  local SHELL_FILE=$(get_shell_config) #类似于 /home/xx/.bashrc
  SEARCH_STRING="source ${WORK_DIR}/entryrc"
  
  # 检查文件是否包含字符串
  if grep -q "$SEARCH_STRING" "$SHELL_FILE"; then
    echo "[OK]$0: '$SEARCH_STRING' 在 $SHELL_FILE 中已存在"
  else
    echo "$0: '$SEARCH_STRING' 在 $SHELL_FILE 中未找到"
	echo "正在添加 $SEARCH_STRING 到 $SHELL_FILE 中..."
    echo " + echo \"$SEARCH_STRING\" > $SHELL_FILE"
	echo "source ${WORK_DIR}/entryrc" >> $SHELL_FILE
  fi



}

main $@