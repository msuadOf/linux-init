# https://www.haoyep.com/posts/zsh-config-oh-my-zsh/

sudo wget -O $ZSH_CUSTOM/themes/haoomz.zsh-theme https://cdn.haoyep.com/gh/leegical/Blog_img/zsh/haoomz.zsh-theme
sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="haoomz"/g' ~/.zshrc

git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's|ZSH_THEME="[^"]*"|ZSH_THEME="powerlevel10k/powerlevel10k"|g' ~/.zshrc

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -i 's/plugins=(*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting z extract web-search)/g' ~/.zshrc