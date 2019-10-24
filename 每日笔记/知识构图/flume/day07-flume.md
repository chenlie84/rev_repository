#### 1.flume的介绍

​	1.flume：是一个分布式的日志采集框架。

​	运行机制：

​	flume是通过一个个的agent组成：

​	agent主要有3个核心组件：

​		1）source：采集组件，是数据源，

​		2）sink：数据的下沉点，表示数据最终保存的位置。

​		3）channel：管道，用于数据的传递（从source到sink进行数据的传递）

​				event：传递的数据  

​						header和body：其中body就是存储的传递的数据。

​	2.flume案例（详见图解）

