---
title: Hexo博客中插入数学公式
date: 2017-01-10 21:45:52
categories: 技术分享
tags: [Hexo,MathJax,Tex]
comments: true
toc: true
---
{% blockquote 刘向，战国策 %}
诗云："行百里者半于九十，此言末路之难也。"
{% endblockquote %}
# 问题描述
我们常常需要在博客中使用数学公式，而原生的hexo是不支持数学公式的输入的。故，我们安装插件[hexo-math](https://www.npmjs.com/package/hexo-math)以使用MathJax或Katex对数学公式进行渲染。

# 安装过程
* 在博客的目录下执行如下命令：
```````````
npm install hexo-math --save
```````````
* 在站点根目录下的`__config.yml`中：
``````````````````````
math:
  engine: 'mathjax' # or 'katex'
  mathjax:
    src: custom_mathjax_source
    config:
      # MathJax config
  katex:
    css: custom_css_source
    js: custom_js_source # not used
    config:
      # KaTeX config
``````````````````````
# 使用MathJax渲染公式
我们需要在Markdown文件中添加如下代码：
`````````````````````
<script type="text/javascript"
   src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
`````````````````````
`Tips:`该代码可以添加在markdown文件中的末尾处，其必须自成一段。当该代码位于markdown 文件中其他位置时有可能造成网站首页目录无法正常渲染。
## 使用行间公式
以如下格式输入Tex文本即可：
```````````````
\\( 此处插入公式 \\)
```````````````
**例：**
``````
\begin{aligned}
\dot{x} & = \sigma(y-x) \\
\dot{y} & = \rho x - y - xz \\
\dot{z} & = -\beta z + xy
\end{aligned}
``````
输出为：
{% math %}
\begin{aligned}
\dot{x} & = \sigma(y-x) \\
\dot{y} & = \rho x - y - xz \\
\dot{z} & = -\beta z + xy
\end{aligned}
{% endmath %}

## 使用行内公式
以如下格式输入Tex文本即可：
`````````
\\(此处插入公式 \\)
`````````
**例：**
````````
This is inline \\(a = b + c \\)
````````
输出为：
This is inline \\(a = b + c \\)



# 参考网页
* [hexo-math安装](https://github.com/akfish/hexo-math)
* [如何在markdown中插入公式](http://www.jeyzhang.com/how-to-insert-equations-in-markdown.html)
* [MathJax使用](http://docs.mathjax.org/en/latest/mathjax.html)

# 修改历史
* 2017-01-10： 初稿
* 2017-01-11： 修改了MathJax代码放置位置

<script type="text/javascript"
   src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
