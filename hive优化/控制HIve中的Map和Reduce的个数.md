# 控制Hive中Map和reduce的数量

#### 一、控制Hive中Map和reduce的数量

Hive中的sql查询会生成执行计划，执行计划以MapReduce的方式执行，那么结合数据和集群的大小，map和reduce的数量就会影响到sql执行的效率。

除了要控制Hive生成的Job的数量，也要控制map和reduce的数量。

## 需要确认的问题：

　### a.我们该设置多少个map多少个reduce才合适？
　　map数普遍是通过执行时长来确认的，至少应当保证每个map执行时长在1分钟以上，太短的话意味着大量重复的jvm启用和销毁。具体设置要根据具体任务来处理，有些任务占用cpu大，有些占用io大。
　　我这边的话因为大任务经常搞了上千个map，作为小集群影响还是蛮大的，所以只对监控到的hql产生过大的map和reduce进行调整，经过一些简单测试，map数保证在三四百个其实不影响执行效率。

　### b.设置了上面的参数会带来什么影响？
　　设置map的话，影响不是很大，可能会带来更多的集群之间的io，毕竟要做节点之间的文件合并
　　设置reduce的话，如果使用mapred.reduce.tasks，这个影响就大了，至少会造成同一个session每一个mr的job的reduce都是这么多个，而且reduce个数意味着最后的文件数量的输出，如果小文件太多的话可以打开reduce端的小文件合并参数，set hive.merge.mapredfiles=true

##### 1、map的数量

通常情况下和split的大小有关系，之前写的一篇blog“map和reduce的数量是如何定义的”有描述。

hive中默认的hive.input.format是org.apache.hadoop.hive.ql.io.CombineHiveInputFormat，对于combineHiveInputFormat,它的输入的map数量由三个配置决定，

``` sql
set mapred.max.split.size=256000000;        -- 决定每个map处理的最大的文件大小，单位为B
set mapred.min.split.size.per.node=1;       -- 节点中可以处理的最小的文件大小
set mapred.min.split.size.per.rack=1;        -- 机架中可以处理的最小的文件大小
```

它的主要思路是把输入目录下的大文件分成多个map的输入, 并合并小文件, 做为一个map的输入. 具体的原理是下述三步:

a、根据输入目录下的每个文件,如果其长度超过mapred.max.split.size,以block为单位分成多个split(一个split是一个map的输入),每个split的长度都大于mapred.max.split.size, 因为以block为单位, 因此也会大于blockSize, 此文件剩下的长度如果大于mapred.min.split.size.per.node, 则生成一个split, 否则先暂时保留.

b、现在剩下的都是一些长度效短的碎片,把每个rack下碎片合并, 只要长度超过mapred.max.split.size就合并成一个split, 最后如果剩下的碎片比mapred.min.split.size.per.rack大, 就合并成一个split, 否则暂时保留.

c、把不同rack下的碎片合并, 只要长度超过mapred.max.split.size就合并成一个split, 剩下的碎片无论长度, 合并成一个split.

举例: mapred.max.split.size=1000

mapred.min.split.size.per.node=300

mapred.min.split.size.per.rack=100

输入目录下五个文件,rack1下三个文件,长度为2050,1499,10, rack2下两个文件,长度为1010,80. 另外blockSize为500.

经过第一步, 生成五个split: 1000,1000,1000,499,1000. 剩下的碎片为rack1下:50,10; rack2下10:80

由于两个rack下的碎片和都不超过100, 所以经过第二步, split和碎片都没有变化.

第三步,合并四个碎片成一个split, 长度为150.

如果要减少map数量, 可以调大mapred.max.split.size, 否则调小即可.

其特点是: 一个块至多作为一个map的输入，一个文件可能有多个块，一个文件可能因为块多分给做为不同map的输入， 一个map可能处理多个块，可能处理多个文件。

##### 2、 reduce数量

可以在hive运行sql的时，打印出来，如下：

Number of reduce tasks not specified. Estimated from input data size: 1
In order to change the average load for a reducer (in bytes):
set hive.exec.reducers.bytes.per.reducer=
In order to limit the maximum number of reducers:
set hive.exec.reducers.max=
In order to set a constant number of reducers:
set mapred.reduce.tasks=

reduce数量由以下三个参数决定，

``` sql
set mapred.reduce.tasks=10(强制指定reduce的任务数量)

set hive.exec.reducers.bytes.per.reducer=12312312（每个reduce任务处理的数据量，默认为1000^3=1G）

set hive.exec.reducers.max=999（每个任务最大的reduce数，默认为999）

计算reducer数的公式很简单N=min( hive.exec.reducers.max ，总输入数据量/ hive.exec.reducers.bytes.per.reducer )
```

只有一个reduce的场景：
a、没有group by 的汇总
b、order by
c、笛卡尔积

#### 二、join和Group的优化

对于普通的join操作，会在map端根据key的hash值，shuffle到某一个reduce上去，在reduce端做join连接操作，内存中缓存join左边的表，遍历右边的表，一次做join操作。所以在做join操作时候，将数据量多的表放在join的右边。
当数据量比较大，并且key分布不均匀，大量的key都shuffle到一个reduce上了，就出现了数据的倾斜。

