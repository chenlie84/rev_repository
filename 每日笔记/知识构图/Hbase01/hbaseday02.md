#### 1.hbase和mapreduce集成

#### 2.hbase和hive的对比

​	hive：数据仓库的工具。通过hql完成数据的查询。通过mapreduce执行离线查询。

​	hbase：nosql的数据库。用于存储结构化数据和半结构化数据。用于进行数据的实时查询。

#### 3.hive和hbase的整合

​	1）hive到hbase的映射

```
create table course.hbase_score(id int,cname string,score int)  
stored by 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'  
with serdeproperties("hbase.columns.mapping" = "cf:name,cf:score") 
tblproperties("hbase.table.name" = "hbase_score");
```

​	2）hbase到hive的映射

```
CREATE external TABLE course.hbase2hive(id int, name string, score int) 
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler' 
WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key,cf:name,cf:score") TBLPROPERTIES("hbase.table.name" ="hbase_hive_score");
```

#### 4.sqoop和hbase整合

​	1）sqoop导入数据到hbase

```
bin/sqoop import \
--connect jdbc:mysql://192.168.42.46:3306/library \
--username root \
--password 123456 \
--table book \
--columns "id,name,price" \
--column-family "info" \
--hbase-create-table \
--hbase-row-key "id" \
--hbase-table "hbase_book" \
--num-mappers 1  \
--split-by id

```

​	2——sqoop导出数据到mysql

​		Hbase→hive外部表→hive内部表→通过sqoop→mysql

#### 5.hbase的预分区

​	预分区：在创建表的时候提前进行分区。
​		1）提高数据查询效率
​		2）解决数据倾斜的问题。	

​		每一个region维护着startRow与endRowKey

​	如何进行预分区：

​	1）手动指定预分区

```
create 'staff','info','partition1',SPLITS => ['1000','2000','3000','4000']
```

​	2）使用16进制算法生成预分区

```
create 'staff2','info','partition2',{NUMREGIONS => 15, SPLITALGO => 'HexStringSplit'}
```

​	3）分区规则创建于文件中

```
create 'staff3','partition2',SPLITS_FILE => '/export/servers/splits.txt'
```



#### 6.hbase的rowkey的设计技巧

​	1）rowkey的设计原则

​		 1）rowkey的长度原则	

​			最大长度是64k，建议越短越好，不要超过16个字节

​		2）rowkey散列原则

​			确保数据分散在不同的region中

​		3）rowkey唯一原则

​			保证对于一条数据，rowkey一定是唯一的

​		4）热点问题

​			热点问题：大量的数据集中到同一个region中，产生数据倾斜。

​			解决热点问题：

​			1）加盐

​				在rowkey前加一个随机数。

​			2）哈希

​				在rowkey前加上一个hash数。

​			3）反转

​				将数据前后调转。

​			13801234567   138342334532

​			4）时间戳反转

​				将时间戳加入到rowkey中bin进行反转。

​			1563434582010

#### 7.hbase的协处理器

​	两种协处理器

​	1） observer：和数据库中的trigger类似，完成数据操作前或者后相关的操作。

​	2）endpoint：完成比如：求和，求最大值等相关的操作。

#### 8.hbase的二级索引（了解，elk）

