## hadoop02 回顾 

	### 1. 回顾

  	 1.  hadoop分布式存储和计算的框架
          	 1.  hdfs:分布式文件系统
          	 2.  mapreduce : 分布式计算框架
  	 2.  Hadoop版本
          	 1.  1.X 2.X 3.X
  	 3.  三大版本
          	 1.  apache
          	 2.  hortonworks
          	 3.  cdh  兼容性 售后服务好
  	 4.  Hadoop架构
          	 1.  1.x
                  	 1.  hdfs
                          	 1.  namenode
                          	 2.  datannode
                          	 3.  2nn
                  	 2.  marreduce
                          	 1.  jobtracker  追踪任务的完成情况
                          	 2.  tasktracker
          	 2.  .2.x
                  	 1.  模块 
                          	 1.  common
                          	 2.  hdfs
                                  	 1.  namenode
                                	 2.  datannode
                                	 3.  2nn
                          	 3.  yarn  不追踪任务的完成 
                                  	 1.  resourcemanager
                                  	 2.  nodemanager 
                                  	 3.  appmaster  : 用于单一任务的跟踪
                          	 4.  mapreduce
  	 5.  三种架构价绍与安装
          	 1.  standalone : 单机部署 , 测试使用
          	 2.  伪分布模式 : 易发生单点故障 
          	 3.  完全分布式: HA模式
          	 4.  核心配置文件
                  	 1.  core-site.xml
                          	 1.  fs.defaultFS  hdfs://node01:8020
                          	 2.  .指定主节点的位置
                  	 2.  hdfs-site.xml
                          	 1.  hdfs相关配置参数
                  	 3.  mapred-site.xml
                          	 1.  mapreduce相关参数
                  	 4.  yarn-site.xml
                          	 1.  yarn的配置参数,
                          	 2.  yarn.resoumanager.hostname 指定主节点在那个节点
                  	 5.  slave
                          	 1.  指定从节点
  	 6.  CDH版本的编译
          	 1.  获取c库的支持
          	 2.  获取snappy的压缩格式支持
  	 7.  ZK安装
          	 1.  CDH版本的zk, 兼容性最好
  	 8.  CDH 安装 部署(重点)
  	 9.  Hadoop初体验
          	 1.  hdfs
                  	 1.  Hadoop fs	
                  	 2.  hdfs dfs
          	 2.  mapreduce
                  	 1.  hadoop jar
          	 3.  hdfs简单介绍 
                  	 1.  hdfs
                  	 2.  存储 : 按照块 128m
                  	 3.  副本 3
                  	 4.  **hdfs 特性** : 一次写入多次读写
                  	 5.   简单命令: ................
                  	 6.  高级命令:
                          	 1.  quota : 配额
                          	 2.  安全模式:
                                  	 1.  进入 :  hdfs dfsadmin -safemode  enter
                                  	 2.  退出 : hdfs dfsadmin -safemode  leave 
                                  	 3.  状态 : hdfs dfsadmin -safemode  get