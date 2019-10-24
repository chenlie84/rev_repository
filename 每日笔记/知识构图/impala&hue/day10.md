### impala

#### 1）impala介绍

​	impala一个cloudera公司提供sql查询的框架。是一个高效查询的框架。impala的查询效率比hive高3-10倍。可以理解为近实时的sql查询。

​	impala是基于hive，使用内存进行计算，官方建议内存128G。

##### ​	impala和hive的关系

​	impala是和hive紧耦合的关系。最主要用到的是元数据。

##### ​	impala优点和缺点

​	优点：

​	1）impala查询速度快，主要基于内存。

​	2）摒弃了mapreduce，调用c++库，在本地执行（短路读取）

​	3）具有数据仓库的特性

​	4）支持odbc jdbc远程连接访问

​	缺点：

​	1）基于内存计算，要求内存大。

​	2）底层使用c++编写，扩展难

​	3）与hive紧耦合

##### ​	impala的架构

​	impalad：（impala server），是一个从节点，用于接收用户的请求，生成执行任务，并执行，将数据返回给client、

​	当部署impalad的时候，尽量和datanode放在一个节点上，用于短路读取。

​	imapala statestore ：是一个主节点，用于管理impala集群的状态信息。

​	impala catalog：是一个主节点，用于元数据的临时存储。

##### ​	impala执行任务的过程

​	1）client提交查询任务给impalad

​	2）impalad获取元数据和数据的地址

​	3）imapad生成单机的执行计划。

​	4）impalad将单机版查询计划分发到其他的impala节点，生成分布式的查询计划。

​	5）执行分布式查询计划，并将结果汇集到一起，返回给客户端。

​	impalad分为frontend和backend两个层次：

​	frontend：

​			1）生成单机查询计划。

​			2）生成分布式查询计划，

​	backend：

​			执行分布式查询计划。

##### 2）impala安装环境准备

​		安装impala之前，要安装hive，hadoop ，mysql。

3）下载依赖包

4）磁盘挂载

5）安装过程

6）制作yum源

7）安装impala

8）配置impala

##### 9）impala的使用

​	1）impala-shell 的外部命令

​		1）impala-shell  -h  查看帮助文档

​		2）-r  刷新整个元数据

​		3）-f  执行查询文件  

​			impala-shell -f  impala.sql

​		4) -q  执行一个sql的查询

​			impala-shell -q "use myhive;select * from score;"

​		5) -i:连接到指定impalad服务执行

​		6）-o  保存执行结果到文件当中去

​		7）-p  显示查询计划

​	2）imapala-shell的内部命令

​		1)help

​		2)refresh 刷新一张表的元数据

​		3）invalidate  metadata：刷新全部元数据

​			注意：在hive中创建的表，impala中看不到，需要更新元数据

​				在impala中创建的表，hive中能直接看到。

​		4）explain：用于查看sql语句的执行计划

​		5）profile命令：在sql后执行，往往用于调优。

hue

​	3）创建数据库

```
show databases;
CREATE DATABASE IF NOT EXISTS mydb1;
drop database  if exists  mydb;

```

​	4）数据的查询

```
select * from employee;
select name,age from employee;
```

​	5）清空表数据

```
truncate  employee;
```

​	6）查询视图

```
CREATE VIEW IF NOT EXISTS employee_view AS select name, age from employee;
```

​	7）order  by

```
Select * from employee ORDER BY id asc;
```

​	8）group  by

```
Select name, sum(salary) from employee Group BY name;
```

​	9）having 语句

```
 select name,max(salary)  as maxsal from employee group by name  having maxsal>20000;
```

​	10)limit

```
select * from employee order by id limit 4;
```

​	1）impala的数据导入方式

```
 load data inpath '/user/root/user.txt' into table user;
```

​		impala中的load方式，只有从hdfs导入，没有本地。

​	2)第二种方式：

```
create  table  user2   as   select * from  user;
```

​	3)第三种方式：

```
insert  into
```

​	4)第四种：

```
insert  into  select  
```

#### Hue

​	Hue：提供了一个web UI界面，将多个大数据框架进行整合，在UI可以直接操作相关的大数据框架。

##### ​	hue的架构：

​	hue server：提供web服务的服务器。

​	Web UI:提供了可视化界面。

​	hue db：hue的数据库

​	hue和其他框架的整合。

