## hadoop05  mapreduce的增增强 

### 1.回顾

1. 分区
2. 排序和序列化
3. 计数器 : 记录maptask , reduceTask ,相关信息的次数
4. combiner 规约
   1. map端的reduce , 局部聚合
5. MapTask 的工作机制
   1. block --- split ---maptask ---kvbuffer ----spli(分区,排序,排序,规约)---本地磁盘(临时文件)
6. 数据压缩
   1. snappy
7. join
   1. reduce : **相同的key , value聚合到一起进行关联**
   2. map : 小文件进行缓存

### 2.社交粉丝的案例分析

### 3.倒排索引建立

### 4.自定义inputformat , 合并小文件

1. 小文件合并
   1. hdfs api 完成小文件在本地的合并
   2. 通过 sequencefile的方式完成小文件的合并
      1. sequenceFileInputFormat中,都是字节数组的数据
      2. 输入过程中不能使用TextInput format读取数据
      3. 需要自定义inputformat 读取
   3. har (归档)

### 5.自定义outputformat ,

### 6.分组 

1. 自定义GroupingComparator
2. GroupingComparator是Hadoop中分组的功能h组件,决定了那些作为一组,调用一次reduce方法执行.
3. 分区与分组的区别 分区的概念大于分组
   1. 分区 : 一个reduce任务是一个分区,对于一reduce任务最后只输出一个文件
   2. 分组 : 一个分组会调用一次reduce方法,相同的key , Value聚合到一起





### 7.mapreduce的参数优化

### 8.yarn资源调度

1. yarn的执行过程
2. Client提交任务 , 申请Application
3. client提交任务资源到hdfs 上 ,job.jar ,job.xml , split.xml
4. rm找到指定的rm,开启一个容器,运行app master 
5. 