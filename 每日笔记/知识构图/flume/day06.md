#### 1.数据仓库

​	数据仓库：data warehouse（DW 或DWH），用于存储历史数据，用于进行数据的分析，往往用于企业的决策和支持。

​	作为数据仓库既不能生产数据，又不能消费数据。

​	粮仓：不能生产粮食，不能消费粮食。

##### ​	数据仓库的特征：

​	1）面向主题：针对历史数据进行分析的抽象，例如保险。

​	2）集成性：数据是从不同系统抽取，并集成到一起。

​	3）非易失性：数据存储到数据仓库中，并不会轻易的删除。

​	4）时变性：随着时间，会更新新的历史数据。

​	数据仓库与数据库的区别：

​	1）OLTP（On-Line Transaction Processing）:在线联机事务处理：针对数据存储进行事务管理。数据库

​	2)OLAP（On-Line  Analytical Processing）:在线联机分析处理，对历史数据进行分析和决策支持。--数据仓库	

##### ​	数据仓库的分成架构：

​	1）数据源（ODS 或贴源层）：数据的源来源于不同的系统。

​	2）数据仓库层：将帖源层的数据进行集成，然后进行历史数据的分析。

​		ETL:(抽取Extra, 转化Transfer, 装载Load)

​	3）数据应用层（application）：将数据以图表或报表的形式直观展现。

​		分层的原因：用户空间换时间

##### ​	元数据管理:

​	最主要指的是数据与表之间的关系映射（数据模型的定义）。

#### 2.hive的介绍

##### ​	1）hive的介绍

​		hive：是基于hadoop的数据仓库的工具。hive中数据的存储在hadoop的hdfs上进行存储。

​			  hive中数据的分析，使用类sql的语言进行分析---HQL

​			  hive中sql的自行，最终会转换成mapreduce去执行。

##### ​	  学习hive的原因：

​			1）学习成本的降低

​			2)  降低项目开发周期

​			3）mapreduce的难度大

​			使用hive：

​			1）操作简单易上手

##### ​	hive的特点：

​			1)可扩展：hive可以自由扩展集群的规模。

​				注意：hive没有集群的概念，只是一个工具。

​			2)延展性：功能可以扩展，主要是用户自定义函数（udf）

​			3）容错：hadoop的容错机制。

##### ​	2.hive的架构：

​		1）用户接口：Hive提供多种用户接口，主要通过shell的client完成相关操作

​		2）解析器：

​				1）编译器：用于sql的解析，转化为mapreduce

​				2）优化器：在编译后的结果进行优化。

​				3）执行器：执行sql（最终执行mapreduce）

##### ​		hive和hadoop的关系：

​		hive中数据存储是基于hdfs
​		hive的HQL执行是基于mapreduce

​		hive和hadoop的关系：紧耦合	

##### ​		hive中数据存储：

​		hive是存储在hdfs上，存储格式主要包括：Text，SequenceFile，ParquetFile，ORC等

​		

##### ​		hive的安装和部署

​		

##### 		hive的使用方式：

​		1）hive  shell

​		2）通过jdbc的方式连接，beeline

​		首先要启动服务，hiveserver2

​			前台启动方式： bin/hive --service  hiveserver2

​			后台启动方式：nohup bin/hive --service  hiveserver2  2>&1   &

​		然后通过beeline的方式访问：

​			bin/beeline

​			!connect jdbc:hive2://node03:10000

​		3)hive 命令

​		   hive  -e   #指定一个sql语句执行

​			bin/hive -e "use test;select * from test001;“

​		  hive -f    #指定一个sql脚本执行

​			bin/hive -f text.sql

#### 3.hive的基本操作

##### ​	1)创建数据库和创建表

###### ​		1）创建数据库

```
create database if not exists myhive;
```

​			创建数据库并指定目录

```
	create database myhive2 location '/myhive2'; 
```



###### ​		2）修改数据库

​		修改数据库只能修改属性

```
alter   database  myhive2  set   dbproperties('createtime'='20180611');	
```

  

###### ​		3）基本信息查看

```
desc database myhive2;
```

​		查看扩展信息

```
desc database  extended  myhive2;
```



###### ​		4）删除数据库

```
drop database myhive2;
```

​		如果数据库中表，加上cascade做级联删除。

```
drop database test cascade;
```



