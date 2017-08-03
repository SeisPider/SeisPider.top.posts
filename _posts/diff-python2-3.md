---
title: Python 2.7.X 与 Python 3.X间的部分区别
date: 2017-07-18 15:08:43
categories: 技术分享
tags: Python
toc: True
---
>**本文译自[Sebastian Raschka](http://sebastianraschka.com/Articles/2014_python_2_3_key_diff.html)
 的博文并加入部分自己的内容**

目前，Python 2.7.X与Python 3.X并存。对于软件开发者而言，这俩版本并无好坏差别。但是，了解俩版本之间的差异还是比较有必要的。

# \_\_future\_\_模块

Python 3.X 加入了一些 Python 2未完成的关键词和新功能等。如果读者计划使自己的Python 2项目未来支持Python 3. 则读者可以在Python 2\_\_future\_\_模块导入上述特性。
譬如，假若我们需要在Python 2中支持Python 3的整除，则我们可以通过如下代码导入：
```Python
from __future__ import division
```
下表罗列了\_\_future\_\_模块可以导入的一些常见特性

|feature | optional |	mandatory  | effect|
| :------:| :------: | :------: | :----------|
|nested_scopes | 2.1.0b1 |	2.2|	[PEP 227](https://www.python.org/dev/peps/pep-0227/): Statically Nested Scopes|
|generators|	2.2.0a1 |	2.3|	[PEP 255](https://www.python.org/dev/peps/pep-0255/): Simple Generators|
|division	|2.2.0a2	| 3.0	| [PEP 238](https://www.python.org/dev/peps/pep-0238/): Changing the Division Operator|
|absolute_import|	2.5.0a1 |	3.0|	[PEP 328](https://www.python.org/dev/peps/pep-0328/): Imports: Multi-Line and Absolute/Relative|
|with_statement|	2.5.0a1 |	2.6	| [PEP 343](https://www.python.org/dev/peps/pep-0343/): The “with” Statement|
|print_function|	2.6.0a2 |	3.0	| [PEP 3105](https://www.python.org/dev/peps/pep-3105/): Make print a function|
|unicode_literals|	2.6.0a2	| 3.0 |	[PEP 3112](https://www.python.org/dev/peps/pep-3112/): Bytes literals in Python 3000|

# 输出函数
Python 3 中的 print 函数调用必需要加上括号，而Python 2 中则是可选项目。

**Python 2**
```python
print 'Python', python_version()
print 'Hello, World!'
print('Hello, World!') # optional
print "text", ; print 'print more text on the same line'
```
```
Python 2.7.6
Hello, World!
Hello, World!
text print more text on the same line
```

**Python 2**
```python
print('Python', python_version())
print('Hello, World!')

print("some text,", end="")
print(' print more text on the same line')
```
```
Python 3.4.1
Hello, World!
some text, print more text on the same line
```
```python
print 'Hello, World!'
```
```
File "<ipython-input-3-139a7c5835bd>", line 1
  print 'Hello, World!'
                      ^
SyntaxError: invalid syntax
```

**Note:**
Python 2 中的print是语句而非函数。因此，当可选的括号中出现了多个变量时，Python将输出元组。
```python
print 'Python', python_version()
print('a','b')
print 'a', 'b'
```
```
Python 2.7.7
('a', 'b')
a b
```

# 整除
Python 2 与 Python 3 间比较危险的差异在于整除。当利用Python 3 编译器运行Python 代码时，整除将出现错误并且并没有输出报错信息。因此，建议在 Python 3 脚本中使用 float(3)/2 或者 3/2.0 而不是 3/2 以保留Python 2 的代码风格。（推荐Python 2 脚本从\_\_future\_\_中导入division模块）

**Python 2**
```python
print 'Python', python_version()
print '3 / 2 =', 3 / 2
print '3 // 2 =', 3 // 2
print '3 / 2.0 =', 3 / 2.0
print '3 // 2.0 =', 3 // 2.0
```
```
Python 2.7.6
3 / 2 = 1
3 // 2 = 1
3 / 2.0 = 1.5
3 // 2.0 = 1.0
```
**Python 3**
```python
print 'Python', python_version()
print ('3 / 2 =', 3 / 2)
print ('3 // 2 =', 3 // 2)
print ('3 / 2.0 =', 3 / 2.0)
print ('3 // 2.0 =', 3 // 2.0)
```
```
Python 3.4.1
3 / 2 = 1.5
3 // 2 = 1
3 / 2.0 = 1.5
3 // 2.0 = 1.0
```

# Unicode
Python 2 拥有ASCII str() 类型，并且有单独的unicode()函数，但是没有 byte 类型的数据。
Python 3 拥有了Unicode(utf-8)类型的字符串并且拥有了两个byte类：byte 和 bytearray。

**Python 2**
```python
print 'Python', python_version()
```
```
Python 2.7.6
```
```python
print type(unicode('this is like a python3 str type'))
```
```
<type 'unicode'>
```
```python
print type(b'byte type does not exist')
```
```
<type 'str'>
```
```python
# 可加表示前后俩对象类型一致
print 'they are really' + b'the same'
```
```
they are really the same
```
```python
print type(bytearray(b'bytearray oddly does exist though'))
```
```
<type 'bytearray'>
```

**Python 3**
```python
# 目前的Python可以接受utf-8编码，对中文用户是福音
print('Python', python_version())
print('strings are now utf-8 \u03BCnico\u0394é!')
```
```
Python 3.4.1
strings are now utf-8 μnicoΔé!
```
```python
# 目前的Python加入了byte类型以存储字符串
print('Python', python_version(), end="")
print(' has', type(b'bytes for storing data'))
```
```
Python 3.4.1 has <class 'bytes'>
```
```python
print('and Python', python_version(), end="")
print(' also has', type(bytearray(b'bytearrays')))
```
```
and Python 3.4.1 also has <class 'bytearray'>
```
```python
# 不同类型不可互加
'note that we cannot add a string' + b'bytes for data'
```
```
TypeError                                 Traceback (most recent call last)

<ipython-input-13-d3e8942ccf81> in <module>()
----> 1 'note that we cannot add a string' + b'bytes for data'


TypeError: Can't convert 'bytes' object to str implicitly
```

# xrange
在Python 2 中， 用户经常使用xrange()函数来产生可迭代对象用以在循环中使用。
单次使用时，寻常的range()函数比xrange()运行速度要快，而大量调用则情形相反。
在Python 3中，range()函数将表现得像xrange()一样。因此，专门的xrange()函数即被放弃了。(输入xrange(), Python 3 将抛出 NameError)
```python
import timeit

n = 10000
def test_range(n):
  return for i in range(n):
    pass
def test_xrange(n):
  for i in xrange(n):
    pass
```
**Python 2**
```python
print 'Python', python_version()

print '\ntiming range()'
%timeit test_range(n)

print '\n\ntiming xrange()'
%timeit test_xrange(n)
```
```
Python 2.7.6

timing range()
1000 loops, best of 3: 433 µs per loop


timing xrange()
1000 loops, best of 3: 350 µs per loop
```
**Python 3**
```python
print('Python', python_version())

print('\ntiming range()')
%timeit test_range(n)
```
```
Python 3.4.1

timing range()
1000 loops, best of 3: 520 µs per loop
```
```python
print(xrange(10))
```
```
---------------------------------------------------------------------------
NameError                                 Traceback (most recent call last)

<ipython-input-5-5d8f9b79ea70> in <module>()
----> 1 print(xrange(10))


NameError: name 'xrange' is not defined
```

# Python 3 中的range对象包含了新的\_\_contains\_\_方法
Python 3 的range 对象中添加了新的\_\_contains\_\_方法, 该方法可以有效加快range 中对整型和逻辑型对象的查找。
```python
x = 10000000

# 定义被测试函数
def val_in_range(x, val):
    return val in range(x)
def val_in_xrange(x, val):
    return val in xrange(x)

# 检测函数效率
print('Python', python_version())
assert(val_in_range(x, x/2) == True)
assert(val_in_range(x, x//2) == True)
%timeit val_in_range(x, x/2)
%timeit val_in_range(x, x//2)
```
```
Python 3.4.1
1 loops, best of 3: 742 ms per loop
1000000 loops, best of 3: 1.19 µs per loop
```
根据上述 timeit 的输出结，我们可以观察出，range对象中整型数据的查找比浮点型的快60000多倍。Python 2 没有优化，因此没有上述特征。
```python
print 'Python', python_version()
assert(val_in_xrange(x, x/2.0) == True)
assert(val_in_xrange(x, x/2) == True)
assert(val_in_range(x, x/2) == True)
assert(val_in_range(x, x//2) == True)
%timeit val_in_xrange(x, x/2.0)
%timeit val_in_xrange(x, x/2)
%timeit val_in_range(x, x/2.0)
%timeit val_in_range(x, x/2)
```
```
Python 2.7.7
1 loops, best of 3: 285 ms per loop
1 loops, best of 3: 179 ms per loop
1 loops, best of 3: 658 ms per loop
1 loops, best of 3: 556 ms per loop
```
从上述测试结果可以看出，Python 2 不包含\_\_contains\_\_方法，即不存在优化。
 ```python
 print('Python', python_version())
 range.__contains__
 ```
 ```
 Python 3.4.1





<slot wrapper '__contains__' of 'range' objects>
 ```
 ```python
 print 'Python', python_version()
 range.__contains__
 ```
 ```
 Python 2.7.7



---------------------------------------------------------------------------
AttributeError                            Traceback (most recent call last)

<ipython-input-7-05327350dafb> in <module>()
      1 print 'Python', python_version()
----> 2 range.__contains__


AttributeError: 'builtin_function_or_method' object has no attribute '__contains__'
 ```
 ```python
 print 'Python', python_version()
 xrange.__contains__
 ```
 ```
 Python 2.7.7



---------------------------------------------------------------------------
AttributeError                            Traceback (most recent call last)

<ipython-input-8-7d1a71bfee8e> in <module>()
      1 print 'Python', python_version()
----> 2 xrange.__contains__


AttributeError: type object 'xrange' has no attribute '__contains__'
 ```

# Python 2 与 3 的速度差异
下面的测试代码显示，Python 3 比 Python 2 在基础计算上运行速度要慢。
```python
def test_while():
    i = 0
    while i < 20000:
        i += 1
    return
```
```python
print('Python', python_version())
%timeit test_while()
```
```
Python 3.4.1
100 loops, best of 3: 2.68 ms per loop
```
```python
print 'Python', python_version()
%timeit test_while()
```
```
Python 2.7.6
1000 loops, best of 3: 1.72 ms per loop
```

# 抛出异常
Python 2 支持新老版本的抛出异常的语法，而Python 3 只认新语法（若不加括号将被解释为语法错误）。
**Python 2**
```python
print 'Python', python_version()
```
```
Python 2.7.6
```
```python
# 老语法
raise IOError, "file error"
```
```
---------------------------------------------------------------------------
IOError                                   Traceback (most recent call last)

<ipython-input-8-25f049caebb0> in <module>()
----> 1 raise IOError, "file error"


IOError: file error
```
```python
# 新语法
raise IOError("file error")
```
```
---------------------------------------------------------------------------
IOError                                   Traceback (most recent call last)

<ipython-input-9-6f1c43f525b2> in <module>()
----> 1 raise IOError("file error")


IOError: file error
```
**Python 3**
```python
print('Python', python_version())
```
```
Python 3.4.1
```
```python
# 老语法
raise IOError, "file error"
```
```
# Python 3 编译失败
File "<ipython-input-10-25f049caebb0>", line 1
  raise IOError, "file error"
               ^
SyntaxError: invalid syntax
```
```python
print('Python', python_version())
raise IOError("file error")
```
```
Python 3.4.1



---------------------------------------------------------------------------
OSError                                   Traceback (most recent call last)

<ipython-input-11-c350544d15da> in <module>()
      1 print('Python', python_version())
----> 2 raise IOError("file error")


OSError: file error
```

# 异常处理
Python 3 处理异常时必须要加上as关键词。

**Python 2**
```python
print 'Python', python_version()
try:
    let_us_cause_a_NameError
except NameError, err:
    print err, '--> our error message'
```
```
Python 2.7.6
name 'let_us_cause_a_NameError' is not defined --> our error message
```

**Python 3**
```python
# 必须要有 as 关键词
print('Python', python_version())
try:
    let_us_cause_a_NameError
except NameError as err:
    print(err, '--> our error message')
```
```
Python 3.4.1
name 'let_us_cause_a_NameError' is not defined --> our error message
```
# next()函数和.next()方法
Python 2.7.5支持next()函数和.next()方法。Python 3 只支持next()函数而不再支持.next()方法（抛出错误：AttributeError）。
**Python 2**
```python
print 'Python', python_version()

my_generator = (letter for letter in 'abcdefg')

next(my_generator)
my_generator.next()
```
```
Python 2.7.6


'b'
```
**Python 3**
```python
print('Python', python_version())

my_generator = (letter for letter in 'abcdefg')

next(my_generator)
```
```
Python 3.4.1





'a'
```
```python
my_generator.next()
```
```
---------------------------------------------------------------------------
AttributeError                            Traceback (most recent call last)

<ipython-input-14-125f388bb61b> in <module>()
----> 1 my_generator.next()


AttributeError: 'generator' object has no attribute 'next'
```

# 循环变量和全局命名空间泄露问题
Python 3 中的循环变量将不再影响循环体之外的全局变量，即不会泄露。
**Python 2**
```python
# 循环变量将改变循环体外部变量指向的对象
print 'Python', python_version()

i = 1
print 'before: i =', i

print 'comprehension: ', [i for i in range(5)]

print 'after: i =', i
```
```
Python 2.7.6
before: i = 1
comprehension:  [0, 1, 2, 3, 4]
after: i = 4
```

**Python 3**
```python
# 循环体变量空间与外部变量空间隔绝
print('Python', python_version())

i = 1
print('before: i =', i)

print('comprehension:', [i for i in range(5)])

print('after: i =', i)
```
```
Python 3.4.1
before: i = 1
comprehension: [0, 1, 2, 3, 4]
after: i = 1
```

# Python 3 将为不可相互比较的对象间的比较操作抛出错误
```python
# 不可比较的对象间比较操作不抛出异常，返回False
print 'Python', python_version()
print "[1, 2] > 'foo' = ", [1, 2] > 'foo'
print "(1, 2) > 'foo' = ", (1, 2) > 'foo'
print "[1, 2] > (1, 2) = ", [1, 2] > (1, 2)
```
```
Python 2.7.6
[1, 2] > 'foo' =  False
(1, 2) > 'foo' =  True
[1, 2] > (1, 2) =  False
```

**Python 3**
```python
print('Python', python_version())
print("[1, 2] > 'foo' = ", [1, 2] > 'foo')
print("(1, 2) > 'foo' = ", (1, 2) > 'foo')
print("[1, 2] > (1, 2) = ", [1, 2] > (1, 2))
```
```
Python 3.4.1



---------------------------------------------------------------------------
TypeError                                 Traceback (most recent call last)

<ipython-input-16-a9031729f4a0> in <module>()
      1 print('Python', python_version())
----> 2 print("[1, 2] > 'foo' = ", [1, 2] > 'foo')
      3 print("(1, 2) > 'foo' = ", (1, 2) > 'foo')
      4 print("[1, 2] > (1, 2) = ", [1, 2] > (1, 2))
```

# 使用input()函数粘贴用户代码
出于安全考虑，Python 3 取消了Python 2 中 input() 可以读入其他类型对象的设置，改为只接收输入并存为 str 类。而在 Python 2 中则需要使用 raw_input() 以实现该目的。
**Python 2**
```python
Python 2.7.6
[GCC 4.0.1 (Apple Inc. build 5493)] on darwin
Type "help", "copyright", "credits" or "license" for more information.

# Python 2 可以读入非字符串类型的对象
>>> my_input = input('enter a number: ')

enter a number: 123

>>> type(my_input)
<type 'int'>

# 若其需要读入字符串则使用 raw_input 函数
>>> my_input = raw_input('enter a number: ')

enter a number: 123

>>> type(my_input)
<type 'str'>
```
**Python 3**
```python
Python 3.4.1
[GCC 4.2.1 (Apple Inc. build 5577)] on darwin
Type "help", "copyright", "credits" or "license" for more information.

>>> my_input = input('enter a number: ')

enter a number: 123

>>> type(my_input)
<class 'str'>
```

# 部分函数返回迭代对象而非列表
Python 3 此举可能可以节省内存空间。当用户确实需要列表时，可以使用 list() 函数转换。
**Python 2**
```python
print 'Python', python_version()

print range(3)
print type(range(3))
```
```
Python 2.7.6
[0, 1, 2]
<type 'list'>
```
**Python 3**
```python
print('Python', python_version())

print(range(3))
print(type(range(3)))
print(list(range(3)))
```
```
Python 3.4.1
range(0, 3)
<class 'range'>
[0, 1, 2]
```
下面是不再返回列表的常用函数与方法：
* zip()
* map()
* filter()
* dictionary's .keys() method
* dictionary's .values() method
* dictionary's .items() method

# 四舍五入规则
Python 2 中的 round() 函数采用四舍五入规则，而 Python 3 中则将返回据该小数最近的偶数。
参考下列获取详细信息：
[Python 2 规则](https://en.wikipedia.org/wiki/IEEE_754#Roundings_to_nearest)
[Python 3 规则](https://en.wikipedia.org/wiki/Rounding#Round_half_to_even)

**Python 2**
```python
# 与该浮点数最接近的整数
print 'Python', python_version()
round(15.5)
round(16.5)
```
```
Python 2.7.12
16.0
17.0
```

**Python 3**
```python
# 与该浮点数最接近的偶数
print('Python', python_version())
round(15.5)
round(16.5)
```
```
Python 3.5.1
16
16
```

# 迁移工具
[2to3.py](https://docs.python.org/3/library/2to3.html#to3-reference)是Python 3 自带的代码迁移工具，可以检测并修改 Python 2 代码。

**使用**
Python 3.6 提供了`2to3`,  `2to3-3.4`和 `2to3-3.6`三个转换工具。
```shell
2to3 --help
```
即可看到该工具的各各选项。
```shell
2to3 filename -w
```
即可修改源代码，并生成原Python 2代码的克隆版本。

**比较**
通过工具[`meld`](http://meldmerge.org/)比较前后版本间差异并人工修改部分逻辑。

# 更多参考文章
**移植到 Python 3**
* [Should I use Python 2 or Python 3 for my development activity?](https://wiki.python.org/moin/Python2orPython3)
* [What’s New In Python 3.0](https://docs.python.org/3.0/whatsnew/3.0.html)
* [Language differences and workarounds](http://python3porting.com/differences.html)
* [Porting Python 2 Code to Python 3](https://docs.python.org/3/howto/pyporting.html)
* [How keep Python 3 moving forward](http://nothingbutsnark.svbtle.com/my-view-on-the-current-state-of-python-3)

**支持与批评 Python 3**
* [10 awesome features of Python that you can’t use because you refuse to upgrade to Python 3](http://www.asmeurer.com/python3-presentation/slides.html#1)
* [Everything you did not want to know about Unicode in Python 3](http://lucumr.pocoo.org/2014/5/12/everything-about-unicode/)
* [Python 3 is killing Python](https://medium.com/@deliciousrobots/5d2ad703365d/)
* [Python 3 can revive Python](https://medium.com/p/2a7af4788b10)
* [Python 3 is fine](http://sebastianraschka.com/Articles/2014_python_2_3_key_diff.html#)
