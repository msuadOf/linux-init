eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# 添加 Homebrew 的 zsh 补全路径
fpath+=(${HOMEBREW_PREFIX}/share/zsh/site-functions)
autoload -Uz compinit && compinit

export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