```
   对于Group操作，首先在map端聚合，最后在reduce端坐聚合，hive默认是这样的，以下是相关的参数
     · hive.map.aggr = true是否在 Map 端进行聚合，默认为 True
    · hive.groupby.mapaggr.checkinterval = 100000在 Map 端进行聚合操作的条目数目


   对于join和Group操作都可能会出现数据倾斜。
    以下有几种解决这个问题的常见思路
  1、参数hive.groupby.skewindata = true,解决数据倾斜的万能钥匙，查询计划会有两个 MR Job。第一个 MR Job 中，Map 的输出结果集合会随机分布到 Reduce 中，每个 Reduce 做部分聚合操作，并输出结果，这样处理的结果是相同的 Group By Key 有可能被分发到不同的 Reduce 中，从而达到负载均衡的目的；第二个 MR Job 再根据预处理的数据结果按照 Group By Key 分布到 Reduce 中（这个过程可以保证相同的 Group By Key 被分布到同一个 Reduce 中），最后完成最终的聚合操作。
  2、where的条件写在join里面，使得减少join的数量（经过map端过滤，只输出复合条件的）
  3、mapjoin方式，无reduce操作，在map端做join操作（map端cache小表的全部数据），这种方式下无法执行Full/RIGHT OUTER join操作
  4、对于count(distinct)操作，在map端以group by的字段和count的字段联合作为key，如果有大量相同的key，那么会存在数据倾斜的问题
  5、数据的倾斜还包括，大量的join连接key为空的情况，空的key都hash到一个reduce上去了，解决这个问题，最好把空的key和非空的key做区分
     空的key不做join操作。
12345678910111213
```

当然有的hive操作，不存在数据倾斜的问题，比如数据聚合类的操作，像sum、count，因为已经在map端做了聚合操作了，到reduce端的数据相对少一些，所以不存在这个问题。

#### 四、小文件的合并

大量的小文件导致文件数目过多，给HDFS带来压力，对hive处理的效率影响比较大，可以合并map和reduce产生的文件
· hive.merge.mapfiles = true是否和并 Map 输出文件，默认为 True
· hive.merge.mapredfiles = false是否合并 Reduce 输出文件，默认为 False
· hive.merge.size.per.task = 256*1000*1000合并文件的大小

###### 如何合并小文件，减少map数？

```
    假设一个SQL任务：
         Select count(1) from popt_tbaccountcopy_mes where pt = ‘2012-07-04’;
         该任务的inputdir  /group/p_sdo_data/p_sdo_data_etl/pt/popt_tbaccountcopy_mes/pt=2012-07-04
         共有194个文件，其中很多是远远小于128m的小文件，总大小9G，正常执行会用194个map任务。
         Map总共消耗的计算资源： SLOTS_MILLIS_MAPS= 623,020

         我通过以下方法来在map执行前合并小文件，减少map数：
         set mapred.max.split.size=100000000;
                    set mapred.min.split.size.per.node=100000000;
                    set mapred.min.split.size.per.rack=100000000;
                    set hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;
                 再执行上面的语句，用了74个map任务，map消耗的计算资源：SLOTS_MILLIS_MAPS= 333,500
         对于这个简单SQL任务，执行时间上可能差不多，但节省了一半的计算资源。
         大概解释一下，100000000表示100M, set hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;这个参数表示执行前进行小文件合并，
         前面三个参数确定合并文件块的大小，大于文件块大小128m的，按照128m来分隔，小于128m,大于100m的，按照100m来分隔，把那些小于100m的（包括小文件和分隔大文件剩下的），
         进行合并,最终生成了74个块。
```

###### 如何适当的增加map数？

```
         当input的文件都很大，任务逻辑复杂，map执行非常慢的时候，可以考虑增加Map数，来使得每个map处理的数据量减少，从而提高任务的执行效率。
         假设有这样一个任务：
         Select data_desc,
                count(1),
                count(distinct id),
                sum(case when …),
                sum(case when ...),
                sum(…)
        from a group by data_desc
                   如果表a只有一个文件，大小为120M，但包含几千万的记录，如果用1个map去完成这个任务，肯定是比较耗时的，这种情况下，我们要考虑将这一个文件合理的拆分成多个，
                   这样就可以用多个map任务去完成。
                   set mapred.reduce.tasks=10;
                   create table a_1 as
                   select * from a
                   distribute by rand(123);
                  
                   这样会将a表的记录，随机的分散到包含10个文件的a_1表中，再用a_1代替上面sql中的a表，则会用10个map任务去完成。
                   每个map任务处理大于12M（几百万记录）的数据，效率肯定会好很多。
   
   看上去，貌似这两种有些矛盾，一个是要合并小文件，一个是要把大文件拆成小文件，这点正是重点需要关注的地方，
   根据实际情况，控制map数量需要遵循两个原则：使大数据量利用合适的map数；使单个map任务处理合适的数据量；
```



#### 五、in/exists（not）

通过left semi join 实现 in操作，一个限制就是join右边的表只能出现在join条件中

#### 六、分区裁剪

通过在条件中指定分区，来限制数据扫描的范围，可以极大提高查询的效率

#### 七、排序

order by 排序，只存在一个reduce，这样效率比较低。
可以用sort by操作,通常结合distribute by使用做reduce分区键

```
同类好文
http://blog.csdn.net/zhong_han_jun/article/details/50814246
http://blog.csdn.net/michael_zhu_2004/article/details/8284089
https://www.cnblogs.com/xiohao/p/6404042.html?utm_source=itdadao&utm_medium=referral
```



