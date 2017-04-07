---
title: 地震学软件整理
date: 2017-04-05 10:07:33
categories: 地球物理学研究
tags: [Geophysics, Seis_software, Python, ObsPy]
toc: true
comments: true
mathjax: true
---
{% blockquote 黄大受，中国通史 %}
即知即行，即心即物，即动即静，即体即用
{% endblockquote %}
# 主旨描述
本文旨在总结地震学中可能用到的地震学软件

# 综合数据处理软件
**[ObsPy](https://docs.obspy.org/master/tutorial/)** 可方便用于处理多种数据格式的文件，方便地与SciPy, NumPy等模块交互处理。

**[SAC](http://ds.iris.edu/files/sac-manual/)** 可方便用于交互处理SAC格式的地震数据。

# 理论地震计算
**[CPS330](http://www.eas.slu.edu/eqc/eqccps.html)** 可利用nomal mode 计算，对理论地震图低频部分计算速度较快。

**[TauP](http://www.seis.sc.edu/taup/)** 可利用速度模型计算射线到时及其路径。

# 绘图板块
**[GMT](http://gmt.soest.hawaii.edu/)** 可方便用于绘制地图及多种二维图。

**[Matplotlib.pyplot](http://matplotlib.org/api/pyplot_api.html)** 是Python下的便捷绘图模块，可用于与Python交互数据。

# 数据下载
**[SOD](http://www.seis.sc.edu/sod/)** 可方便地下载地震数据并进行去均值，去仪器响应和旋转等工作。

**[HinetPy](https://seisman.github.io/HinetPy/)** 是方便地下载Hinet的地震数据地Python模块。
