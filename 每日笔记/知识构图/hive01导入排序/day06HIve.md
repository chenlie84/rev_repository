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

​	1)OLTP（On-Line Transaction Processing）:在线联机事务处理：针对数据存储进行事务管理。数据库

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

   CREATE [EXTERNAL] TABLE [IF NOT EXISTS] table_name                            #指定表的名称

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
create table stu3 as select * from stu2;  //完整的复制表的所有数据与结构
```

​		根据已经存在的表结构创建表

```
create table stu4 like stu2;               //只复制表的结构
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

​			分的是**目录**。

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
select * from score where month = '201806' union all select * from score where month = '201807';
```

​		查看分区

```
show  partitions  score;	 
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

``` 
load data local inpath '/export/servers/hivedatas/course.csv' into table course_common;
```

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

5.hive函数（udf）

6.hive数据的压缩

7.hive数据格式

8.存储和压缩结合

9.hive调优

