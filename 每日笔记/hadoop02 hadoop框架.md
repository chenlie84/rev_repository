## hadoop02 hadoop框架

1. 什么是大数据 , 为什么要对数据进行处理.

### 1.Hadoop的发展简史

 	1. 定义 :  分布式贮存和计算的框架  其中之一
		2. ? 什么是分布式 :  
     		1. 分布式存贮 : 多个节点贮存
     		2. 分布式计算 : 将计算分布到多个 服务器节点上 , 加强计算能力
		3. 起源于 Nutch 想要设计一个全网搜索引擎 ? 怎么贮存海量数据 和 索引问题 
		4. Google的两篇论文
     		1. GFS
     		2. MapReduce
     		3. bigtable (hbase)
		5. Hadoop的架构 (Doug Cutting)  
     		1. HDFS : Hadoop的分布式文件系统 , 用于文件的贮存
     		2. MapReduce : 分布式计算框架

### 2. Hadoop的版本介绍

 1. 最核心的三个版本

     	1. 1.X   
     	2. 2.X 学习版本
     	3. 3.X 最新版本

 2. 版本更迭的年代

      

### 3. Hadoop的三大公司的发行版本介绍

### 4. Hadoop的架构模型(**重点**)

  1. 1.X 了解
       1. HDFS:
            1. NameNode : 集群中的主节点 ,用于管理元数据(核心功能) , 管理datanode节点
              2. datanode:集群的从节点 , 用于数据的存储
              3. secondarynamenode : 辅助名称管理节点,用于辅助namenode管理元数据
              4. 元数据:描述数据的数据
                	1. 书的描述
            2. MapReduce:
              1. jobtracker: 集群中的主节点 , 用于接受用户的请求,并且分发任务到Tasktracker节点,跟踪任务的进度.
                	1. 单点故障 主节点down掉 不能接受用户请求 
              2. tasktacker:集群中从节点,用于执行mapreduce任务.
            3. 2.X版本介绍
            4. # **第一种**  NameNode 于 ResourceManager 单节点架构模型

              1. HDFS 同1.X
              2. yarn : 资源管理调度器 , 用于分配资源, 执行mapreduce ,也可以执行spark , 2.X 单独提出的一个组件
                	1. ResourceManager:资源管理器,用于接受用户的请求,分配资源(CPU, 内存),并且分配任务给nodeManager. 
                     	1. 没有跟踪任务 , 减小主节点压力
                	2. NodeManager:集群中的从节点,用于执行MapReduce.
                	3. appmaster : 用于一个mapreduce的任务跟踪.当提交一个任务就会跟踪,当结束之后就会结束, 一个app就跟踪一个任务
            5. 第二种:NameNode 单节点 于 ResourceManager高可用架构模型
              1. HDFS 同上
              2. yarn 多出另一个备份 ResourceManager节点(stanby)
                	1. 不能同时出现两个ResourceManager主节点(active) ,否则会发生脑裂
            6. 第三种: namenode 高可用的主节点 , ResourceManager单节点
              1. HDFS
                	1. namenode: 一个(active) , 一个(stanby)
                	2. datanode:
                	3. journalnode : 元数据的备份,辅助主节点,管理元数据 , 替代2NN(Second)
                	4. zookeeper:
                	5. zkfc : zk容灾控制器
              2. yarn 单节点同上
            7. 第四种 namenode 和 ResourceManager都是高可用结构

### 5. apache Hadoop的三种架构的介绍安装

 	1.  StandAlone :  单节点模式(往往用于测试)
		2.  伪分布模式: 多节点模式 , 没有高可用
		3.  分布式环境
       	1.  
       	2.  核心端口
             	1.  8020
             	2.  50070
             	3.  19888
             	4.  8088 查看yarn执行**mapreduce**



	1. cdh版本编译  ? 为什么进行编译
	2. cdh版本的zk搭建
	3. cdh伪分布式的搭建(**重点**)
	4. Hadoop集群初体验
	5. Hadoop基准测试  防止其他问题的出现......T