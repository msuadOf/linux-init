eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
else
    # 旧版本 Homebrew 的路径(但似乎这个才是正道)
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
        [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
fi

export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles