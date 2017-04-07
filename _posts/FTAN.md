---
title: 提取频散曲线
date: 2017-03-03 15:01:14
categories: 地震学研究
tags: [Seismology,ObsPy,FTAN,频散曲线]
toc: true
comments: true
mathjax: true
---

# 主旨描述
本文旨在总结归纳从互相关函数（Rayleigh波）中提取频散曲线的方法。即从地震观测资料中获取群速度与相速度随频率的变化函数。

# 自动化FTAN
Bracewell(1978)描述了Frequency-Time Analysis(FTAN)的基本原理，而Bensen(2007)则叙述了将该方法自动化的方法。

## 原理简介

### FTAN构建频散
假定$s(t)$ 为地震波信号，其傅立叶变换可表示为$\mathbf{S}(\omega)=\int_{- \infty}^{\infty} s(t) e^{i \omega t} dt$。
频率域内考虑其解析函数可表达为：
{% math %}
$S_a( \omega )=S( \omega )(1+sgn(\omega))$
{% endmath %}
将其变换至时间域中可得：
{% math %}
$ S_a(t) = s(t)+iH(t) = |A(t)|e^{i \phi (t)} $
{% endmath %}
其中$H(t)$是$S(t)$的希尔伯特变换。

由地震学基础理论可知，群速度表示地震波能量的传播速度。因此，为构建频率--速度函数，将需进行以下步骤：
1. 对解析函数进行以$\omega_0$为中心的高斯滤波，其数学表示为：
{% math %}
$S_a( \omega )=S( \omega )(1+sgn(\omega))G(\omega - \omega_0)$
{% endmath %}
其中$G(\omega - \omega_0) = e^{-\alpha (\frac{ \omega - \omega_0}{\omega_0})^2}$
<center>
{% asset_img Gaussian_filter.png  Fig.1 高斯滤波在频率域中的表示；红色表示某随机噪声振幅域内的振幅谱；蓝色表示经高斯滤波后的振幅谱；%}
</center>

2. 将滤波后的解析函数返回至时间域中，获得以$\omega_0$为中心的滤波后解析函数的振幅随时间的变化波形。对于台站对而言，相对距离是固定值，因此可将波形的时间转换为群速度。
```
for period in period_list:
    FFT of raw CCF,obtain signal_freq(f)

    # construct analytic signal
    if f < 0:
        analytic_signal(f)  = 0
    elif f > 0:
        analytic_signal(f)  = 2 * signal_freq(f)

    # Gaussian fileter for center oemag_0
    analytic_signal(f) *= G(omega_0)

    # return to time domain
    analytic_signal_time = ifft(analytic_signal)

    # calculate the envelope
    analytic_signal_amplitude = np.abs(analytic_signal_time)
```

3. 绘制频率--群速度图表，并从中提取频散曲线。

### 反频散滤波器
以上述方法提取出频散曲线为从原始CCF所的，由于噪声及处理参数的选择问题可能造成包络函数噪声较大，不易获得可信结果。因此，我们常需要对CCF进行反频散滤波操作以提高包络函数信噪比。

对于面波信号，我们可将其表示为:$$S(t) = \pi ^{-1}Re \int_{\omega_0}^{\omega_1} |S(\omega)|e^{i(\omega t - \Psi (\omega))} d \omega$$

其中: $$\Psi (\omega) = K(\omega)\Delta = \frac{\omega \Delta}{C_(\omega)}$$

$K(\omega)$ 表示频率$\omega$时的水平波数， $\Delta$ 表示台站间距，$C(\omega)$表示相速度， $|S(\omega)|$表示单色波在时间域内的振幅。

`Note:`从两式可以得知，由于频散的存在，某窄带滤波的结果为该频带内的波形的叠加。为得到更高信噪比的包络函数，相位频散项$\Psi (\omega)$是需要被矫正掉的。

