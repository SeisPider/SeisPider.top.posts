---
title: ObsPy-安装
date: 2017-01-06 08:29:39
categories: ObsPy学习笔记
tags: [ObsPy,Anaconda,CentOS]
toc: ture
comments: true
---
{% blockquote 孔子，论语 %}
子贡问为仁。子曰：“工欲善其事，必先利其器”。居是邦也，事其大夫之贤者，友其士之仁者。
{% endblockquote %}

# 问题描述
本文旨在利用Anaconda,Pyenv安装ObsPy。

# ObsPy安装
Pyenv 是一款Python多版本管理工具。它利用Python解释器基于site的特点，将多版本Python分别安装在不同文件夹下，从而实现多版本Python管理。其提供了一系列命令对Python运行环境进行管理。本人笔记本运行环境为CentOS 7 并安装[Pyenv](http://seisman.info/python-pyenv.html)管理多版本Python。

Anaconda是一个专供科研使用的Python发行包，其中集合了所有重要的Python科学计算模块及其相关依赖。Anaconda是**独立于现有系统**进行安装的。因此，用户无需担心安装破坏当前的Python环境。

**Anaconda的安装并不要求用户具备管理员权限**

* [Anaconda](https://www.continuum.io/downloads)安装
* 将`conda-forge`和`obspy`通道加入你的Anaconda配置中:
{% codeblock %}
$ conda config --add channels conda-forge
$ conda config --add channels obspy
{% endcodeblock %}
* 安装已在Anaconda云库中预编译过的ObsPy版本:
{% codeblock %}
$ conda install obspy
{% endcodeblock %}

**`Tips`**：
* Anaconda安装仅需要以你所用的`shell`执行安装脚本即可，最后需要用户确认是否将Anaconda加入环境变量，默认的是加入至.bashrc中。若用户使用的是zsh则需要选择`No`并在.zshrc末尾加上`export PATH="$HOME/anaconda2/bin:$PATH"`anaconda2为用户安装路径。其他版本shell同理
* 安装Anaconda过程中出现任何问题请参考[`Troubleshooting`](http://conda.pydata.org/docs/troubleshooting.html)

# 版本升级
{% codeblock %}
$ conda update obspy
{% endcodeblock %}
若用户并未将`conda-forge`添加为默认通道，则执行如下代码：
{% codeblock %}
$ conda update -c conda-forge obspy
{% endcodeblock %}
若用户不进行版本控制可直接前往检验ObsPy安装：**[检验安装](#jump)**

**建议用户优先采用Anaconda的管理工具`conda`安装所需安装包**
用户可通过`conda search <package>`搜索所需安装包，若显示conda-forge中无该软件的预编译版本则考虑`anaconda search -t conda <package_name>`查看默认通道外的通道是否存在该安装包。最后再考虑使用`pip`等安装工具。

# 版本控制
ObsPy依赖于一系列的Python科学计算模块，当各个模块进行版本更新后可能造成ObsPy无法使用。因此，用户可以考虑固定ObsPy及其依赖模块的版本，避免模块升级。

## ObsPy 0.10.2的版本控制示例
本示例假定用户使用Python2并期望使用ObsPy0.10.2的情况。
* 添加obspy 的通道
{% codeblock %}
$ conda config --add channels obspy
{% endcodeblock %}
* 创造一个以"obspy0.10"为名的相对独立的运行环境
{% codeblock %}
$ conda create -n obspy0.10 python=2.7
Fetching package metadata: ........
Solving package specifications: ...........

Package plan for installation in environment /home/megies/anaconda/envs/obspy0.10:

The following NEW packages will be INSTALLED:

    openssl:    1.0.2g-0     
    pip:        8.1.1-py27_0
    python:     2.7.11-0     
    readline:   6.2-2        
    setuptools: 20.3-py27_0  
    sqlite:     3.9.2-0      
    tk:         8.5.18-0     
    wheel:      0.29.0-py27_0
    zlib:       1.2.8-0      

Proceed ([y]/n)? y

Extracting packages ...
[      COMPLETE      ]|######################################| 100%
Linking packages ...
[      COMPLETE      ]|######################################| 100%
#
# To activate this environment, use:
# $ source activate obspy0.10
#
# To deactivate this environment, use:
# $ source deactivate
#
{% endcodeblock %}

* 在当前终端激活obspy0.10的运行环境
{% codeblock %}
$ source activate obspy0.10
discarding /path/to/anaconda/bin from PATH
prepending /path/to/anaconda/envs/obspy0.10/bin to PATH
(obspy0.10)$ which python  # just to illustrate which python is in use now
/path/to/anaconda/envs/obspy0.10/bin/python
{% endcodeblock %}

* 为固定环境配置安装包
{% codeblock %}
# contents of /path/to/anaconda/envs/obspy0.10/conda-meta/pinned:
python 2.7.*
numpy 1.10.*
matplotlib 1.5.*
basemap 1.0.*
obspy 0.10.*
{% endcodeblock %}

* 安装obspy及其依赖
```
(obspy0.10)$ conda install obspy
Fetching package metadata: ........
Solving package specifications: ...........

Package plan for installation in environment /home/megies/anaconda/envs/obspy0.10:

The following packages will be downloaded:

    package                    |            build
    ---------------------------|-----------------
    libgfortran-3.0            |                0         261 KB
    future-0.15.2              |           py27_0         616 KB
    numpy-1.9.3                |           py27_2         5.7 MB
    pytz-2016.2                |           py27_0         176 KB
    lxml-3.6.0                 |           py27_0         2.8 MB
    python-dateutil-2.5.1      |           py27_0         235 KB
    scipy-0.17.0               |       np19py27_2        29.9 MB
    ------------------------------------------------------------
                                           Total:        39.7 MB

The following NEW packages will be INSTALLED:

    basemap:         1.0.7-np19py27_0
    cairo:           1.12.18-6        
    flake8:          2.5.1-py27_0     
    fontconfig:      2.11.1-5         
    freetype:        2.5.5-0          
    funcsigs:        0.4-py27_0       
    future:          0.15.2-py27_0    
    geos:            3.3.3-0          
    libgfortran:     3.0-0            
    libpng:          1.6.17-0         
    libxml2:         2.9.2-0          
    libxslt:         1.1.28-0         
    lxml:            3.6.0-py27_0     
    matplotlib:      1.4.3-np19py27_2
    mccabe:          0.3.1-py27_0     
    mkl:             11.3.1-0         
    mock:            1.3.0-py27_0     
    numpy:           1.9.3-py27_2     
    obspy:           0.10.2-np19py27_0
    pbr:             1.3.0-py27_0     
    pep8:            1.7.0-py27_0     
    pixman:          0.32.6-0         
    py2cairo:        1.10.0-py27_2    
    pyflakes:        1.1.0-py27_0     
    pyparsing:       2.0.3-py27_0     
    pyqt:            4.11.4-py27_1    
    python-dateutil: 2.5.1-py27_0     
    pytz:            2016.2-py27_0    
    qt:              4.8.7-1          
    scipy:           0.17.0-np19py27_2
    sip:             4.16.9-py27_0    
    six:             1.10.0-py27_0    
    sqlalchemy:      1.0.12-py27_0    

Proceed ([y]/n)?

Fetching packages ...
libgfortran-3. 100% |######################################| Time: 0:00:00 442.02 kB/s
future-0.15.2- 100% |######################################| Time: 0:00:00 756.18 kB/s
numpy-1.9.3-py 100% |######################################| Time: 0:00:04   1.40 MB/s
pytz-2016.2-py 100% |######################################| Time: 0:00:00 356.89 kB/s
lxml-3.6.0-py2 100% |######################################| Time: 0:00:03 793.42 kB/s
python-dateuti 100% |######################################| Time: 0:00:00 473.91 kB/s
scipy-0.17.0-n 100% |######################################| Time: 0:00:20   1.54 MB/s
Extracting packages ...
[      COMPLETE      ]|######################################| 100%
Linking packages ...
[      COMPLETE      ]|######################################| 100%
```
* 完成

# 检验安装结果
<span id="jump">运行如下代码：</span>
```
$ obspy-runtests
```
`Tips:`
* 可根据报错安装相应依赖。例：本机显示缺少mock module。使用`conda install mock`安装相应依赖。

# 参考文献
* [installation via anaconda](https://github.com/obspy/obspy/wiki/Installation-via-Anaconda)
* [installation of anaconda](https://www.continuum.io/downloads)
* [installation of pyenv](https://github.com/yyuu/pyenv#basic-github-checkout)
* [obspy package in anaconda cloud](https://anaconda.org/obspy/obspy)
* [troubleshooting of anaconda](http://conda.pydata.org/docs/troubleshooting.html)

# 修改历史
* 2017-01-06：初稿并翻译"ObsPy通过Anaconda安装"指南
