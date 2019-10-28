-----订单商品信息表BDM层
create database if not exists bdm;
create external table if not exists bdm.itcast_bdm_order_goods(
user_id string,--用户ID
order_id string,--订单ID
order_no string,--订单号
sku_id bigint,--SKU编号
sku_name string,--SKU名称
goods_id bigint,--商品编号
goods_no string,--商品货号
goods_sn string,--商品条码
goods_name string,--商品名称
goods_amount bigint,--商品数量
size_id bigint,--尺码编号
size_name string,--尺码名称
colour_id bigint,--颜色ID
shop_id string,--店铺编号
shop_name string,--店铺名称
curr_price double,--售卖价格
market_price double,--市场价格
discount double,--折扣比例
cost_price double,--成本价格
cost_type string,--成本类型
warehouse string,--所在仓库
first_cart bigint,-- 一级分类ID
first_cart_name string,-- 一级分类名称
second_cart bigint,-- 二级分类ID
second_cart_name string,-- 二级分类名称
third_cart bigint,-- 三级分类ID
third_cart_name string,-- 三级分类名称
dw_date timestamp
) partitioned by (dt string)
row format delimited fields terminated by ','
lines terminated by '\n'
location '/business/itcast_bdm_order_goods';

alter table bdm.itcast_bdm_order_goods add partition (dt='2017-01-01') location '/business/itcast_bdm_order_goods/dt=2017-01-01';
hdfs dfs -put /root/source_data/itcast_bdm_order_goods.txt /business/itcast_bdm_order_goods/dt=2017-01-01

-----订单商品信息表FDM层
create database if not exists fdm;
create  table if not exists fdm.itcast_fdm_order_goods(
user_id	 string,--用户ID 
order_id string,--订单ID
order_no string,--订单号
sku_id bigint,--SKU编号
sku_name string,--SKU名称
goods_id bigint,--商品编号
goods_no string,--商品货号
goods_sn string,--商品条码
goods_name string,--商品名称
goods_amount bigint,--商品数量
size_id bigint,--尺码编号
size_name string,--尺码名称
colour_id bigint,--颜色ID
shop_id string,--店铺编号
shop_name string,--店铺名称
curr_price double,--售卖价格
market_price double,--市场价格
discount double,--折扣比例
cost_price double,--成本价格
cost_type string,--成本类型
warehouse string,--所在仓库
first_cart bigint,-- 一级分类ID
first_cart_name string,-- 一级分类名称
second_cart bigint,-- 二级分类ID
second_cart_name string,-- 二级分类名称
third_cart bigint,-- 三级分类ID
third_cat_name string,-- 三级分类名称
dw_date timestamp
) partitioned by (dt string);


-------加载数据
insert overwrite table fdm.itcast_fdm_order_goods partition(dt='2017-01-01')
select
t.user_id,--用户ID  
t.order_id,--订单ID
t.order_no,--订单号
t.sku_id,--SKU编号
t.sku_name,--SKU名称
t.goods_id,--商品编号
t.goods_no,--商品货号
t.goods_sn,--商品条码
t.goods_name,--商品名称
t.goods_amount,--商品数量
t.size_id,--尺码编号
t.size_name,--尺码名称
t.colour_id,--颜色ID
t.shop_id,--店铺编号
t.shop_name,--店铺名称
t.curr_price,--售卖价格
t.market_price,--市场价格
t.discount,--折扣比例
t.cost_price,--成本价格
t.cost_type,--成本类型
t.warehouse,--所在仓库
t.first_cart,-- 一级分类ID
t.first_cart_name,-- 一级分类名称
t.second_cart,-- 二级分类ID
t.second_cart_name,-- 二级分类名称
t.third_cart,-- 三级分类ID
t.third_cart_name,-- 三级分类名称
from_unixtime(unix_timestamp()) dw_date 
from bdm.itcast_bdm_order_goods t where dt='2017-01-01';