* 由于$U_g = d\omega / dk$, $C(\omega) = \omega/k$, 对$\omega_0$ 附近做$K(\omega)$的泰勒展开并忽略二阶以上项可得：
$$K(\omega) = K(\omega_0) + \frac{dK(\omega)}{d \omega}\vert^{\omega_0}(\omega - \omega_0)$$
故：
{% math %}
$ K(\omega) = \int_{\omega_0}^{\omega} \frac{d \omega^{'}} {U_g(\omega^{'})} + K(\omega_0) $
{% endmath %}
其中：
{% math %}
$K(\omega_0) = \int_{0}^{\omega_0} \frac{d \omega^{'}}{U(\omega^{'})}$
{% endmath %}

* 我们可将频散修正项写为：
{% math %}
$ \psi (\omega) = K(\omega) \Delta $
{% endmath %}

* 经过相位修正的包络函数可表示为：
{% math %}
$ E(t) = \pi^{-1}\bracevert  \int_{\omega_0}^{\omega_1}|S(\omega)|exp[i\omega t -i \Psi(\omega) + i \psi(\omega)] \bracevert $
{%  endmath %}

该经相位修正的包络函数即可看作去频散后的结果，其当能有效提高包络函数信噪比。

## 具体工作流程及示例
<center>
{% asset_img CCF_Amplitude_Frequency_domain.png  Fig.2 示例用到PACB-SPB台站对在200204-200306的BHZ分量的数据。
本图上部表示台站间CCF，下部表示该CCF的振幅谱。%}
</center>

对某一CCF的处理主要包含三步：
* 初次做FTAN提取群速度
* 利用群速度积分获得相位修正项
* 加入相位修正后再以FTAN提取群速度

### 初次做FTAN提取群速度

FTAN包含步骤：
1. 求互相关函数经窄带滤波后的包络。
<center>
{% asset_img Analytical_signal.png  Fig.3 上图表示包络的初始频谱分布；中图表示经高斯窄带滤波后的频谱分布；下图表示将频谱反变换回频率域所得包络。%}
</center>

2. 对各窄带上的各频率分别做前述变换获得各频率的包络，并将其绘制在频率--速度图中，再提取其频散曲线。
<center>
{% asset_img FTAN Fig.4 表示频率--速度图，每点的着色均表示在该频率上以该群速度传播的波能量的相对强弱。从图中颜色较深处可提取出初始频散曲线。%}
</center>

### 相位修正
经上一步骤可获得初始的频散曲线。假设初始波数$K(0)=0$，经积分与插值处理可获得$K(\omega)$。

### 再次提取群速度
重复以FTAN提取群速度的方法，但此次在包络函数的频谱中加入$e^{-i\omega K(\omega)\Delta}$的相位修正因子。
<center>
{% asset_img Clean_FTAN Fig.5 表示相位校正后的频率--速度图，每点的着色均表示在该频率上以该群速度传播的波能量的相对强弱。从图中颜色较深处可提取出相位校正后的频散曲线%}
</center>

### 结论
从上图的对比可以看出，相位校正能较好地集中频率--速度图上的能量分布。




# 参考文献
* Bensen, G. D., et al. "Processing seismic ambient noise data to obtain reliable broad-band surface wave dispersion measurements." Geophysical Journal International 169.3 (2007): 1239-1260.
* Levshin, A. L., and M. H. Ritzwoller. "Automated detection, extraction, and measurement of regional surface waves." Monitoring the Comprehensive Nuclear-Test-Ban Treaty: Surface Waves. Birkhäuser Basel, 2001. 1531-1545.
* Goutorbe, Bruno, Diogo Luiz de Oliveira Coelho, and Stéphane Drouet. "Rayleigh wave group velocities at periods of 6–23 s across Brazil from ambient noise tomography." Geophysical Journal International 203.2 (2015): 869-882.

# 修改历史
* 2017-03-03： 初稿并给出FTAN的理论介绍
* 2017-03-10： 次稿并给出数据处理示例
