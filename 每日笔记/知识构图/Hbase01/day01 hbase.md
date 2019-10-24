#### 1.HBase的介绍

​	hbase：是一个nosql的数据库。

​			google的三篇论文：gfs   mapreduce   bigtable=》HBASE

​			是建立在hdfs之上，使用hbase之前要启动hadoop

​			提供高可靠性、高性能、列存储、可伸缩、实时读写

​			hbase是一个列式存储的数据库。

​			hbase只能进行单行的查询，是按照rowkey（行键）进行查询。仅支持简单的行级的事务。

​			不支持复杂的查询操作，比如 join

​			仅支持结构化和半结构化数据：

​				结构化数据：如mysql数据中的表

​				半结构化数据：xml  json

​				非结构化数据：视频  音频

​		hbase的数据类型：Byte[]

​		HBASE的特点：

​		1）大：数据量大

​		2）面向列：按照列进行存储

​		3）稀疏：数据字段如果为null，不会占位存储。

#### 2.hbase和hadoop关系

​		hdfs：

​		1)分布式存储提供文件系统

​		2）强调一次写入，多次读取

​		3）使用文件，按照文件进行读取。

​		hbase:

​		1）按照表的形式进行列式存储。

​		2）针对表的随机实时读写。

​		3）按照key value进行数据的操作，

#### 3.rdbms和hbase对比

​	rdbms：

​		1）结构

​			1）以表的形式存在。

​			2）支持多个文件系统

​			3）使用主键（pk）

​		2）功能

​			1）使用sql查询

​			2）面向行存储

​			3）acid

​	hbase:

​		1)结构：

​			1）数据库是以region的形式存在。

​			2）支持hdfs

​			3）使用wal（write ahead logs）

​			4）使用行键（row key)

​		2）功能

​			1）使用api和mapreduce完成访问

​			2）面向列存储。

​			3）仅支持**行级事务**

​			4）只能完成简单的查询，不支持join、

#### 4.hbase的特征

​		1）海量存储

​			适合在在大量数据下进行查询（pb）。

​		2）列式存储：hbase中是按照列族进行数据的区分和存储。

​		3）极易扩展：hbase中有regionserver的概念，实际扩展的就是regionserver。

​		4）高并发：

​		5）稀疏：对于null的数据不进行存储。

#### 5.hbase架构

​	1.hmaster：用于监控管理hregionserver。

​	2.hregionserver：主要用于存储和管理hbase的实际数据。

​	3.zookeeper：1）将rs注册到zk中。

​				  2） metaregionserver注册到zk中

​	hregionserver的组件：

​	1）wal：预写日志。

​	2）hfile：最后写到hdfs上的物理存储文件。

​	3）Store：存储单元，一个store对应一个列族

​	4）memstore：内存存储单元，用于数据临时存储，通过flush刷盘到hdfs上。

​	5）region：表的分片（区域），一个region实际是一张表的全部数据或部分数据。

#### 6.hbase环境搭建（详见教案）



#### 7.hbase表结构

​	rowkey：行键，一行数据的唯一标识。

​	列族：column family，相同的列的描述的一个归总，称为一个列族。建议列族3个即可。

​	列：qualifier,相当于一个个的字段。

​	时间戳：数据存储或更改的时间。

​	version：版本，表示数据存储的版本。

​	cell：单元格，rowkey+column family+qualifier，timestamp+version

#### 7.常用shell操作

​	1进入hbase客户端

```
hbase shell
```

​	2.查看所有的表

```
list
list_namespace_tables  ‘hbase’
```

​	3.创建一张表

```
create 'user', 'info', 'data'
```

​	4.添加一条数据

```
put 'user', 'rk0001', 'info:name', 'zhangsan'
```

​	数据只能一个列一个列的插入

​	5.查询操作

​		1）通过rowkey进行查询

```
get 'user', 'rk0001'
```

​		2）查看指定列族信息

```
get 'user', 'rk0001'，‘info’
```

​		3）查看指定列族下的列的信息

```
get 'user', 'rk0001', 'info:name', 'info:age'
```

​		4）查看多个列族信息

```
 get 'user', 'rk0001', 'info', 'data'
 或者
 get 'user', 'rk0001', {COLUMN => ['info', 'data']}
 再或者
 get 'user', 'rk0001', {COLUMN => ['info:name', 'data:pic']}
```

