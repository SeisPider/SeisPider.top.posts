---
title: Bash on Ubuntu on windows
date: 2016-11-08 18:15:51
tags: [Bash on Ubuntu on windows,Zsh]
category: 技术分享
toc: true
---
本文旨在介绍Bash Oon Ubuntu on windows 上 oh-my-zsh的安装。

# Bash 安装

安装该bash目前需windows操作系统OS build 晚于14393.0，
按照windows官方给出的**[安装教程](https://msdn.microsoft.com/en-us/commandline/wsl/install_guide)**进行安装即可获得bash on Ubuntu on windows。

## 版本确定

在windows搜索框内输入Bash即可调出Bash on ubuntu  on windows,输入：
```````````````````````````````
cat /etc/issue
```````````````````````````````
可得Ubuntu版本：Ubuntu 14.04.5 LTS \n \1

# oh my zsh

## oh my zsh 安装

Terminator中输入:
````````````````````````````````````````````````
sudo apt-get install zsh
````````````````````````````````````````````````
即可安装Zsh.

输入：

`````````````````````````````````````````````````````````````````````````
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

`````````````````````````````````````````````````````````````````````````
Oh my zsh 安装完毕后可执行
`````````````````````````````````````````````````````````````````````````
sudo chsh -s /bin/zsh
`````````````````````````````````````````````````````````````````````````
改变本用户的默认shell版本。

或

在 ~/.bashrc配置文件末尾添加exec /bin/zsh 改变shell。

## oh my zsh 配置

调出~/.zshrc文件，在其中选择主题和插件。

主题参考网址：https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

插件参考网址：https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins

# 修改历史

* 2016-11-8：添加Bash on Ubuntu on windows与Zsh安装
