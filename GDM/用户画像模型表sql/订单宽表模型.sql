
--订单宽表模型
create database if not exists gdm;
create table if not exists gdm.itcast_gdm_order(
order_id string,--订单ID
order_no string,--订单号
order_date string,--订单日期
user_id string,--用户ID
user_name string,--登录名
order_money double,--订单金额
order_type string,--订单类型
order_status string,--订单状态
pay_status string,--支付状态
pay_type string,--支付方式  1、在线支付，2、货到付款
order_source string,--订单来源
consignee string,--收货人姓名
area_id string,--收货人地址ID
area_name string,--地址ID对应的地址段（粒度到县）
address string,--收货人地址（手工填写的地址）
mobile string,--收货人手机号
telphone string,--收货人电话
coupon_id bigint,--使用代金券ID
coupon_money double,--使用代金券金额
carriage_money double,--运费
create_time timestamp,--创建时间
update_time timestamp,--更新时间
dw_date timestamp --操作时间
) partitioned by (dt string);