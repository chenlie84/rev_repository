#### 1.azkaban

​	azkaban:工作流调度系统。

​	任务调度的实现方式：

​		简单的任务调度：crontab完成定时任务的调度。

​		复杂的任务调度：通过azkaban ,oozie.

​	oozie和azkaban的对比：

​	ooize:重量级的任务调度系统

​	azkaban：轻量级的任务调度系统

​	功能：两者均可以提交定时任务。

​	工作流的定义：

​	azkaban：text文件，key/value形式编写。

​	oozie：xml的形式定义

​	azkaban介绍：

​		azkaban定义了一个文件（.job）,按照key和value的形式进行定义。



#### 2.sqoop

​	sqoop：用于进行数据的导入导出的操作的工具。

​	数据导入：从如mysql orcle导入到hdfs hive中

​	数据导出：从hdfs  hive  hbase  导出到 mysql，orcle中

​	sqoop1和sqoop2：

​		sqoop2提供了web界面。

​	sqoop工作机制:

​		sqoop是通过将命令转化为mapreduce完成数据的导入导出操作，最终调用的只有maptask。主要是对inputformat和outputformat进行定制。

##### ​	数据的导入操作：

​	1）导入数据到hdfs上（默认路径）：

```
bin/sqoop import --connect jdbc:mysql://192.168.42.57:3306/userdb --username root --password 123456 --table emp -m 1
```

​	2）导入数据到hdfs的指定目录上：

```
bin/sqoop import  --connect jdbc:mysql://172.16.43.67:3306/userdb --username root --password admin --delete-target-dir --table emp  --target-dir /sqoop/emp --m 1
```

​	3）导入数据到hdfs上，指定分隔符

```
bin/sqoop import  --connect jdbc:mysql://172.16.43.67:3306/userdb --username root --password admin --delete-target-dir --table emp  --target-dir /sqoop/emp2 --m 1 --fields-terminated-by '\t'
```

​	4）导入数据到hive中

​	需要将hive的jar包copy到sqoop的lib中

​	hive的导入：

```
bin/sqoop import --connect jdbc:mysql://172.16.43.67:3306/userdb --username root --password admin --table emp --fields-terminated-by '\001' --hive-import --hive-table sqooptohive.emp_hive --hive-overwrite --delete-target-dir --m 1
```

​	5）导入到hive中自动创建表

```
bin/sqoop import --connect jdbc:mysql://172.16.43.67:3306/userdb --username root --password admin --table emp_conn --hive-import -m 1 --hive-database sqooptohive;
```

​	6）导入表数据子集

```
bin/sqoop import \
--connect jdbc:mysql://172.16.43.67:3306/userdb \
--username root --password admin --table emp_add \
--target-dir /sqoop/emp_add -m 1  --delete-target-dir \
--where "city = 'sec-bad'"
```

​	7）sql语句查找导入hdfs

```
bin/sqoop import \
--connect jdbc:mysql://172.16.43.67:3306/userdb --username root --password admin \
--delete-target-dir -m 1 \
--query 'select phno from emp_conn where 1=1 and  $CONDITIONS ' \
--target-dir /sqoop/emp_conn

```

​	8)增量导入

​	第一种方式：

```
bin/sqoop import \
--connect jdbc:mysql://192.168.22.22:3306/userdb \
--username root \
--password admin \
--table emp \
--incremental append \
--check-column id \
--last-value 1202  \
-m 1 \
--target-dir /sqoop/increment

```

​	第二种方式：

```
bin/sqoop import \
--connect jdbc:mysql://192.168.22.22:3306/userdb \
--username root \
--password admin  \
--table emp \
--where "create_time > '2018-06-17 00:00:00' and is_delete='1' and create_time < '2018-06-17 23:59:59'" \
--target-dir /sqoop/incement2 \
--incremental append  \
--check-column id  \
--m 1
```

##### ​	数据的导出操作：

​	1)将hdfs数据导入到mysql

```
bin/sqoop export \
--connect jdbc:mysql://172.16.43.67:3306/userdb \
--username root --password admin \
--table emp_out \
--export-dir /sqoop/emp \
--input-fields-terminated-by ","

```



#### 3.离线分析项目

​	1）点击流模型：

​		点击流（Click Stream）是指用户在网站上持续访问的轨迹。

​	2）流量分析举例：

​		1）网站流量质量分析：

​			最好的是直接流量：

​		2)漏斗分析

​	3)流量分析常见分类

​		1）骨灰级指标

​		ip地址：一天内不重复的ip，记录为一次。

​		pageView（pv）：一个用户每访问一个页面。记录为一次。

​		unique pageview（uv）： 1天之内，访问网站的不重复用户数。是通过客户端的cookie来完成的记录。

​		2）基础指标：

​		访问次数：通过session记录的会话次数，一个session记录为一次访问次数

​		网站停留时间：一个session中最后一个页面的时间 - 第一个页面的时间	

​		网页停留时间：第二个页面的时间 - 第一个页面的时间

​		3）