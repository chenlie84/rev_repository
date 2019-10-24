#### 1  用户共同好友

:前称为用户，：称为好友
需求：两两用户间共同好友
A:B,C,D,F,E,O
B:A,C,E,K

A-B   C-E

A:B,C,D,F,E,O
C:F,A,D,I

A-C   D-F

需要2个mapreduce完成此功能
1）mapreduce 找到两两用户
map：key2  			value2
	好友作为key2
	B				A
	
reduce：
	   KEY3        V3
	   <A-E-F-J>   B
2）mapreduce 通过两两用户进行好友的聚合
map：
	 <A-E-F-J>  B
	 <A-C-D-G-L-M>  F
	 M-D-L-A-C-G-	F
	key2   value2
	<A-E>   B
reduce： 
	<A-E>  <B-C-D>
A:B,C,D,F,E,O
B:A,C,E,K
C:F,A,D,I
D:A,E,F,L
E:B,C,D,M,L
F:A,B,C,D,E,O,M
G:A,C,D,E,F
H:A,C,D,E,O
I:A,O
J:B,O
K:A,C,D
L:D,E,F
M:E,F,G
O:A,H,I,J

#### 2倒排索引

	在指定文档中，找到词
	需求：在指定文档中，找到词，并且统计词出现的次数。

​	

#### 3.自定义inputformat

 1）小文件的合并：
	1)hdfs api 完成小文件在local的合并
	2）通过sequencefile的方式完成小文件的合并
	3）har
	

	输入过程中不能使用TextInputformat读取数据。
	需要通过自定义完成小文件的一次性读取。读取的时候，要把字节数据放到字节数组中
	SequenceFileOutputFormat 中，都是字节数组的数据
	TextoutputFormat

#### 4.自定义outputFormat(详见图解)

#### 5.自定义GroupingComparator

	GroupingComparator是hadoop中分组的组件，决定了哪些作为一组，调用一次reduce方法执行。
	默认分组，相同的key，value聚合到一起。
	分区和分组的区别：
	分区：一个reduce任务是一个分区，对于一个reduce任务最后只有一个输出文件。
	分组：一个分组会调用一次reduce方法，相同的key，value进行聚合。


​	
	订单id	商品id	成交金额
Order_0000001	Pdt_01	222.8
Order_0000001	Pdt_05	25.8
Order_0000002	Pdt_03	522.8
Order_0000002	Pdt_04	122.4
Order_0000002	Pdt_05	722.4
Order_0000003	Pdt_01	222.8

需求：每一个订单中的金额最大值
Order_0000001	222.8
Order_0000001	25.8
Order_0000002	722.4
Order_0000002	522.8
Order_0000002	122.4
Order_0000003	222.8


Order_0000001	222.8
Order_0000002	722.4
Order_0000003	222.8

#### 6.yarn资源调度

​	yarn:资源调度管理系统。（cpu和内存）
		     磁盘，网络IO是愿景
	yarn的组件
	Resourcemanager:yarn中主节点，用于接收用户请求，分配任务的资源
		ApplicationManager:用于分配资源
		Scheduler:任务调度器，用于任务的调度
	Nodemanager：从节点，用于执行任务
	AppMaster:一个mr任务的管理器
	Container:容器，指的就是分配的资源（cpu和内存）
	yarn的架构：
	

	yarn中的资源调度：
	1）FIFO：先进先出。
	2）容量调度（capacity  scheduler）：默认Apache 的hadoop采用的调度方式
		调度中分为多个队列，每一个队列又是一个FIFO。
	3）公平调度（fair scheduler）：cdh的版本默认采用的是公平模式
		所有的任务共享相同的资源。


​	
		