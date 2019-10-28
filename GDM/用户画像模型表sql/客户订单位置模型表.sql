-------客户订单地址模型表
create database if not exists gdm;
create  table if not exists gdm.itcast_gdm_user_order_addr_model(
user_id string,--客户ID
order_addr bigint,--1表示学校、2表示单位、3表示家里
user_order_flag string-- 关联标识
)
row format delimited fields terminated by ','
lines terminated by '\n';
load data local inpath '/root/source_data/itcast_gdm_user_order_addr_model.txt' overwrite into table gdm.itcast_gdm_user_order_addr_model;