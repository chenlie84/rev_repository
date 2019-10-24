---
typora-root-url: assets
---

## Spark Day02

### 1.回顾

1. #### spark 特点

   1. ###### 先进的架构

      1. Scala的编程语言
      2. 底层的通信机制采用Netty(spark2.X) ,akka(spark1.x)
      3. 采用DAG图执行引擎,减少多次计算的中间结构写入磁盘,从而提高计算的性能
      4. 统一抽象的RDD (弹性式分布式数据集)

   2. ###### 高效 

      1. 基于内存的分布式计算框架
      2. 把计算的中间结果,cache到内存中

   3. ###### 易用 

      1. 提供了丰富的RDD算子
      2. 提供了各种语言,java ,scala , python,R

   4. ###### 一整套的解决方法

      1. 离线计算 , (spark core , spark sql)
      2. 即席查询(ad - hoc) (spark sql)
      3. 流式计算 (Spark Streaming , Structured Streaming)
      4. 数据挖掘 (MLLIB)
      5. 图处理 (GraphX)

   5. ###### 可以与HAdoop无缝链接

      1. spark 可以读写HDfs , hive , hbase
      2. 可以运行在yarn上

   6. ###### Spark的运行模式 

      1. local模式

         ``` shell 
         -- master [local][local[2]][local[*]]
         ```

      2. stanalone 模式

         ``` shell
         --master spark://node01:7077
         ```

         1. HA模式

            ``` shell
            --master spark://node01:7077,spark://node02:7077
            ```

      3. yarn 的模式

         ``` shell 
         --master yarn (calient , cluster)
         ```

   7. ###### Spark的快速入门

      1. 自定义分区

         1. 默认的分区

            1. HashPartitioner : key.hashcode % NumPartitions

            2. RangePartitioner : 平均分配

            3. Customer Partition : 自定义分区

               ``` Scala
               class 类名(Numpar:int) extends parititoner
               
               override def NumAPrtitions = ???
               
               override def GetPartition = ???
               
               
               ```

### 2.今日内容

1. #### 弹性分布式数据集 RDD (重点!!!!!!!!)

   1. ##### what? 特点?

      1. 分布式数据集 , 是Spark中最基本的数据抽象
      2. RDD是**不可变**的(可变会导致容错成本变高) , 并且是可以**分区**的(分区是**并行执行**的,用于提高效率 , 所用分区同时执行 , 最后一个文件的输出的时间 , 就只是消耗一个处理分区的时间)
      3. **自动容错**
      4. **位置感知性** :提高数据本地计算的概率 , 提高执行的效率
      5. 将数据集缓存到内存中 , 极大的提高了查询的效率

   2. ##### RDD属性

      1. **一组分区** , 即数据集的基本组成单元
      2. 每一个分区都会用一个**算子**来执行
      3. RDD之间的依赖关系
         1. lineage
         2. checkpoint
      4. 一个Partitionner 决定了RDD的分片数量 也决定了Shuffle输出的的数量
         1. HashParitionner
         2. RangePartitionner
      5. 一个列表 , 存储每个Partition的优先位置 , "按照移动数据不如移动计算"的理念 ,

   3. ##### 创建RDD (三种方式)

      1. textFile

         1. 内部机制

            ![1564215098547](/1564215098547.png)

      2. makeRDD

      3. parallelize

   4. ##### RDD(算子)的分类

      ##### ![1564224898884](/1564224898884.png)

      1. Transformation RDD 
         - 是延迟执行的, 执行到Action RDD 的时候,才会执行所有的Transformation RDD(算子)
         - why? 在有限的内存中 , 尽量使用最大化
         - RDD中的所有转换算子都是延迟加载 ,
         - **常用算子的操作**
           - map 对每一个元素进行操作
           - 1.mapPartitionner 是对每一个分区的迭代器 进行操作
             - 优势 : 提高计算性能
             - 缺点 :数据量大会导致  , OOM内存溢出 
           - 2.reduceByKey 和 GroupByKey 算子比较
             - reduceBykey 优于 GroupBykey
           - **3.coalesce 和 repartitionde 的比较** (**面试会问**)
           - 
      2.  Action RDD (只要输出我们要的结果的都是) 

   5. **RDD缓存机制**

      - cache()  --默认在 内存  内存放不下怎么办 放到磁盘
      - persist(StorageLevel)  -- 持久化
        - StorageLevel储存级别 11种
      - **LRU**策略来管理cache种的数据 , 用的少的就会被移除掉(**Memory_Only** 会直接删除 , **Memory_And_Disk** 会将数据转移到Disk上)
      - OFF_HEAP  , 将数据缓存到Tachyon(文件系统 基于内存的)中 

   6. **RDD的依赖关系 (两种)** 

      - **窄依赖** (Narrow Dependency) 

        - 一个父RDD的partition最多只能被子RDD中的一个Partition调用(依赖)

        ![1564197812003](/1564197812003.png)

      - **宽依赖** (Shuffle Dependency)

        一个父RDD中的partition被子RDD中的所有的partition依赖或调用

        ![1564197976448](/1564197976448.png)

        **总结:** 只要有shuffle操作的肯定是宽依赖 

   7. ##### RDD的容错机制 (两种)

      1. **lineage** 血缘关系的容错 (窄依赖)
      2. **checkpoint** 物化的容错机制 (宽依赖)
         1. 注意: 必须在代码中显示的调用,否则依旧使用的是lineage
      3. RDD容错的四大要点
         1. spark的框架层面的容错机制 , 主要是三大层 (调度层 , lineage ,checkpoint层)
         2. 四大核心
            1. stage数据失败, 高层DAG重试
            2. task失败 , 底层调度器重试
            3. lineage 依赖计算
            4. checkpoint物化(**缓存**)

   8. ##### Spark的调度(Schedule)机制

      1. 流程图
      2. DAGSchedule
      3. TaskSchedule
         1. **yarn** **调度机制**
            1. FIFO 先进先出
            2. **FAIR 公平调度** 
            3. **Capacity 能力调度**

   9. ##### Spark运行架构

      ![1564199460978](/1564199460978.png)

   10. ##### Spark on yarn  原理

      实例化SparkContext上下文

      ![1564200628704](/1564200628704.png)

   11. ##### Spark作业的执行过程

       1. stage的划分 

       ![1564210229888](/1564210229888.png)

   12. ##### 任务的调度

   13. ##### shuffle过程

       1. shuffle为什么这么耗时间
       2. shuffle的机制
          1. hash
          2. sort

   14. ##### Spark的2.X的特性

       1. spark1.x   : SparkContext
       2. spark2.X : SparkSession































