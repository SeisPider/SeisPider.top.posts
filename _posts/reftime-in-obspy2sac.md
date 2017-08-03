---
title: ObsPy写SAC文件中的时间问题
date: 2017-04-17 15:58:30
categories: ObsPy学习笔记
tags: [ObsPy]
toc: true
comments: true
---
本文旨在说明ObsPy在写SAC文件时涉及到的时间概念。

# SAC中的时间
SAC的时间包括一个参考时间及相对时间。

* **参考时刻** 由头段变量nzyear, nzjday, nzhour, nzmin, nzsec,nzmsec决定
* **相对时间** 即由某个时刻相对于参考时刻的时间差（单位为秒），保存于头段变量b,e,o,a,f,tn(n=0-9）
* **绝对时刻** 参考时间加相对时间

`注：` 详细说明请参考 [SAC中的时间概念](https://seisman.github.io/SAC_Docs_zh/fileformat/sac-time.html)

# ObsPy中的时间概念
ObsPy以`Trace`类存储波形数据，其属性`Trace.stats`可访问到`Trace`的开始时间和结束时间，且两者都是UTC绝对时间。ObsPy中`Trace`类仅用于存储连续波形，多个中断的波形以`Stream`类连接起来。

利用下列'.'号操作即可访问`Trace`中的绝对时间：
```python
import numpy as np
from obspy import read
# 获得示例Stream
>>> st = read()
# 获得Stream中的第零个Trace
>>> tr = st[0]
>>> tr.stats.starttime, tr.stats.endtime
(2009-08-24T00:20:03.000000Z, 2009-08-24T00:20:32.990000Z)
```

# ObsPy的Trace与SAC的Trace间的转换关系
## 由SAC的Trace转为ObsPy的Trace
对于指定文件，ObsPy会根据其可识别的各种格式一一尝试读取文件。用户仅需调用`read`函数即可。
对于SAC文件`test.SAC`
```python
# read程序将自动试探文件格式并读取
>>> test = read(".test.SAC")
# 可以通过.sac访问SAC头段信息
>>> test[0].stats.sac.b
0.0
# 此时写入SAC文件也不会损失所有SAC包含的信息
>>> test[0].write("re_write.sac",format="SAC")
```
## 由ObsPy的Trace转为SAC的Trace
ObsPy默认从mseed读取数据获得Trace。标准mseed文件包含连续波形数据，台站的经纬度，采样率，开始和结束事件等等，不包含事件信息。因此，当我们需要将mseed格式文件转换为SAC文件时，我们常需要补充事件信息及震中距等信息。

为构建Python与SAC交互API,ObsPy构建了SACTrace类以作为所有以SAC格式存储的Trace的模版。
```python
>>> from obspy.io.sac import SACTrace
# 读入mseed文件，无事件信息
>>> Test = read("test.mseed")
>>> Test[0].stats
network: BL
station: PACB
location: 10
channel: BHZ
starttime: 2002-04-17T20:01:13.967000Z
endtime: 2002-04-17T21:01:16.067000Z
sampling_rate: 10.0
  delta: 0.1
   npts: 36022
  calib: 1.0
_format: MSEED
  mseed: AttribDict({'record_length': 4096, 'encoding': u'STEIM2', 'filesize': 23818240, u'dataquality': u'D', 'number_of_records': 5815, 'byteorder': u'>'})
# 将ObsPy的Trace转换为SAC trace
>>> sac_trace = SACTrace.from_obspy_trace(trace=Test[0])
>>> sac_trace.reftime,sac_trace.b,sac_trace.iztype
(2002-04-17T20:01:13.967000Z, 0.0, u'ib')
# 我们可通过.reftime直接访问到SACTrace的参考时刻
# 1. 次处我们可以看到，参考时刻与ObsPy的starttime是一致的,并且开始时刻的b值为零。
#    此时的sac_trace.iztype表示参考时刻就是开始时刻，由于不包含事件信息，sac_trace.o为空。
# 2. 当我们需要修改参考时刻为发震时刻时，我们不能能仅进行简单的修改sac_trace.nzyear等参数。
#    该简单赋值操作不会同时修改与相对时刻相关的头段如sac_trace.b
# 从下面的操作中，我们可以看出：对nzmsec等的简单赋值仅仅修改了参考时刻，而相对时刻b,e并未产生修改，这是不科学的。
>>> sac_trace.nzmsec,sac_trace.b,sac_trace.e
(967, 0.0, 3602.1001)
>>> sac_trace.nzmsec += 100;
>>> sac_trace.nzmsec, sac_trace.b, sac_trace.e
(1167, 0.0, 3602.1001)

# 3. 对SACTrace的参考时间的正确修改方式是对sac_trace.reftime的重新赋值

# 假定发震时刻是origin_time,我们需要将参考时刻从默认的开始时刻改变为发震时刻
>>> origin_time = sac_trace.reftime + 1000;
>>> origin_time, sac_trace.nzmin # nzmin仍与开始时刻保持一致
(2002-04-17T20:17:53.967000Z, 1)
>>> sac_trace.reftime = origin_time;
>>> sac_trace.reftime,sac_trace.b,sac_trace.e, sac_trace.nzmin
(2002-04-17T20:17:53.967000Z, -1000.0, 2602.1000536754727, 17)
# 此时便可设置SACTrace.o = 0 与SACTrace.iztype = 'io'表明参考时刻是发震时刻了
>>> sac_trace.o = 0.0; sac_trace.iztype = 'io';
# 从上面的示例可以看出：对reftime的修改会同时修改参考时刻和相对时间

# 4. 利用sac_trace.o 表示发震时刻在参考时刻中的相对时刻
#    对于参考时刻非发震时刻的SACTrace而言，SACTrace.o为空。
#    为修改参考时刻为发震时刻，我们可以修改
>>> sac_trace.reftime, sac_trace.b
(2002-04-17T20:17:53.967000Z, 0)
# 下一操作表明发震时刻在现在参考时间的-1000s处
>>> sac_trace.o = -1000 # origin_time - reftime
# 次处并非简单的赋值，其会计算发震时刻的绝对时刻并将其设置为参考时刻，最后重新计算所有的相对时间b,e等
>>> sac_trace.iztype = 'io'
>>> sac_trace.reftime, sac_trace.b
(2002-04-17T20:01:13.967000Z, 1000)
```

# 参考文献
* [SAC中的时间概念](https://seisman.github.io/SAC_Docs_zh/fileformat/sac-time.html)

# 修改历史
* 2017-04-17: 初稿
