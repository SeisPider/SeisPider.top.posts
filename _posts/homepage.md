---
title: 利用Hugo与GitHub搭建中国科大个人学术主页
date: 2017-12-28 21:03:14
categories: 技术分享
tags: [学术主页]
toc: true
comments: true
---

本文介绍了如何利用Hugo生成静态网页，采用GitHub托管并进行网页版本控制的方法。该方法可以自定义生成任意静态网页，本文主要利用其生成个人主页。


# 简要介绍
个人学术主页是个人的学术名片和学术空间，也是分享学术成果、结识更多同行，扩大学术影响力的有力工具。它同时是科研机构对研究者个人身份的认证。中国科大为每一位科大邮箱用户创建了免费空间并提供免费子域名解析以帮助用户搭建个人主页。（中国科学技术大学个人主页系统服务帮助文档在线版本http://netfee.ustc.edu.cn/faq/index.html#whatiswwwproxy)

Hugo是由Go语言实现的静态网站生成器。它的特点是简单、易用、高效、易扩展和快速部署。其项目主页为：http://www.gohugo.org/。
它是由Steve Francia实现的一个开源静态站点生成工具框架，类似于Jekyll、Octopress或Hexo，都是将特定格式 (最常见的是Markdown格式) 的文本文件转换为静态html文件而生成一个静态站点，多用于个人Blog站点、项目文档(Docker的官方manual Site就是用Hugo生成的)、初创公司站点等。因此也极其适用于个人主页的创建与管理。
(本段引自 http://tonybai.com/2015/09/23/intro-of-gohugo/ )

# 创建过程
本方法涉及的创建过程分成三个主要步骤：1）利用Hugo本地配置站点、编辑内容和生成html文件。2）利用GitHub进行版本控制与远程托管。3）利用travis远程执行代码并更新科大个人主页空间中的内容。

## 本地站点生成
1.	安装Hugo
前往Hugo的GitHub项目主页下载最新版本的Hugo 稳定发行版，目前的最新版本是[0.31.1]( https://github.com/gohugoio/hugo/releases)。选择适合自己操作系统的发行版，之后将Hugo可执行文件的路径加入`$PATH`路径中。
即在.bashrc或.zshrc文件中添加：
`export PATH="your path to hugo:$PATH"`
2.	生成站点
使用Hugo可以快速生成站点，使用Hugo快速生成站点，比如希望生成到 `/path/to/site` 路径：
`$ hugo new site /path/to/site`
这样就在 /path/to/site 目录里生成了初始站点，进去目录：
`$ cd /path/to/site`
3. 站点目录结构为
```
.
├── archetypes
│   └── default.md
├── config.toml
├── content
├── data
├── layouts
├── static
└── themes
```
- `archetypes` 包含了网站生成新页面的基础模版，当没有选择主题时 hugo 会选择上述模版生成页面。
- `config.toml` 全站变量自定义文件
- `content` 存放内容
- `data` 存放额外数据
- `layouts` 模版文件
- `static` 静态文件，生成站点时将直接拷贝到 `public` 下
- `themes` 主题文件夹

4. 自定义站点分布
直接将上述文件夹中的`archetypes`,`data`,`layouts` 删除并下载最新版本的 Hugo `academic` 主题至
themes下。

5. 配置站点信息
直接在`config.toml`文件中修改相关变量可修改站点全局变量及相关表示方法。

# 快捷生成站点
[SeisPider](http://home.ustc.edu.cn/~xiaox17/)在 GitHub 托管并公开了其学术主页。
因此，可以直接利用 `Git` 下载其个人站点并在其基础上作相关修改即可。

1. 下载 SeisPider 的 个人主页站点
```
git clone https://github.com/seispider/Homepage ./
cd Homepage
```
在站点当前目录下执行 `hugo server` 以预览主页。

2. 直接在其站点基础上进行修改即可。


## 站点构成介绍
站点主要由五个主要部分组成
```
.
├── config.toml
├── content
├── public
├── README.md
├── scripts
├── static
└── themes
```

- `config.toml` 全站变量自定义文件, 列出了可以自定义的参数，包括使用的站点， 站点名和主题等全局信息。请参考文件以获得更多自定义修改
- `content` 包含了站点主要内容，包括 `home` 和 `publication` 两个主要文件夹以分别定义将在 `home` 页和 `publication` 页下要展示的内容
- `public` 用 `Hugo` 生成的 `html` 文件
- `README.md` GitHub 仓库说明
- `scripts` 用来构建发表文章列表中的杂志背景页，是 `Python3` 脚本
- `static` 储存 `css` 文件等格式得文件夹，`Hugo` 将直接拷贝该文件夹至 `public` 目录下
- `themes` 主题文件夹

在上述文件目录下修改 `markdown` 文件并执行 `hugo`， 即可获得本地站点且保存在 `public` 文件夹下，将
该文件夹中得内容可以直接拷到科大提供的虚拟空间中，便可实现个人学术主页的构建。


# 版本控制及托管
对个人主页中的文本等进行修改后，我们需要对其进行版本控制并进行远程托管。该方法主要用到了 `Git` 与 `GitHub`，并利用
`travis` 自动执行仓库中的代码并更新科大虚拟空间中的内容。

## 修改远程目标
我们需利用以下命令更改上述从 `SeisPider` 主页下载下来的 `GitHub` 仓库的远程目标。
```
git remote set-url git@github.com:USERNAME/REPOSITORY.git
```
其中 `USERNAME` 是 `GitHub` 帐号，`REPOSITORY` 是仓库名称。
直接前往 `.git` 目录下对 `config` 进行修改也可以改变本地仓库的远程目标。

利用如下代码推送本地站点代码至远程仓库
```
git push origin master
```

## travis 集成站点
利用你的 `GitHub` 帐号关联登陆 `travis` 并对你的远程仓库进行授权。
在 `travis` 下找到你的远程仓库，点击 `more option` 的设置，并设置环境变量。此处将设置你的科大虚拟空间的ftp帐号和密码。
设置环境变量 `USER` 为你的科大邮箱前缀，假如某同学的科大邮箱为 `student@mail.ustc.edu.cn`，则他的 `USER` 为 `student`。设置 `PASSWD` 为科大邮箱的密码。

至此，每次推送本地站点更新到 `GitHub` 后 `travis` 都会自动执行 `.travis.yml` 中的代码。

具体而言，`.travis.yml` 中包含了如下代码：
```
language: generic
sudo: required   # 设置sudoer
env:
  - HUGO_VERSION=0.27   # 设置 Hugo 版本

install:
  - sudo apt-get install lftp  # 安装工具 ftp 工具
  - wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz
  - tar -xvf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz hugo   # 安装 Hugo
  - git submodule update --remote      # 更新主题子模块
script:
  - ./hugo
  - wget -P ./public/ https://raw.githubusercontent.com/SeisPider/CV/master/cv.pdf  # 从你的CV仓库中下载简历
after_success:
  - lftp -c "set ftps:initial-prot ''; open ftp://$USER:$PASSWD@home.ustc.edu.cn:21; mirror -eRv public public_html; quit;"    
  # 将执行hugo 生成的网页同步更新到科大虚拟空间中
```

# 修改历史
- 2017-12-28: 初次版本
