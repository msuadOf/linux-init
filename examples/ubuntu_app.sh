#! /bin/sh
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-modify flathub --url=https://mirrors.ustc.edu.cn/flathub
sudo apt install curl git flatpak gnome-software-plugin-flatpak vim wget openssh-server -y
sudo flatpak install com.microsoft.Edge com.qq.QQ  com.tencent.WeChat  org.telegram.desktop \
  com.discordapp.Discord com.tencent.wemeet com.qq.QQmusic com.ranfdev.DistroShelf