##### ​	2）数据库表的操作

   CREATE [EXTERNAL] TABLE [IF NOT EXISTS] table_name                              #创建一张表，指定表名

   [(col_name data_type [COMMENT col_comment], ...)]                                  #创建指定字段  增加注释

   [COMMENT table_comment] 										   #表的注释

   [PARTITIONED BY (col_name data_type [COMMENT col_comment], ...)]    #文件的分区：分的是目录

   [CLUSTERED BY (col_name, col_name, ...) 							  #文件的分桶：分的是文件

   [SORTED BY (col_name [ASC|DESC], ...)] INTO num_buckets BUCKETS]   #文件的排序  INTO 3 BUCKETS分桶

   [ROW FORMAT row_format] 										#按照指定格式进行数据的分割

   [STORED AS file_format] 										         #指定表的存储格式

   [LOCATION hdfs_path]											 #指定表的存储目录

​		1）管理表（内部表）：由hive管理的表，删除表的时候，数据会一起被删除

​		创建表并指定字段之间的分隔符

```
create  table if not exists stu2(id int ,name string) row format delimited fields terminated by '\t' stored as textfile location '/user/stu2';
```

​		根据查询结果创建表

```
create table stu3 as select * from stu2;
```

​		根据已经存在的表结构创建表

```
create table stu4 like stu2;
```

​		查询表的类型

​		

```
desc formatted  stu2;
```

​		2）外部表：删除表的时候，只删除元数据信息，表数据不会被删除。

​		创建老师表：

 		

```
create external table teacher (t_id string,t_name string) row format delimited fields terminated by '\t';	
```

​		创建学生表：

​		

```
create external table student (s_id string,s_name string,s_birth string , s_sex string ) row format delimited fields terminated by '\t';
```

​		加载数据：

​		从本地文件系统向表中加载数据

​		

```
load data local inpath '/export/servers/hivedatas/student.csv' into table student;
```

​		加载数据并覆盖已有数据

```
load data local inpath '/export/servers/hivedatas/student.csv' overwrite  into table student;
```

​		3）分区表

​			思想：分而治之。

​			分的是目录。

​			创建分区表：

```
create table score(s_id string,c_id string, s_score int) partitioned by (month string) row format delimited fields terminated by '\t';
```

​		加载数据到分区表中

```
load data local inpath '/export/servers/hivedatas/score.csv' into table score partition (month='201806');
```

​		多分区联合查询使用union  all来实现

```
select * from score where month = '201806' union all select * from score where month = '201806';
```

​		查看分区

```
show  partitions  score;​	 
```

​		添加一个分区

```
alter table score add partition(month='201805');
```

 		同时添加多个分区

```
alter table score add partition(month='201804') partition(month = '201803');
```

​		删除分区

```
alter table score drop partition(month = '201806');
```

​		练习：

需求描述：现在有一个文件score.csv文件，存放在集群的这个目录下/scoredatas/month=201806，这个文件每天都会生成，存放到对应的日期文件夹下面去，文件别人也需要公用，不能移动。需求，创建hive对应的表，并将数据加载到表中，进行数据统计分析，且删除表之后，数据不能删除

​			1）外部表 

​			2）分区表 按照month字段进行分区

​			3）指定表的存储位置  location

​		创建表之后，要进行表的修复，用于识别分区

```
msck   repair   table  score4;	
```

​		4）分桶表

​		按照分桶的字段，不同的数据分到不同的文件中去。（相当于hadoop中的分区）

​		开启hive的桶表功能

```
set hive.enforce.bucketing=true;
```

​		设置reduce的个数

```
set mapreduce.job.reduces=3;
```

​		创建分桶表

```
create table course (c_id string,c_name string,t_id string) clustered by(c_id) into 3 buckets row format delimited fields terminated by '\t';
```

​		分桶表不能直接加载数据，需要通过间接表来加载数据

​		创建普通表：

```
create table course_common (c_id string,c_name string,t_id string) row format delimited fields terminated by '\t';
```

普通表中加载数据

load data local inpath '/export/servers/hivedatas/course.csv' into table course_common;

通过insert  overwrite给桶表中加载数据

```
insert overwrite table course select * from course_common cluster by(c_id);
```

​		5）修改表

​		表的重命名：

```
alter table score4 rename to score5;
```

​		增加和修改列的信息：

​		（1）添加列

