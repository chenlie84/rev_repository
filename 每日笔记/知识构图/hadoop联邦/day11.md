oozie

#### 1 oozie介绍

​	oozie：是一个任务调度框架。

​	oozie是通过mapreduce完成任务的调度。

​	oozie和hadoop紧耦合的关系。

​	hadoop中historyserver必须启动。

​	oozie中定义的最主要的是一个xml文件，xml文件中定义每一个流程（通过action进行定义）

​	oozie是通过DAG模式完成任务的调度顺序。

​	DAG（DirectAcyclic Graph)	：有向无环图。



##### ​	oozie组件介绍：

​	workflow：工作流，用于定义我们执行的任务。

​	coordinator：协作器，指定时间完成任务调度。

​	bundle：多个coordinator组成一个bundle，完成任务调度。

​	Coordinator ：

​	有两种调用方式：

​	1）通过设定时间完成调度。

​	2）通过数据进行调度。

2oozie架构

3.oozie安装

4.oozie的使用

5.hue整合oozie

6.oozie使用过程中遇到的问题

#### 7.hadoop ha

QJM/Qurom Journal Manager:共享群体日志。

##### ​	Hadoop Federation：

​		hadoop联邦

8 cm的环境搭建

