#!/bin/bash

get_dir_name() {
  echo $(dirname $(realpath $0))
}

get_shell_config() {
    local shell_type=$(basename "$SHELL")
    
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
            # 默认尝试bashrc
            if [ -f "$HOME/.bashrc" ]; then
                echo "$HOME/.bashrc"
            elif [ -f "$HOME/.zshrc" ]; then
                echo "$HOME/.zshrc"
            else
                echo "$HOME/.profile"  # 最后退路
            fi
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