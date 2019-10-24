## day01 python 数据挖掘

####  安装python

``` 
1.下载安装包
2.解压，目录自己看
3.如果没有gcc环境 ， 需要安装 yum -y install gcc
```

1. 安装其他的依赖

   ``` 
   yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel
   ```

2. 解压安装包

3. ./configrue

4. make && make install

5. 完成安装

####基本语法

1. 编码 ： py3默认都是以UTF—8进行编码的

2. 标识符：

   1. 第一个字符必须是字母表中的字母或者下划线_
   2. 其对大小写敏感
   3. 标识符的其他部分有数字，字母，下划线组成
   4. 在py3中中文可以作为变量名 ，非ascll 标识符一也可以使用

3. 保留字

   1. ```python
      >>> import keyword
      >>> keyword.kwlist
      ['False', 'None', 'True', 'and', 'as', 'assert', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is', 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try', 'while', 'with', 'yield']
      ```

4. 注释

   ```python
   # 单行注释
   '''
   多行注释
   '''
   """
   多行注释
   """
   
   ```

5. 行与缩进

   1. 最特色的就是使用缩进来代替大括号

      ```
      if (2 > 4):
          print("true")
      else:
          print("false")
      ```

   



