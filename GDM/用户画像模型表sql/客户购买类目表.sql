--用户画像 客户购买类目表

create database if not exists gdm;
CREATE  TABLE if not exists gdm.itcast_gdm_user_buy_category (
  user_id STRING,                 --客户ID
  first_category_id BIGINT,       --一级分类ID
  first_category_name STRING,     --一级分类名称
  second_category_id BIGINT,      --二分类ID
  second_catery_name STRING,      --二级分类名称
  third_category_id BIGINT,       --三级分类ID
  third_category_name STRING,     --三级分类名称
  month1_category_cnt BIGINT,     --近30天购物类目次数
  month1_category_amt STRING,     --近30天购物类目金额
  month3_category_cnt BIGINT,     --近90天购物类目次数
  month3_category_amt STRING,     --近90天购物类目金额
  month6_category_cnt BIGINT,     --近180天购物类目次数
  month6_category_amt STRING,     --近180天购物类目金额
  total_category_cnt BIGINT,      --累计购物类目次数
  total_category_amt STRING,      --累计购物类目金额
  month1_cart_category_cnt BIGINT,--近30天购物车类目次数
  month3_cart_category_cnt BIGINT,--近90天购物车类目次数
  month6_cart_category_cnt BIGINT,--近180天购物车类目次数
  total_cart_category_cnt BIGINT, --累计购物车类目次数
  last_category_time TIMESTAMP,   --最后一次购买类目时间
  last_category_ago BIGINT,       --最后一次购买类目距今天数
  dw_date TIMESTAMP
) partitioned BY (dt STRING) ;

