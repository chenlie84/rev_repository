#### 1.hadoop的介绍及发展历史

​	hadoop的定义：hadoop是一个分布式存储和分布式计算的框架。

​	google的两篇论文：GFS  

​					   MAPREDUCE

​					   bigtable（hbase）

​	hadoop的架构：

​		HDFS：hadoop分布式文件系统，用于文件的存储	

​		mapreduce：分布式计算框架





#### 2.hadoop历史版本介绍

​	历史版本：

​	1.x

​	2.x  学习版本

​	3.x  最新版本

#### 3.hadoop三大公司发行版本介绍

​	1.apache  hadoop：免费版本

​	优点：拥有很多使用者，也有很多人贡献代码。更新速度快

​	缺点：旧版本没有人管理；兼容问题

​	2.hortonwork hadoop

​	免费版本

​	3.cloudera hadoop （cdh）

​	企业应用及版本（收费版本）

​	优点：提供系列服务，保证版本兼容，升级不受影响

​	

4.hadoop的架构模型（重点）

##### ​	1.hadoop1.x版本架构模型（了解）

​	HDFS:

​		namenode：集群中的主节点，用于原理元数据，管理datanode节点

​		datanode：集群中的从节点，用于数据的存储。

​		secondarynamenode：辅助名称管理节点，用于辅助namenode管理元数据。

​	mapreduce：

​		jobtracker：集群中主节点，主要用于接收用户的请求，并且分发任务到tasktracker节点，跟踪任务的进度。

​		tasktracker：集群中的从节点，用于执行mapreduce任务。



​	元数据：描述数据的数据称为元数据。

​	书的描述：作者，出版时间，出版社，书名称，简介，书的位置，书店的层，书架号，书架的层

​	a.txt:上传文件的名称  文件的大小 上传文件ip，上传文件用户，上传时间，文件存储地址

​	

​	2 hadoop2.x版本

​	1）单节点模型

​	HDFS:

​		namenode：集群中的主节点，用于原理元数据，管理datanode节点

​		datanode：集群中的从节点，用于数据的存储。

​		secondarynamenode：辅助名称管理节点，用于辅助namenode管理元数据。

​	YARN:资源管理调度器，用于分配资源，执行mapreduce

​		resourcemanager：集群中的主节点，资源管理器，用于接收用户的请求，分配资源（cpu和内存），并且分配任务给nodemanager。

​		nodemanager：集群中的从节点，用于执行mapreduce。

​		appmaster：用于1个mapreduce的任务跟踪。

​	2）namenode单节点，resourcemanager的HA高可用

​	HDFS:

​		namenode：集群中的主节点，用于原理元数据，管理datanode节点

​		datanode：集群中的从节点，用于数据的存储。

​		secondarynamenode：辅助名称管理节点，用于辅助namenode管理元数据。

​	YARN:资源管理调度器，用于分配资源，执行mapreduce

​		resourcemanager：集群中的主节点，资源管理器，用于接收用户的请求，分配资源（cpu和内存），并且分配任务给nodemanager。

​		resourcemanager是两个节点：1个称为主节点（active），1个称为备用节点（standby）

​		nodemanager：集群中的从节点，用于执行mapreduce。

​		appmaster：用于1个mapreduce的任务跟踪。

​	3）namenode的HA高可用，resourcemanager的单节点

​	HDFS:

​		namenode：集群中的主节点，用于原理元数据，管理datanode节点

​		namenode高可用：1个是主节点（active），1个是备用节点（standby）

​		datanode：集群中的从节点，用于数据的存储。

​		journalnode：元数据冗余备份节点，同时替代2nn辅助管理元数据。

​		zookeeper：用于namenode的协调管理。

​		zkfc：zookeeper failover controller：zk容灾控制器

​	YARN:资源管理调度器，用于分配资源，执行mapreduce

​		resourcemanager：集群中的主节点，资源管理器，用于接收用户的请求，分配资源（cpu和内存），并且分配任务给nodemanager。

​		nodemanager：集群中的从节点，用于执行mapreduce。

​		appmaster：用于1个mapreduce的任务跟踪。

​	3）namenode和resourcemanager的HA高可用



#### 5.apache hadoop三种架构介绍及安装

​	standAlone：单节点模式（往往用于测试使用）

###### ​	haodoop的核心配置文件：

​		core-site.xml  主要用于配置核心参数，配置hdfs的访问地址。

​		hdfs-site.xml  主要用于配置hdfs的相关参数

​		mapred-site.xml 用于配置mapreduce的相关参数

​		yarn-site.xml用于配置yarn的相关参数

