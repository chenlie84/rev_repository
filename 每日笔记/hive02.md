## hive02

### 1.回顾

启动hive的前提

1. 启动Hadoop
2. mysql服务启动
3. 启动bin/hive --service hiveserver2
4. 启动bin/beeline  , 链接数据库

### 2.hive函数

hive 自身提供一些函数

`desc function 函数  : 查看函数`

 `desc  function extended`

1. ###### hive自定义函数

   1. ###### UDF (用户自定义函数) : 一进一出

   2. ###### UDAF(用户自定义聚合函数) : 多进一出

   3. ###### UDTF(用户自定义表生成函数) : 一进多出

   4. ###### 在自定义UDF的时候 , 实现evaluate的方法名称一定不能随意修改

### 3.hive的存储格式

行式存储

列式存储 (优点)

textfile

orcfile (列式存储)

### 4.写sql sql sql



