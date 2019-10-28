
------购物车订单表BDM层
create database if not exists bdm;
create external table if not exists bdm.itcast_bdm_order_cart(
id bigint,--ID
session_id string,--sessionID
user_id string,--用户ID
goods_id string,--商品ID
goods_num bigint,--商品数量
add_time string,--商品加入时间
cancle_time string,--商品取消时间
sumbit_time string,--商品提交时间
dw_date timestamp
) partitioned by (dt string)
row format delimited fields terminated by ','
lines terminated by '\n'
location '/business/itcast_bdm_order_cart';
alter table bdm.itcast_bdm_order_cart add partition (dt='2017-01-01') location '/business/itcast_bdm_order_cart/dt=2017-01-01';
hdfs dfs -put /root/source_data/itcast_bdm_order_cart.txt /business/itcast_bdm_order_cart/dt=2017-01-01

------购物车订单表FDM层
create database if not exists fdm;
create  table  if not exists fdm.itcast_fdm_order_cart(
id bigint,--ID
session_id string,--sessionID
user_id string,--用户ID
goods_id string,--商品ID
goods_num bigint,--商品数量
add_time string,--商品加入时间
cancle_time string,--商品取消时间
sumbit_time string,--商品提交时间
dw_date timestamp
) partitioned by (dt string);



------加载数据-------------
insert overwrite table fdm.itcast_fdm_order_cart partition(dt='2017-01-01')
select 
t.id,--ID
t.session_id,--sessionID
t.user_id,--用户ID
t.goods_id,--商品ID
t.goods_num ,--商品数量
t.add_time,--商品加入时间
t.cancle_time,--商品取消时间
t.sumbit_time,--商品提交时间
from_unixtime(unix_timestamp())  dw_date 
from bdm.itcast_bdm_order_cart t where dt='2017-01-01';