```
alter table score5 add columns (mycol string, mysco string);
```

​		（2）更新列

```
alter table score5 change column mysco mysconew int;
```

​		6）删除表

```
drop table score5;
```

​		7）hive中数据加载

​		通过查询插入数据

​		通过load方式加载数据

```
	load data local inpath '/export/servers/hivedatas/score.csv' overwrite into table score partition(month='201806');
```

​		通过查询方式加载数据

```
	create table score4 like score;
	insert overwrite table score4 partition(month = '201806') select s_id,c_id,s_score from score;
```

​		8）数据的导出

​		1）将查询的结果导出到本地

```
truncate tableinsert overwrite local directory '/export/servers/exporthive' select * from score;
```

​		9）清空表数据

​		只能清空管理表，也就是内部表

```
truncate table score6;
```

##### ​	2）hive查询语法

SELECT [ALL | DISTINCT] select_expr, select_expr, ... 

FROM table_reference

[WHERE where_condition] 

[GROUP BY col_list [HAVING condition]]        #数据的分组

[CLUSTER BY col_list 					       #分文件进行查询

  | [DISTRIBUTE BY col_list] [SORT BY| ORDER BY col_list]    #ORDER BY排序 全局排序

] 													#SORT  BY排序 局部排序

[LIMIT number]                              			#限制查询数据返回的条数



​	8）join连接

​	hive中只支持等值的join连接，不支持非等值连接。

​		内连接（INNER JOIN）：只有进行连接的两个表中都存在与连接条件相匹配的数据才会被保留下来。

​		左外连接：以左边表为基准。

​		右外连接：以右边表为基准。

​		满外连接：以两张表为基准，都查询出来，如果对不上显示NULL。



​	9)排序

​	全排序（Order By）：

​		只有一个reduce

​	局部排序（Sort BY）：

​		要设定reduce的个数。

​	10）分区查询排序：

​		DISTRIBUTE BY	

​	11）cluster  by：

​		当DISTRIBUTE BY和Sort by的字段一致的时候，可以直接使用cluster  by进行代替。

​	        select * from  score cluster by s_id;	

#### 4.hive shell参数介绍

​	1）hive命令行

​		hive -e  

​		hive -f

​	2）参数配置方式

​		1)配置文件

​		hive-site.xml	

​		2)命令行参数：

​		bin/hive -hiveconf   hive.root.logger=INFO,console	

​		3）参数声明：

​		set mapred.reduce.tasks=100;

​		参数的优先级别：

​		参数声明  >   命令行参数   >  配置文件参数（hive）

#### 5.hive函数（udf）

​	hive自身提供一些函数

​	1）查看系统自带的函数

​	hive> show functions;

​	2）显示自带的函数的用法

​	hive> desc function upper;

​	3）详细显示自带的函数的用法

​	hive> desc function extended upper;



​	hive自定义函数：

​		1）UDF(用户自定义函数)：一进一出

​		2）UDAF(用户自定义聚合函数)：多进一出

​		3）UDTF(用户自定义表生成函数)：一进多出



​		在自定义UDF的时候，实现evaluate的方法名称一定不能随意修改

#### 6.hive数据的压缩

​	1）设置map端压缩：

​		1）开启hive中间传输数据压缩功能

​		hive (default)>set hive.exec.compress.intermediate=true;

​		2）开启mapreduce中map输出压缩功能

​		hive (default)>set mapreduce.map.output.compress=true;

​		3）设置mapreduce中map输出数据的压缩方式

​		hive (default)>set mapreduce.map.output.compress.codec= org.apache.hadoop.io.compress.SnappyCodec;

​		4）执行查询语句

  		     select count(1) from score;

​	2）设置reduce端压缩

​	1）开启hive最终输出数据压缩功能

hive (default)>set hive.exec.compress.output=true;

2）开启mapreduce最终输出数据压缩

hive (default)>set mapreduce.output.fileoutputformat.compress=true;

3）设置mapreduce最终数据输出压缩方式

hive (default)> set mapreduce.output.fileoutputformat.compress.codec = org.apache.hadoop.io.compress.SnappyCodec;

4）设置mapreduce最终数据输出压缩为块压缩

hive (default)>set mapreduce.output.fileoutputformat.compress.type=BLOCK;

5）测试一下输出结果是否是压缩文件

