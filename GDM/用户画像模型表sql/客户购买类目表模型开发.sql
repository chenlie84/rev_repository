#*************************************************************
#		文件名称: itcast_gdm_user_buy_category
#		功能描述: 客户购买类目表
#
#*************************************************************
#计算订单中客户购买情况
drop table if exists gdm.itcast_gdm_user_buy_category_temp;
CREATE TABLE gdm.itcast_gdm_user_buy_category_temp AS 
SELECT 
  a.user_id,
  '' first_category_id,
  '' first_category_name,
  '' second_category_id,
  '' second_catery_name,
  b.third_cart  third_category_id,
  b.third_cat_name  third_category_name,
  SUM(
    CASE
      WHEN a.dat_30 = 1 
      THEN b.goods_amount 
    END
  ) month1_category_cnt, --近30天购物类目次数
  SUM(
    CASE
      WHEN a.dat_30 = 1 
      THEN COALESCE(b.curr_price,0)* COALESCE(b.goods_amount,0)
    END
  ) month1_category_amt, --近30天购物类目金额
  SUM(
    CASE
      WHEN a.dat_90 = 1 
      THEN b.goods_amount 
    END
  ) month3_category_cnt,--近90天购物类目次数
  SUM(
    CASE
      WHEN a.dat_90 = 1 
      THEN COALESCE(b.curr_price, 0)* COALESCE(b.goods_amount, 0)
    END
  ) month3_category_amt,--近90天购物类目金额
  SUM(
    CASE
      WHEN a.dat_180 = 1 
      THEN b.goods_amount 
    END
  ) month6_category_cnt,--近180天购物类目次数
  SUM(
    CASE
      WHEN a.dat_180 = 1 
      THEN COALESCE(b.curr_price, 0) * COALESCE(b.goods_amount, 0)
    END
  ) month6_category_amt,--近180天购物类目金额
  SUM(b.goods_amount) total_category_cnt,--累计购物类目次数
  SUM(
    COALESCE(b.curr_price, 0) * COALESCE(b.goods_amount, 0)
  ) total_category_amt,--累计购物类目金额
  MAX(a.order_date) last_category_time,--最后一次购买类目时间
  DATEDIFF(MAX(a.order_date), '2017-01-01') last_category_ago,--最后一次购买类目距今天数
  FROM_UNIXTIME(UNIX_TIMESTAMP()) dw_date 
FROM
  (SELECT 
    a.*,
    (
      CASE
        WHEN order_date >= DATE_SUB('2017-01-01', 29) 
        AND order_date <= '2017-01-01' 
        THEN
        1
      END
    ) dat_30, --近30天标识
    (
      CASE
        WHEN order_date >= DATE_SUB('2017-01-01', 89) 
        AND order_date <= '2017-01-01' 
        THEN 
        1
      END
    ) dat_90,--近90天标识
    (
      CASE
        WHEN order_date >= DATE_SUB('2017-01-01', 179) 
        AND order_date <= '2017-01-01' 
        THEN 
        1
      END
    ) dat_180  --近180天标识
  FROM
    fdm.itcast_fdm_order a 
  WHERE dt = '2017-01-01') a 
  JOIN 
    (SELECT 
      * 
    FROM
      fdm.itcast_fdm_order_goods 
    WHERE dt = '2017-01-01') b 
    ON (a.user_id = b.user_id) 
GROUP BY a.user_id,b.third_cart,b.third_cat_name;



--购物车中类目情况
drop table if exists gdm.itcast_gdm_user_cart_category_temp;
create table gdm.itcast_gdm_user_cart_category_temp as 
select 
  a.user_id,
  b.third_cart,
  sum(
    case
      when to_date (add_time) >= date_sub('2017-01-01', 29) 
      and to_date (add_time) <= '2017-01-01' 
      then 1 
      else 0
    end
  ) month1_cart_category_cnt, --近30天的标识
  sum(
    case
      when to_date (add_time) >= date_sub('2017-01-01', 89) 
      and to_date (add_time) <= '2017-01-01' 
      then 1 
      else 0
    end
  ) month3_cart_category_cnt,  --近90天的标识
  sum(
    case
      when to_date (add_time) >= date_sub('2017-01-01', 179) 
      and to_date (add_time) <= '2017-01-01' 
      then 1 
      else 0
    end
  ) month6_cart_category_cnt, --近180天的标识
  count(1) total_category_cnt  --累计购物车类目次数
from
  (select 
    * 
  from
    fdm.itcast_fdm_order_cart 
  where dt = '2017-01-01' 
    and to_date (add_time) >= date_sub('2017-01-01', 179) 
    and to_date (add_time) <= '2017-01-01') a 
  left join 
    (select 
      goods_id,
      third_cart 
    from
      fdm.itcast_fdm_order_goods 
    where dt = '2017-01-01' 
    group by goods_id,
      third_cart) b 
    on (a.goods_id = b.goods_id) 
group by user_id,
  b.third_cart ;


--------整合--------
drop table if exists gdm.itcast_gdm_user_category_total;
create table gdm.itcast_gdm_user_category_total as 
select 
  a.user_id,
  b.first_category_id,
  b.first_category_name,
  b.second_category_id,
  b.second_catery_name,
  a.third_category_id,
  b.third_category_name 
from
  (select 
    user_id,
    third_category_id 
  from
    gdm.itcast_gdm_user_buy_category_temp 
  union
  all 
  select 
    user_id,
    third_cart 
  from
    gdm.itcast_gdm_user_cart_category_temp) a 
  left join gdm.itcast_gdm_category_code b 
    on (
      a.third_category_id = b.third_category_id
    ) 
group by a.user_id,
  b.first_category_id,
  b.first_category_name,
  b.second_category_id,
  b.second_catery_name,
  a.third_category_id,
  b.third_category_name ;


-------加载数据
INSERT overwrite TABLE gdm.itcast_gdm_user_buy_category PARTITION (dt = '2017-01-01') 
SELECT 
  t.user_id,
  t.first_category_id,
  t.first_category_name,
  t.second_category_id,
  t.second_catery_name,
  t.third_category_id,
  t.third_category_name,
  t1.month1_category_cnt,
  t1.month1_category_amt,
  t1.month3_category_cnt,
  t1.month3_category_amt,
  t1.month6_category_cnt,
  t1.month6_category_amt,
  t1.total_category_cnt,
  t1.total_category_amt,
  t2.month1_cart_category_cnt,
  t2.month3_cart_category_cnt,
  t2.month6_cart_category_cnt,
  t2.total_category_cnt,
  t1.last_category_time,
  t1.last_category_ago,
  FROM_UNIXTIME(UNIX_TIMESTAMP()) dw_date 
FROM
  gdm.itcast_gdm_user_category_total t 
  LEFT JOIN gdm.itcast_gdm_user_buy_category_temp t1 
    ON (
      t.user_id = t1.user_id 
      AND t.third_category_id = t1.third_category_id
    ) 
  LEFT JOIN gdm.itcast_gdm_user_cart_category_temp t2 
    ON (t.user_id = t2.user_id 
    AND t.third_category_id = t2.third_cart) ;