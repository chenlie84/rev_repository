## Spark day03

### 回顾

1. RDD的基本概念 : 是一个弹性分布式数据集
2. RDD的五大特性
   1. 一组分片
   2. 作用在每个分区上的函数 
   3. rdd的依赖关系
   4. 可选 : 对于Key-value对的数据 , 如果产生shuffle的过程 ,就会产生分区函数
   5. 可选 : 数据的本地性(移动数据不如移动计算)
3. rdd的特点 : 
4. rdd的创建方式 : 三种
   1. 从集合中创建 
   2. 从外部文件创建
   3. 从其他的rdd转化而来
5. Rdd的算子介绍 
   1. 算子分为两类  Transaction ,  action
      1. map , flatmap , redeuceBykey
6. 点击流
7. IP地址 : 二分查找 , 广播变量 ,
8. Rdd的依赖关系 : 宽依赖 , 窄依赖
   1. 宽依赖 : shuffle的过程 , 子Rdd当中一个分区的数据来源父Rdd好几个分区,并且产生shuffle过程 : reduceBykey , groupBykey , repartition,sortBykey , union , join
   2. 窄依赖 : 子Rdd
   3. lineage : 血统 , 血统就是记录我们RDD的执行的顺序关系,血统可以用于我的数据恢复
   4. checkpoint : 实现原理的就是血统
9. RDD的缓存 :
   1. 两种 : cache  , persist
   2. cache : 将数据直接放在内存中, 如果内存放不下 , 放不下的部分不缓存
   3. persist:可以根据用户自定义数据存储位置
10. DAG的生成以及shuffle过程



## Spark Sql

1. RDD , df , ds 的优缺点
2. 默认贮存的的格式 : parquet ,列式存储

``` 
读取parquet,产生dataFrame
```

3. dataframe的常用操作
4. Dataset的介绍
5. datasetd的创建方式

