​		slaves：主要配置的从节点的服务器地址

​	

###### ​	hadoop的核心端口：

​		8020：hdfs访问端口

​		50070：hadoop webui 端口

​		19888：历史服务web 访问端口

​		8088：yarn执行mapreduce的查看页面端口

​	伪分布模式：hadoop多借点模式，没有HA的高可用

​	完全分布式环境：hadoop的HA高可用（namenode和resourcemanager的高可用）

#### 6.cdh版本的编译

​	1）hadoop需要c库的支持

​	2）snappy：是一种文件的压缩格式，snappy是google出品的一款压缩格式软件。

#### 7.cdh版本的zk搭建

#### 8.cdh伪分布模式搭建（重点）

#### 9.hadoop集群初体验

##### ​	1.hdfs初体验

​	从Linux 本地上传一个文本文件到 hdfs 的/test/input 目录下 

​	hadoop fs -mkdir -p /test/input 

​	hadoop fs -put /root/install.log  /test/input 

##### ​	2.mapreduce初体验

​	hadoop jar  /export/servers/hadoop-2.6.0-cdh5.14.0/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0-cdh5.14.0.jar  pi  2 5	

##### ​	3.hdfs入门介绍

​	HDFS 是Hadoop Distribute File System 的简称，意为：Hadoop分布式文件系统。

##### 	4.hdfs的特性

​	1）hdfs是一个文件系统

​	2）hdfs是分布式存储

###### ​		4.1 master/slave架构（主从架构）

​		主节点：namenode（默认只有一个节点）

​		从节点：datanode（每一个服务器节点，都有一个datanode）

###### ​		4.2分块存储

​		hadoop2.x中一个文件是按照128M分块存储。

​		hadoop1.x中块大小默认是64m

​		如果1kb的文件，按照128m进行分块，但是占用磁盘空间是实际大小，即1kb大小

###### ​		4.3namespace

​		按照传统的文件结构进行访问。

​		hdfs://node01:8020/test/input

###### 		4.4元数据管理

​		namenode管理元数据

###### ​		4.5datanode数据存储

​		datanode用于存储数据

###### ​		4.6副本机制

​		hadoop的默认副本为3

###### ​		4.7一次写入，多次读出

​		hdfs中文件的内容一旦上传，不允许修改。只能完成内容的追加。

​		适合对数据的分析和处理。

##### ​	5.hdfs命令行的使用

​	1）ls  用于查看目录结构

​	2）lsr  递归查看目录结构

​	3）mkdir 创建hdfs目录

​	4）moveFromLocal  从本地移动文件到hdfs上

​	5）mv  在hdfs上移动文件

​		hdfs dfs  -mv   /test/input/b.txt /test

​	6)put 上传文件

​	7）appendToFile 追加文件

​		hdfs dfs  -appendToFile  a.txt  /test/b.txt

​	8)cat 用于查看文件信息内容

​	9）cp 文件复制

​	10）rm 删除文件

​	11）rmr  递归删除文件

​	12）chmod修改文件权限

​		hdfs dfs -chmod -R 777 /a.txt

​	13）chown 修改文件所属用户

​		hdfs dfs -chown hadoop /a.txt

##### ​	6.hdfs的高级命令

###### ​		1）HDFS文件限额配置

​		1.数量限额：一个目录下最多限定的文件数

​		hdfs dfsadmin -setQuota 2 lisi   #作为文件的目录本身也会占用一个名额

​		hdfs dfsadmin -clrQuota /user/root/lisi    # 清除文件数量限制

​		2.空间限额：限额的是按照一个文件的总体块大小进行限额

​		hdfs dfsadmin -setSpaceQuota 4k  lisi

​		hdfs dfsadmin -clrSpaceQuota   #清除空间限额

​		2）hdfs的安全模式

​		hdfs中安全模式是用于hdfs上文件检查。

​		在安全模式下，文件不能上传和下载等操作，只能查看。

​		在hdfs启动的时候，有30秒默认是进入安全模式。

​		hdfs  dfsadmin  -safemode  leave|enter|get

#### 10.hadoop基准测试

​	1）测试写入速度：

​		hadoop jar /export/servers/hadoop-2.6.0-cdh5.14.0/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.6.0-cdh5.14.0.jar  TestDFSIO  -write -nrFiles 10 -fileSize  10MB

​	2）测试读取速度

​		 hadoop jar /export/servers/hadoop-2.6.0-cdh5.14.0/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.6.0-cdh5.14.0.jar TestDFSIO -read -nrFiles 10 -fileSize 10MB

