---
title: Hexo搭建的Github博客提交给Baidu、Google检索的问题
date: 2016-12-17 11:22:13
categories: 技术分享
tags: [Hexo,Baidu,Google]
comments: true
toc: true
---
{% blockquote 庄子，逍遥游 %}
风之积也不厚，则其负大翼也无力，故九万里则风斯在下矣。而后乃今培风，背负青天而莫之夭阙者，而后乃今将图南。
{% endblockquote %}

# 问题描述

本文旨在解决Hexo与github搭建的博客加入Google、Baidu的问题，不会提供从最原始的搭建博客的方法（若你想从头开始搭建，请参考**[@【传送门】](http://tengj.top/2016/02/20/hexo%E5%B9%B2%E8%B4%A7%E7%B3%BB%E5%88%97%EF%BC%9A%EF%BC%88%E6%80%BB%E7%BA%B2%EF%BC%89%E6%90%AD%E5%BB%BA%E7%8B%AC%E7%AB%8B%E5%8D%9A%E5%AE%A2%E5%88%9D%E8%A1%B7/)**）。由于Github屏蔽了百度爬虫抓取Github的网页内容，github上搭建的独立博客无法加入百度检索。

# Sitemap提交方法

中国大陆读者访问google可能有一些问题，利用Lantern可以基本满足建站和提交站点地图的需求。([Lantern](https://lanterncn.cn/))

## Hexo自动生成Sitemap.xml
* 进入Hexo init构建的博客Hexo博客根目录，输入如下命令：
{% codeblock %}
npm install hexo-generator-sitemap --save
npm install hexo-generator-baidu-sitemap --save
{% endcodeblock %}

* 在博客目录的_config.yml中添加如下代码：
{% codeblock %}
##自动生成sitemap
sitemap:
path: sitemap.xml
baidusitemap:
path: baidusitemap.xml
{% endcodeblock %}
* 编译你的博客：
{% codeblock %}
hexo g
{% endcodeblock %}
成功的编译结果应当能在你博客public文件夹下发现sitemap.xml和Baidusitemap.xml两个站点地图文件。若无，请检查_config.yml中冒号后面空格是否存在。

Ps:

1. sitemap中的链接都是以**_config.yml**中的**url**为参考的，所以若您的已为网站绑定了域名，请修改**url**。
2. 若不愿文章进入sitemap的页面，可在文章最上方\---分割的区域内，即front-matter中添加字段
{% codeblock %}
sitemap: false
---
{% endcodeblock %}
3. 此处应当注意，若您的url是以.github.io结尾则代码百度将无法通过sitemap的方法爬取文件

## 验证网站

>验证是证明您对自己声称拥有的网站或应用具有所有权的过程。我们之所以需要确认所有权，是因为一旦您验证了您对某个网站或应用的所有权，您就可以访问该网站或应用的 Google 搜索不公开数据，而且可以影响 Google 搜索抓取它的方式。

**[百度网站检验入口](http://www.sousuoyinqingtijiao.com/baidu/tijiao/)**<br>
**[谷歌网站检验入口](https://www.google.com/webmasters/tools/home?hl=zh-CN)**

### Google验证过程

进入Google Search Console后以Google账号登陆
{% codeblock %}
Google: 添加属性 => 输入您要验证的网站 => 下载HTML验证文件
{% endcodeblock %}
{% asset_img Verification.png  %}
将下载下来的HTML文件放置在博客目录下的Source文件夹中，为HTML文件增加头段:
````````````````````
layout: false
sitemap: false
---
````````````````````
之后部署博客:
``````````````````````````````
hexo clean
hexo g
hexo d
``````````````````````````````
之后便可以开始检测验证是否成功。一般Google验证通过后一两天即可在Google上精确检索到自己的博客。

### Baidu验证过程

进入Baidu站长工具后以百度账号登陆
`````````````````````````````
工具 => 站点管理 => 添加网站 => 验证网站
`````````````````````````````
百度的验证过程与Google过程类似，但时间更长，且爬取成功后百度也不一定收录入检索中，这还取决于百度对您的博客内容的质量评定。

### 收录验证
在Baidu或Google中输入以下代码：
``````````````````````
site:seispider.top
``````````````````````
此处site后的内容请自动换为您自己的网站名。

# Baidu主动提交链接方法

该方法可直接推送.github.io结尾的网页的链接给百度而避免百度无法爬取github中链接的问题。
该方法需要安装hexo插件，参考官方说明**[Hexo插件之百度自动提交链接](http://hui-wang.info/2016/10/23/Hexo%E6%8F%92%E4%BB%B6%E4%B9%8B%E7%99%BE%E5%BA%A6%E4%B8%BB%E5%8A%A8%E6%8F%90%E4%BA%A4%E9%93%BE%E6%8E%A5/)**。

* 在Hexo根目录下，安装本插件：
`````````````````````
npm install hexo-baidu-url-submit --save
`````````````````````
* 配置博客根目录下的_config.yml文件
``````````````````````````````````````
baidu_url_submit:
  count: 3 ## 比如3，代表提交最新的三个链接
  host: www.hui-wang.info ## 在百度站长平台中注册的域名
  token: your_token ## 请注意这是您的秘钥， 请不要发布在公众仓库里!
  path: baidu_urls.txt ## 文本文档的地址， 新链接会保存在此文本文档里
``````````````````````````````````````
{% asset_img Token.png  %}
请参照图片中site与Token后的内容修改_config.yml中的相关变量
* 检查确认_config.yml中的url值与图片中host后的值一致
```````````````````````````````````````
# URL
url: http://www.hui-wang.info
root: /
permalink: :year/:month/:day/:title/
```````````````````````````````````````
* 最后修改deployer

```````````````````````````````````````
deploy:
   type: git
   repo:
```````````````````````````````````````
```````````````````````````````````````
deploy:
 - type: git
   repo:
         your repository
 - type: baidu_url_submitter
```````````````````````````````````````
* 之后进行部署后该插件将自动进行主动推送至百度,如图所示表示推送成功。
{% asset_img Suc.png  %}


# 参考文献
[Hexo插件之百度自动提交链接](http://hui-wang.info/2016/10/23/Hexo%E6%8F%92%E4%BB%B6%E4%B9%8B%E7%99%BE%E5%BA%A6%E4%B8%BB%E5%8A%A8%E6%8F%90%E4%BA%A4%E9%93%BE%E6%8E%A5/)
[嘟嘟独立博客hexo干货系列](http://tengj.top/2016/03/14/hexo6seo/)
[Hexo优化：提交sitemap及解决百度爬虫无法爬取Github Pages 链接问题](http://www.yuan-ji.me/Hexo-%E4%BC%98%E5%8C%96%EF%BC%9A%E6%8F%90%E4%BA%A4sitemap%E5%8F%8A%E8%A7%A3%E5%86%B3%E7%99%BE%E5%BA%A6%E7%88%AC%E8%99%AB%E6%8A%93%E5%8F%96-GitHub-Pages-%E9%97%AE%E9%A2%98/)

# 修改历史
* 2016-12-17：初版
