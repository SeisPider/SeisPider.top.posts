---
title: 各项异性及其速度计算
date: 2017-03-23 12:08:22
categories: 地球物理学研究
tags: [Python,Geophysics]
toc: true
comments: true
mathjax: true
---
{% blockquote 刘向，战国策 %}
日中则移，月满则亏，物盛则衰。
{% endblockquote %}

# 主旨描述
本文旨在介绍弱各向异性介质或[VTI](http://sepwww.stanford.edu/data/media/public/docs/sep92/sergey4/paper_html/node2.html)介质及一般均匀介质的各向速度计算方法。

# 原理描述
对于单色平面波，其波动方程如下：
{% math %}
$ \rho \ddot{u}_i( \mathbf{x} ,t) = \frac{\partial \tau_{ij}(\mathbf{x},t)} {\partial x_j} $
{% endmath %}
结合Hook定律：
{%  math %}
  $ \tau_{ij} = c_{ijkl} \frac{\partial u_l}{\partial x_k} $
{%  endmath %}
和平面波在频率域的表示：
{% math %}
$  \mathbf{u}(x,t) = \mathbf{g} e^{ -i \omega (t - \mathbf{s} \cdot \mathbf{x})} $
{% endmath %}

将平面波方程与Hook定律代入波动方程中可得：
{% math %}
$  \rho g_i = c_{ijkl} s_k s_j g_l $
{% endmath %}
即：
{% math %}
$(C_{ijkl} \hat{s_k} \hat{s_j} - c^2 \rho \delta_{il} ) g_l = 0$
{% endmath %}
其中$\mathbf{u(x,t)}$是位移矢量，$\tau{_{ij}}$是应力张量各分量，$\rho$是密度值，$\mathbf{s}$是幔度矢量，$\mathbf{x}$是位置点矢量，$ \mathbf{C}$是劲度张量，$\mathbf{g}$是偏振矢量。

在上式做变换
{% math %}
 $ M_{il} = \frac{ C_{ijkl}} {\rho} \hat{s_k} \hat{s_j} $
 {% endmath %}
即可得到christoffel公式：
{% math %}
$ \mathbf{M} \cdot \mathbf{g} = c^2 \mathbf{g} $
{% endmath %}
解上述特征值问题即可得到任意均匀介质（同$\mathbf{C}$）的偏振方向（$\mathbf{g}$）和速度特征值（$c$）。
一般而言，上述特征值有三个解，分别代表不同P,SV和SH波。

# 修改历史
2017-03-23: 第一版并给christoffel公式

# 参考文献
**[基础地震学 朱良保](http://product.dangdang.com/24134702.html)**