insert overwrite local directory '/export/servers/snappy' select * from score distribute by s_id sort by s_id desc;

#### 7.hive数据格式

​	hive的4种主要存储格式：

​	TEXTFILE（行式存储） 、SEQUENCEFILE(行式存储)、

​	ORC（列式存储）、PARQUET（列式存储）。

#### 8.存储和压缩结合

#### 9.hive调优

​	1）fetch获取

​		hive.fetch.task.conversion  默认参数是more

​			   \0. none : disable hive.fetch.task.conversion

   			   \1. minimal : SELECT STAR, FILTER on partition columns, LIMIT only 所有的都要走MR

​     			   \2. more    : SELECT, FILTER, LIMIT only (support TABLESAMPLE and virtual columns)

​		设置本地模式：

​		set hive.exec.mode.local.auto=true; 

​	2）表的优化

​		join原则

​		1）小表join大表

​			小表放在左侧

​			1)字段去重

​			select   count(distinct s_id)  from score;	

​			select count(1) from (select s_id  from score group by s_id) a；  #在map端进行聚合，采用第二种方式

​		2）拆分多个小sql，分别执行

​		3）大表join大表

​			1）key的过滤

​				join前先把key为空数据过滤掉，然后在进行连接。

​			2）key的转换

​				key为空的数据是有用的，需要保留下来。

​			3）key的散列

​				为了避免相同的key分到同一个reduce中，产生数据倾斜，对key进行散列

​		4）大表和小表join

​			底层做了优化，都会是小表join大表

​	3）mapjoin

​			现将小表进行缓存，然后在map端进行join。

​	4）count（distinct）

​		select   count(distinct s_id)  from score;	  #由一个reduce处理 ，效率低

​		select count(1) from (select s_id  from score group by s_id) a；  #在map端进行聚合，采用第二种方式

​	5）笛卡尔积

​		进行查询尽量避免笛卡尔积。

​	6）使用分区剪裁、列剪裁

​		指定字段和指定分区后，在进行查询连接。

​	7）动态分区调整

​		INSERT overwrite TABLE ori_partitioned_target PARTITION (p_time)

​		SELECT id, time, uid, keyword, url_rank, click_num, click_url, p_time

​		FROM ori_partitioned;

​		动态分区就是需要把查询的分区表中分分区字段放在最后一个查询的字段上。

​	8）分桶

​		将数据分桶（分文件）

3.数据倾斜

​	1.map数

​	调整map的任务数？

​	（1）调整块大小--》split

​	（2）split--》maxsize，minsize

​	2.小文件的合并

​		hive中小文件的合并

​		set mapred.max.split.size=112345600;

​		set mapred.min.split.size.per.node=112345600;

​		set mapred.min.split.size.per.rack=112345600;

​		set hive.input.format= org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;

​		hive中，就是通过CombineHiveInputFormat完成的小文件合并

​	3.reduce的个数

​		1）方法一：

​		set mapreduce.job.reduces= 15;	

​		2)方法二：

​		（1）每个Reduce处理的数据量默认是256MB

​		hive.exec.reducers.bytes.per.reducer=256123456

​     		  （2）每个任务最大的reduce数，默认为1009

​		hive.exec.reducers.max=1009

​		（3）计算reducer数的公式

​		N=min(参数2，总输入数据量/参数1)

4.使用EXPLAIN查看计划

​		（1）查看下面这条语句的执行计划

​		hive (default)> explain select * from course;

​		hive (default)> explain select s_id ,avg(s_score) avgscore from score group by s_id;

​		（2）查看详细执行计划

​		hive (default)> explain extended select * from course;

​		hive (default)> explain extended select s_id ,avg(s_score) avgscore from score group by s_id;

5.并行执行

​		set hive.exec.parallel=true;              //打开任务并行执行

​		set hive.exec.parallel.thread.number=16;   #设置并行执行的线程数

6.严格模式

​	hive.mapred.mode

​	1）对于分区表，除非where语句中含有分区字段过滤条件来限制范围，否则不允许执行。

​	2）对于使用了order by语句的查询，要求必须使用limit语句。

​	3）限制笛卡尔积的查询。

7.jvm重用

​	mapreduce.job.jvm.numtasks =10；

8.推测执行

​	hive中 reduce端的推测执行

​	hive.mapred.reduce.tasks.speculative.execution=true；