#### 1.mapreduce中分区和reducetask的任务数

​	分区：partition分区，默认按照key2进行hash分区。

​		   按照一定的业务逻辑，将相同的数据交由同一个reduce进行任务的处理。

​	reducetask任务数：默认情况下，只有一个reducetask，在分区过程中，尽量保持和分区数一致（大于等于分区数）。

​		HashPartitioner是默认采用的分区

​		key.hashCode() & Integer.MAX_VALUE  与上最大值，保证hash的值最后正数值

```
public int getPartition(K key, V value,
                          int numReduceTasks) {
    return (key.hashCode() & Integer.MAX_VALUE) % numReduceTasks;
  }
```

#### 2.排序和序列化

​	序列化：把结构化对象转化为字节流

​	反序列化：把字节流转化回结构化对象

​	java中有自己的序列化，但是比较冗余，所以hadoop对使用自己的序列化。

​	Writable是hadoop中的序列化对象。

​	hadoop 中的两个序列化接口：

​	Writable:只是完成了序列化操作

​	WritableCompareable：既有序列化操作，又有2个对象之间的比较

​	数据处理需求：

#### 3.计数器

​	计数器:用于任务执行过程中，相关信息的统计。

​	计数器的方式一：

```
  //获取一个计数器
        Counter counter = context.getCounter("MapRedcue MapTask Redcords", "MapTask Records");
        //counter的计数
        counter.increment(1L);
```

​	计数器的方式二：

​	

```
	static enum Counter{

        REDUCE_INPUT_KEY,REDUCE_INPUT_VALUE
    }
    //定义统计key的个数计数器
        context.getCounter(Counter.REDUCE_INPUT_KEY).increment(1L);
```



#### 4.规约 combiner

​	规约：在map端进行局部聚合。称为map端的reduce。

​	MyCombiner extends  Reducer{

}

#### 5.流量统计

1）需求一，按照手机号统计上行、下行流量和总流量

2）

#### 6.MapTask运行机制和并行度（详见图解）

​	split分片：Math.max(minSize, Math.min(maxSize, blockSize))

​	默认一个分片就是一个块大小。

​	130m文件，2个块，1个分片（不是默认）  如果最后一个块大小小于128m的10%，最后一个分片和倒数第二个分片合并，进行数据处理。

#### 7.MapTask运行机制和并行度（详见图解）

#### 8.Shuffle（详见图解）

#### 9.shuffle阶段的数据压缩

​	为什么进行数据压缩：

​		1.shuffle阶段的数据压缩:map --> reduce

​		减少reduce拉取数据的时间，节省数据处理时间。

​		2.reduce数据处理完成

​		节省存储数据的空间。

​	在代码中设置文件压缩：

```
设置我们的map阶段的压缩
Configuration configuration = new Configuration();
configuration.set("mapreduce.map.output.compress","true");
configuration.set("mapreduce.map.output.compress.codec","org.apache.hadoop.io.compress.SnappyCodec");
设置我们的reduce阶段的压缩
configuration.set("mapreduce.output.fileoutputformat.compress","true");
configuration.set("mapreduce.output.fileoutputformat.compress.type","RECORD");
configuration.set("mapreduce.output.fileoutputformat.compress.codec","org.apache.hadoop.io.compress.SnappyCodec");

```

​	

#### 10 join

​	1)product   order

​	select * from product left join order on product.pid = order.pid;

##### 1.reduce join

​	通过reduce端完成2张表的连接



##### 2.map join

​	在map端完成2张表的连接

​	通过块缓存的方式完成两个文件之间的连接

​	将数据量小的表进行缓存。

​	