## 6月26日  storm 热词统计&项目整合storm

### storm编程模型

1. Topology
2. spout
3. Bolt
4. Stream

### storm的架构

### SplitBolt

``` java
//kafkaSpout是storm自己准备的, 相当于kafka的消费者

//处理上游(kafkaSpout)传递过来的数据,进行切割

//将处理好的数据传递给下游WordCountBolt
```



### WordCountBolt

``` java
//接受上游的数据

//进行逻辑的处理
//统计数据的次数
//封装到一个mapList 
//提交的时候要,转成json


//这种的处理方式有一个大问题,就是会不断的创建对象,对于内存会造成很大的压力

//解决的办法就是,用redis做成一个排行榜 , 取前十位

//因为下游的KafkaBolt不进行数据的处理,他会直接将数据发送给kafka 相当于一个生产者

//下游会指定字段 field = message

```







