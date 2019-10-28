### hive 中 inner join , left join,right join , full join 的区别

表t1 (id , data)

数据：

1，11

2, 22

3, 33

表t2 (id, data)

数据：

1，11

2, 22

44，44

\---------------------------

注意：

join默认是inner  join，就是当被join的两个表都同时存在字段的时候才会成功

t1 join t2 on t1.id = t2.id

left join 是两个被join的表，根据左侧表，这里是t1,有的字段来计算

t1 left join t2 on t1.id = t2.id

比如说我们统计两个表相同字段的data的和

如果是left join的话，这里结果是

1，11 + 11

2，22 + 22

3， 33 + null

如果左侧是t2，则为

1，11 + 11

2，22 + 22

4， 44 + null

最后full join代表的是全连接：

t1 full join t2 

结果是：

1，11 + 11

2，22 + 22

3，33 + null

4， 44 + null

例子：

join(inner join):

```sql
with t1 as (
    select to_date(created_at) as create_time1, count(*) as cnt1
    from table1
    where to_date(created_at) >= '2018-04-01'
      and to_date(created_at) <= '2018-05-23'
      and dt = '2018-05-28'
    group by to_date(created_at)
    order by to_date(created_at)
  ), 
  t2 as (
    select to_date(created_at) as create_time2, count(*) as cnt2
    from table2
    where to_date(created_at) >= '2018-04-01'
      and to_date(created_at) <= '2018-05-23'
      and dt = '2018-05-28'
    group by to_date(created_at)
    order by to_date(created_at)
  ), 
  t3 as (
    select to_date(created_at) as create_time3, count(*) as cnt3
    from table3
    where to_date(created_at) >= '2018-04-01'
      and to_date(created_at) <= '2018-05-23'
      and dt = '2018-05-28'
    group by to_date(created_at)
    order by to_date(created_at)
  ), 
  t4 as (
    select to_date(created_at) as create_time4, count(*) as cnt4
    from table4
    where to_date(created_at) >= '2018-04-01'
      and to_date(created_at) <= '2018-05-23'
      and dt = '2018-05-28'
    group by to_date(created_at)
    order by to_date(created_at)
  ), 
  t5 as (
    select to_date(created_at) as create_time5, count(*) as cnt5
    from table5
    where to_date(created_at) >= '2018-04-01'
      and to_date(created_at) <= '2018-05-23'
      and dt = '2018-05-28'
    group by to_date(created_at)
    order by to_date(created_at)
  ), 
  t6 as (
    select to_date(created_at) as create_time6, count(*) as cnt6
    from table6
    where to_date(created_at) >= '2018-04-01'
      and to_date(created_at) <= '2018-05-23'
      and dt = '2018-05-28'
    group by to_date(created_at)
    order by to_date(created_at)
  )
select t1.create_time1
  , t1.cnt1 + t2.cnt2 + t3.cnt3 + t4.cnt4 + t5.cnt5 + t6.cnt6
from t1
  join t2 on t1.create_time1 = t2.create_time2
  join t3 on t1.create_time1 = t3.create_time3
  join t4 on t1.create_time1 = t4.create_time4
  join t5 on t1.create_time1 = t5.create_time5
  join t6 on t1.create_time1 = t6.create_time6
```

left join:

```sql
with t1 as (
    select to_date(created_at) as create_time1, count(*) as cnt1
    from table1
    where to_date(created_at) >= '2018-04-01'
      and to_date(created_at) <= '2018-05-23'
      and dt = '2018-05-28'
    group by to_date(created_at)
    order by to_date(created_at)
  ), 
  t2 as (
    select to_date(created_at) as create_time2, count(*) as cnt2
    from table2
    where to_date(created_at) >= '2018-04-01'
      and to_date(created_at) <= '2018-05-23'
      and dt = '2018-05-28'
    group by to_date(created_at)
    order by to_date(created_at)
  ), 
  t3 as (
    select to_date(created_at) as create_time3, count(*) as cnt3
    from table3
    where to_date(created_at) >= '2018-04-01'
      and to_date(created_at) <= '2018-05-23'
      and dt = '2018-05-28'
    group by to_date(created_at)
    order by to_date(created_at)
  ), 
  t4 as (
    select to_date(created_at) as create_time4, count(*) as cnt4
    from table4
    where to_date(created_at) >= '2018-04-01'
      and to_date(created_at) <= '2018-05-23'
      and dt = '2018-05-28'
    group by to_date(created_at)
    order by to_date(created_at)
  ), 
  t5 as (
    select to_date(created_at) as create_time5, count(*) as cnt5
    from table5
    where to_date(created_at) >= '2018-04-01'
      and to_date(created_at) <= '2018-05-23'
      and dt = '2018-05-28'
    group by to_date(created_at)
    order by to_date(created_at)
  ), 
  t6 as (
    select to_date(created_at) as create_time6, count(*) as cnt6
    from table6
    where to_date(created_at) >= '2018-04-01'
      and to_date(created_at) <= '2018-05-23'
      and dt = '2018-05-28'
    group by to_date(created_at)
    order by to_date(created_at)
  )
select t1.create_time1
  , t1.cnt1 + t2.cnt2 + t3.cnt3 + t4.cnt4 + t5.cnt5 + t6.cnt6
from t1
  left join t2 on t1.create_time1 = t2.create_time2
  left join t3 on t1.create_time1 = t3.create_time3
  left join t4 on t1.create_time1 = t4.create_time4
  left join t5 on t1.create_time1 = t5.create_time5
  left join t6 on t1.create_time1 = t6.create_time6
  order by t1.create_time1
```

 

full join:

```sql
with table_a as (
        select t2.city_name, count(DISTINCT t1.bicycle_no) as res1, count(DISTINCT t2.uuap_id) as res2
        from table1 t1
            left join table2 t2 on t1.operator_id = t2.uuap_id
        where t1.dt = '2018-05-29'
            and t1.tags = 'repair'
            and t1.status = 1
            and to_date(t1.created_at) >= '2018-05-04'
            and to_date(t1.created_at) <= '2018-05-10'
            and t2.post_name = 'xxx'
        group by t2.city_name
    ), 
    table_b as (
        select t2.city_name
            , round(count(DISTINCT t1.bicycle_no) / count(DISTINCT t2.uuap_id), 0) as res3
        from table1 t1
            left join table2 t2 on t1.operator_id = t2.uuap_id
        where t1.dt = '2018-05-29'
            and to_date(t1.created_at) >= '2018-05-04'
            and to_date(t1.created_at) <= '2018-05-10'
            and t2.post_name = 'xxx'
        group by t2.city_name
    ), 
    table_c as (
        select t2.city_name
            , round(count(DISTINCT t1.bicycle_no) / count(DISTINCT t2.uuap_id), 0) as res4
        from table1 t1
            left join table2 t2 on t1.operator_id = t2.uuap_id
        where t1.dt = '2018-05-29'
            and t1.tags = 'repair'
            and t1.status = 1
            and to_date(t1.created_at) >= '2018-05-04'
            and to_date(t1.created_at) <= '2018-05-10'
            and t2.post_name = 'xxx'
        group by t2.city_name
    )
select if(table_a.city_name is null, if(table_b.city_name is null, table_c.city_name, table_b.city_name), table_a.city_name), table_a.res1, table_a.res2, table_b.res3, table_c.res4
from table_a
    full join table_b on table_a.city_name = table_b.city_name
    full join table_c on table_a.city_name = table_c.city_name
order by table_a.res1 desc
```