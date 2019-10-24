#### 1.hdfs详细介绍

​	hdfs：分布式文件系统，用于数据的存储。

​	hdfs只是hadoop提供的文件系统之一，是最常用的系统。

​	localfs：

​	webhdfs：hue中整合hdfs

#### 2.hdfs设计目标

​	1）硬件错误是常态 hadoop往往廉价服务器上

​	2）数据流的访问：流式访问数据，常用于批量处理数据，是离线的处理数据

​	3）大数据  适合处理G  T  P级数据

​	4）简单模型 一次写入多次读取

​	5）移动计算比移动数据便宜  

​	6）多种软硬件的可移植

#### 3.hdfs的来源

​	hdfs来源：GFS

#### 4.HDFS的基础架构

​	namenode								datanode

​	元数据									文件数据

​	元数据默认在本地磁盘，					存储在本地磁盘

​	当启动服务的时候，元数据会加载到内存中

#### 5.hdfs的副本和块存储

​	1.副本和块存储

​	hdfs的副本，默认是3

​	块存储：dfs.blocksize  默认hadoop2.x中：128m			

​								     1.x：64M

​	2.块缓存

​	将块内容比较小，且经常读取，此时可以将该块进行缓存。

​	join 将两个文件进行连接处理。

​	DistributedCache用于对块进行缓存



​	3.hdfs的权限验证

​	dfs.permissions.enabled 默认为true ，表示开启权限

​	只会根据用户和组进行权限的认证，权限验证比较薄弱，可以伪造用户

​	只能防止好人做错事，不能防止坏人做坏事。

#### 6.元数据的管理

​	1）元数据：

​		元数据默认情况下，一条大概150b

​		fsimage：最终的元数据会保存到fsimage

​		edits：当进行文件操作的时候，首先会将操作记录保存到edits中（而不是fsimage）

​		dfs.namenode.name.dir  配置fsimage存储位置

​		dfs.namenode.edits.dir   配置edits存储位置

​	2)fsimage文件查看

​		 hdfs oiv -i fsimage_0000000000000000709 -p XML -o a.xml

​	   edits文件查看

#### 7.HDFS的写入过程（详见图解）



#### 8.HDFS的读取过程（详见图解）



#### 9.hdfs的api开发

​	1）解决winutils.exe的问题

​		1）把文件目录放到一个没有中文没有空格的路径下

​		2）在window中配置handoop的环境变量，并且加入path中。

​		3）把hadoop.dll放到window的system32的目录下。

​	2）通过文件系统访问HDFS

​		1)Configuration:设置读取配置文件的类。

​		2）FileSystem：文件系统类。通过fs.defaultFS  

​	3)hdfs小文件的合并

​		1）通常在本地完成小文件的合并，LocalFileSystem

​		2）在hdfs上完成小文件的合并  sequenceFile

​		3）har（归档）



#### 10.mapreduce核心思想

​	mapreduce:分布式计算框架，用于离线的计算。

​	mapreduce的核心思想：分而治之。

​	map阶段：主要负责任务的分，将一个大任务拆分成多个小任务，每一个小任务都不互相产生影响，都是相对独立的。

​	reduce阶段：主要负责任务的合，将map的任务结果进行聚合。



#### 11.mapreduce设计构思

​	1）对于大数据的处理：分而治之

​	2）构建抽象模型：

​		map阶段：

​		reduce阶段：

​		map和reduce阶段都是按照key  value的形式进行数据的处理

​		map: (k1; v1) → [(k2; v2)]

​		reduce: (k2; [v2]) → [(k3; v3)]

​	3）隐藏系统实现细节



#### 12.mapreduce编程规范

​	天龙八部：mapreduce的开发按照以下8个步骤编写。

​	一共有八个步骤其中map阶段分为2个步骤，shuffle阶段4个步骤，reduce阶段分为2个步骤

##### ​	map阶段：

​	1）设置inputformat类，完成数据的读取 （key1，value1）

​	2）自定义map类，完成map阶段的数据处理。（输入key1，value1，输出key2，value2）

##### ​	shuffle阶段：

​	3）分区：将数据默认按照key2进行hash分区。

​	4）排序：数据默认按照key2进行字典排序。

​	5）规约：combiner，将map阶段的数据进行精简；

​	6）分组：默认按照key2，相同的key2的值分到同一个组中进行数据的处理。

​	reduce阶段：

​	7）设置reduce类，完成reduce阶段数据的处理。（输入key2，value2，输出key3，value3）

​	8）设置outputformat类，设置文件最终输出路径。