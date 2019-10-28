#***************************

#**	功能描述：订单宽表模型开发

#***************************
--订单主要信息表BDM层
create database if not exists bdm;
create external table if not exists bdm.itcast_bdm_order(
order_id string,		--订单ID
order_no string,		--订单号
order_date string,		--订单日期
user_id	 string,		--用户ID
user_name string,		--登录名
order_money double,		--订单金额
order_type string,		--订单类型
order_status string,	--订单状态
pay_status string,		--支付状态
pay_type string,		--支付方式  1、在线支付，2、货到付款
order_source string,	--订单来源
update_time timestamp	--订单更新时间
) partitioned by (dt string)
row format delimited fields terminated by ','
lines terminated by '\n'
location '/business/itcast_bdm_order';

alter table bdm.itcast_bdm_order add partition (dt='2017-01-01') location '/business/itcast_bdm_order/dt=2017-01-01';
hdfs dfs -put /root/source_data/itcast_bdm_order.txt /business/itcast_bdm_order/dt=2017-01-01/

--订单主要信息表FDM层
create database if not exists fdm;
create  table if not exists fdm.itcast_fdm_order(
order_id string,		--订单ID
order_no string,		--订单号
order_date string,		--订单日期
user_id	 string,		--用户ID
user_name string,		--登录名
order_money double,		--订单金额
order_type string,		--订单类型
order_status string,	--订单状态
pay_status string,		--支付状态
pay_type string,		--支付方式  1、在线支付，2、货到付款
order_source string,	--订单来源
update_time timestamp,	--订单更新时间
dw_date timestamp
) partitioned by (dt string);

--加载数据
insert overwrite table fdm.itcast_fdm_order partition(dt='2017-01-01')
select 
t.order_id,		--订单ID
t.order_no,		--订单号
t.order_date,	--订单日期
t.user_id,		--用户ID
t.user_name,	--登录名
t.order_money,	--订单金额
t.order_type,	--订单类型
t.order_status,	--订单状态
t.pay_status,	--支付状态
t.pay_type,		--支付方式
t.order_source,	--订单来源
t.update_time timestamp,--订单更新时间
from_unixtime(unix_timestamp())  dw_date 
from bdm.itcast_bdm_order t where dt='2017-01-01';


-------订单详细信息表BDM层----------------
create database if not exists bdm;
create external table if not exists bdm.itcast_bdm_order_desc(
order_id string,		--订单ID
order_no string,		--订单号
consignee string,		--收货人姓名
area_id string,			--收货人地址ID
area_name string,		--地址ID对应的地址段
address string,			--收货人地址
mobile string,			--收货人手机号
telphone string,		--收货人电话
coupon_id bigint,		--使用代金券ID
coupon_money double,	--使用代金券金额
carriage_money double,	--运费
create_time timestamp,	--创建时间
update_time timestamp,	--更新时间
dw_date timestamp
)partitioned by (dt string)
row format delimited fields terminated by ','
location '/business/itcast_bdm_order_desc';
alter table bdm.itcast_bdm_order_desc add partition (dt='2017-01-01') location '/business/itcast_bdm_order_desc/dt=2017-01-01';
hdfs dfs -put /root/source_data/itcast_bdm_order_desc.txt /business/itcast_bdm_order_desc/dt=2017-01-01

-----订单详细信息表FDM层
create database if not exists fdm;
create table if not exists fdm.itcast_fdm_order_desc(
order_id string,		--订单ID
order_no string,		--订单号
consignee string,		--收货人姓名
area_id string,			--收货人地址ID
area_name string,		--地址ID对应的地址段
address string,			--收货人地址
mobile string,			--收货人手机号
telphone string,		--收货人电话
coupon_id bigint,		--使用代金券ID
coupon_money double,	--使用代金券金额
carriage_money double,	--运费
create_time timestamp,	--创建时间
update_time timestamp,	--更新时间
dw_date timestamp
) partitioned by (dt string);

------加载数据
insert overwrite table fdm.itcast_fdm_order_desc partition(dt='2017-01-01')
select 
t.order_id,			--订单ID
t.order_no,			--订单号
t.consignee,		--收货人姓名
t.area_id,			--收货人地址ID
t.area_name,		--地址ID对应的地址段
t.address,			--收货人地址
t.mobile,			--收货人手机号
t.telphone,			--收货人电话
t.coupon_id,		--使用代金券ID
t.coupon_money,		--使用代金券金额
t.carriage_money,	--运费
t.create_time,		--创建时间
t.update_time,		--更新时间
from_unixtime(unix_timestamp())  dw_date 
from bdm.itcast_bdm_order_desc t where dt='2017-01-01';


--------订单宽表模型表GDM-------------------

----加载数据
insert overwrite table gdm.itcast_gdm_order partition(dt='2017-01-01') 
select 
a.order_id,		--订单ID
a.order_no,		--订单号
a.order_date,	--订单日期
a.user_id,		--用户ID
a.user_name,	--用户名
a.order_money,	--订单金额
a.order_type,	--订单类型
a.order_status,	--订单状态
a.pay_status,	--支付类型
a.pay_type,		--支付方式
a.order_source,	--订单来源
b.consignee,	--收货人姓名
b.area_id,		--收货人地址ID
b.area_name,	--地址ID对应的地址段
b.address,		--收货人地址
b.mobile,       --收货人手机号
b.telphone,     --收货人电话
b.coupon_id,    --使用代金券ID
b.coupon_money, --使用代金券金额
b.carriage_money,--运费
b.create_time,  --创建时间
b.update_time,  --更新时间
from_unixtime(unix_timestamp()) dw_date
from (select * from fdm.itcast_fdm_order where dt='2017-01-01') a 
join (select * from fdm.itcast_fdm_order_desc where dt='2017-01-01') b on a.order_id=b.order_id;