​		5）指定rowkey与列值查询

```
get 'user', 'rk0001', {FILTER => "ValueFilter(=, 'binary:zhangsan')"}
```

​		6)指定rowkey与列值模糊查询

```
get 'user', 'rk0001', {FILTER => "(QualifierFilter(=,'substring:a'))"}
```

​	6.查询所有数据

```
scan  'user'
```

​	7.查询指定列族

```
scan 'user',{COLUMNS => 'info'}
scan 'user', {COLUMNS => 'info', RAW => true, VERSIONS => 5}
scan 'user', {COLUMNS => 'info', RAW => true, VERSIONS => 3}
```

​	8.指定多列族

```
scan 'user', {COLUMNS => ['info', 'data']}
scan 'user', {COLUMNS => ['info:name', 'data:pic']‘
```

​	9.指定列族与某个列名查询

```
scan 'user', {COLUMNS => 'info:name'}
```

​	10.指定列族与列名以及限定版本查询

```
scan 'user', {COLUMNS => 'info:name', VERSIONS => 5}
```

​	11.指定多个列族与按照数据值模糊查询

```
scan 'user', {COLUMNS => ['info', 'data'], FILTER => "(QualifierFilter(=,'substring:a'))"}
```

​	12、rowkey的范围值查询

```
scan 'user', {COLUMNS => 'info', STARTROW => 'rk0001', ENDROW => 'rk0003'}
```

​	13.指定rowkey模糊查询

```
scan 'user',{FILTER=>"PrefixFilter('rk')"}
```

​	14.指定数据范围值查询

```
scan 'user', {TIMERANGE => [1392368783980, 1392380169184]}
```

​	7.更新数据操作

​	1）更新数据值

​		所谓的更新就是指插入一条新的数据，如果rowkey已经存在，表示数据更新。

​	2）更新版本号

```
 alter 'user', NAME => 'info', VERSIONS => 5
```

​	8.删除数据以及删除表操作

​		1)指定rowkey以及列名进行删除

```
	delete 'user', 'rk0001', 'info:name'
```

​		2）指定rowkey，列名以及字段值进行删除

```
	delete 'user', 'rk0001', 'info:name', 1392383705316
```

​		3）删除一个列族

```
alter 'user', NAME => 'info', METHOD => 'delete' 
或 alter 'user', 'delete' => 'info'
```

​		4）清空表数据

```
truncate 'user'
```

​		5）删除表

```
disable 'user'
drop 'user'
```

​	9.统计一张表有多少行数据

```
count ’user‘
```

#### 8.高级shell管理命令



#### 9.hbase java api（详见代码）

​	1）过滤器
​		过滤器分两类：

​		1）比较过滤器

​		2）专用过滤器

​	2）比较器

BinaryComparator  按字节索引顺序比较指定字节数组，采用Bytes.compareTo(byte[])

BinaryPrefixComparator 跟前面相同，只是比较左端的数据是否相同

NullComparator 判断给定的是否为空

BitComparator 按位比较

RegexStringComparator 提供一个正则的比较器，仅支持 EQUAL 和非EQUAL

SubstringComparator 判断提供的子串是否出现在value中。

#### 10.hbase底层原理(看图 )

#### 11.hbase三个重要机制

​	1）flush：刷盘

​		1）hbase.regionserver.global.memstore.size  默认;堆大小的40%

​		2）hbase.hregion.memstore.flush.size：128m

​		3）hbase.regionserver.optionalcacheflushinterval ： 1h

​		4）hbase.regionserver.global.memstore.size.lower.limit  默认：堆大小 * 0.4 * 0.95

​		5）hbase.hregion.preclose.flush.size  默认为：5M

​		6）hbase.hstore.compactionThreshold  默认为 3 

​	2）compact:合并

​	 1）Minor操作只用来做部分文件的合并操作以及包括minVersion=0并且设置ttl的过期版本清理，不做任何删除数据、多版本数据的清理工作。

   	2）Major操作是对Region下的HStore下的所有StoreFile执行合并操作，最终的结果是整理合并出一个文件。	

​	3）split：拆分

​	当Region达到阈值，会把过大的Region一分为二。

​	默认一个HFile达到10Gb的时候就会进行切分