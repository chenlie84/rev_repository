
--用户画像 客户消费订单表模型开发
create database if not exists gdm;
create  table if not exists gdm.itcast_gdm_user_consume_order( 
user_id string,					--客户ID
first_order_time timestamp,		--第一次消费时间
last_order_time timestamp,		--最近一次消费时间
first_order_ago bigint,			--首单距今时间
last_order_ago bigint,			--尾单距今时间
month1_hg_order_cnt bigint,		--近30天购买次数（不含退拒）
month1_hg_order_amt double,		--近30天购买金额（不含退拒）
month2_hg_order_cnt bigint,		--近60天购买次数（不含退拒）
month2_hg_order_amt double,		--近60天购买金额（不含退拒）
month3_hg_order_cnt bigint,		--近90天购买次数（不含退拒）
month3_hg_order_amt double,		--近90天购买金额（不含退拒）
month1_order_cnt bigint,		--近30天购买次数（含退拒）
month1_order_amt double,		--近30天购买金额（含退拒）
month2_order_cnt bigint,		--近60天购买次数（含退拒）
month2_order_amt double,		--近60天购买金额（含退拒）
month3_order_cnt bigint,		--近90天购买次数（含退拒）
month3_order_amt double,		--近90天购买金额（含退拒）
max_order_amt double,			--最大消费金额
min_order_amt double,			--最小消费金额
total_order_cnt bigint,			--累计消费次数（不含退拒）
total_order_amt double,			--累计消费金额（不含退拒）
user_avg_amt double,			--客单价（含退拒）
month3_user_avg_amt double,		--近90天的客单价
common_address string,			--常用收货地址
common_paytype string,			--常用支付方式
month1_cart_cnt bigint,			--近30天购物车的次数
month1_cart_goods_cnt bigint,	--近30天购物车商品件数
month1_cart_submit_cnt bigint,	--近30天购物车提交商品件数
month1_cart_rate double,		--近30天购物车成功率
month1_cart_cancle_cnt double,	--近30天购物车放弃件数
return_cnt bigint,				--退货商品数量
return_amt double,				--退货商品金额
reject_cnt bigint,				--拒收商品数量
reject_amt double,				--拒收商品金额
last_return_time timestamp,		--最近一次退货时间
school_order_cnt bigint,		--学校下单总数
company_order_cnt bigint,		--单位下单总数
home_order_cnt bigint,			--家里下单总数
forenoon_order_cnt bigint,		--上午下单总数
afternoon_order_cnt bigint,		--下午下单总数
night_order_cnt bigint,			--晚上下单总数
morning_order_cnt bigint,		--凌晨下单总数
dw_date timestamp
) partitioned by (dt string);

---客户消费订单模型表-临时表01--统计订单相关指标
drop table if exists gdm.itcast_gdm_user_consume_order_temp_01;
CREATE TABLE gdm.itcast_gdm_user_consume_order_temp_01 AS 
SELECT 
  t.user_id,
  MIN(order_date) first_order_time,--第一次消费时间
  MAX(order_date) last_order_time,--最近一次消费时间
  DATEDIFF(MIN(order_date), '2017-01-01') first_order_ago,--首单距今时间
  DATEDIFF(MAX(order_date), '2017-01-01') last_order_ago,--尾单距今时间
  SUM(
    CASE
      WHEN t.dat_30 = 1 
      AND t.order_flag = 0 
      THEN 1 
    END
  ) month1_hg_order_cnt,--近30天购买次数（不含退拒）
  SUM(
    CASE
      WHEN t.dat_30 = 1 
      AND t.order_flag = 0 
      THEN t.order_money 
    END
  ) month1_hg_order_amt,--近30天购买金额（不含退拒）
  SUM(
    CASE
      WHEN t.dat_60 = 1 
      AND t.order_flag = 0 
      THEN 1 
    END
  ) month2_hg_order_cnt,--近60天购买次数（不含退拒）
  SUM(
    CASE
      WHEN t.dat_60 = 1 
      AND t.order_flag = 0 
      THEN t.order_money 
    END
  ) month2_hg_order_amt,--近60天购买金额（不含退拒）
  SUM(
    CASE
      WHEN t.dat_90 = 1 
      AND t.order_flag = 0 
      THEN 1 
    END
  ) month3_hg_order_cnt,--近90天购买次数（不含退拒）
  SUM(
    CASE
      WHEN t.dat_90 = 1 
      AND t.order_flag = 0 
      THEN t.order_money 
    END
  ) month3_hg_order_amt,--近90天购买金额（不含退拒）
  SUM(dat_30) month1_order_cnt,--近30天购买次数（含退拒）
  SUM(
    CASE
      WHEN t.dat_30 = 1 
      THEN t.order_money 
    END
  ) month1_order_amt,--近30天购买金额（含退拒）
  SUM(dat_60) month2_order_cnt,--近60天购买次数（含退拒）
  SUM(
    CASE
      WHEN t.dat_60 = 1 
      THEN t.order_money 
    END
  ) month2_order_amt,--近60天购买金额（含退拒）
  SUM(dat_90) month3_order_cnt,--近90天购买次数（含退拒）
 SUM(
    CASE
      WHEN t.dat_90 = 1 
      THEN t.order_money 
    END
  ) month3_order_amt,--近90天购买金额（含退拒）
  MAX(t.order_money) max_order_amt,--最大消费金额
  MIN(t.order_money) min_order_amt,--最小消费金额
  SUM(
    CASE
      WHEN t.order_flag = 0 
      THEN 1
    END
  ) total_order_cnt,--累计消费次数（不含退拒）
  SUM(
    CASE
      WHEN t.order_flag = 0 
      THEN t.order_money 
    END
  ) total_order_amt,--累计消费金额（不含退拒）
  SUM(coupon_money) total_coupon_amt,--累计使用代金券金额
  SUM(t.order_money) / COUNT(1) user_avg_amt,--客单价（含退拒）
  0 month3_user_avg_amt,--近90天的客单价（含退拒）
  0 common_address,--常用收获地址
  0 common_paytype,--常用支付方式
  0 month1_cart_cnt,--最近30天购物车次数
  0 month1_cart_goods_cnt,--最近30天购物车商品件数
  0 month1_cart_submit_cnt,--最近30天购物车提交商品件数
  0 month1_order_rate,--最近30天购物车成功率
  0 month1_cart_cancle_cnt,--最近30天购物车放弃件数
 SUM(
    CASE
      WHEN t.order_status = 3 
      THEN t1.goods_amount 
    END
  ) return_cnt,--退货商品数量
  SUM(
    CASE
      WHEN t.order_status = 3 
      THEN t.order_money 
    END
  ) return_amt,--退货商品金额
  SUM(
    CASE
      WHEN t.order_status = 4 
      THEN t1.goods_amount 
    END
  ) reject_cnt,--拒收商品数量
  SUM(
    CASE
      WHEN t.order_status = 4 
      THEN t.order_money 
    END
  ) reject_amt,--拒收商品金额
  MAX(
    CASE
      WHEN t.order_status = 3 
      THEN t.order_date 
    END
  ) last_return_time,--最近一次退货时间
  SUM(
    CASE
      WHEN t2.order_addr = 1 
      THEN 1 
    END
  ) school_order_cnt,--学校下单总数
  SUM(
    CASE
      WHEN t2.order_addr = 2 
      THEN 1 
    END
  ) company_order_cnt,--单位下单总数
  SUM(
    CASE
      WHEN t2.order_addr = 3 
      THEN 1 
    END
  ) home_order_cnt,--家里下单总数
  SUM(
    CASE
      WHEN t.order_hour >= 8 
      AND t.order_hour <= 11 
      THEN 1 
    END
  ) forenoon_order_cnt,--上午下单总数
  SUM(
    CASE
      WHEN t.order_hour >= 12 
      AND t.order_hour <= 18 
      THEN 1 
    END
  ) afternoon_order_cnt,--下午下单总数
  SUM(
    CASE
      WHEN t.order_hour >= 19 
      AND t.order_hour <= 22 
      THEN 1 
    END
  ) night_order_cnt,--晚上下单总数
  SUM(
    CASE
      WHEN t.order_hour >= 23 
      or t.order_hour <= 7 
      THEN 1 
    END
  ) morning_order_cnt --凌晨下单总数 
FROM
  (SELECT 
    a.*,
    (
      CASE
        WHEN order_date >= DATE_SUB('2017-01-01', 29) 
        AND order_date <= '2017-01-01' 
        THEN 1 
      END
    ) dat_30,
    (
      CASE
        WHEN order_date >= DATE_SUB('2017-01-01', 59) 
        AND order_date <= '2017-01-01' 
        THEN 1 
      END
    ) dat_60,
    (
      CASE
        WHEN order_date >= DATE_SUB('2017-01-01', 89) 
        AND order_date <= '2017-01-01' 
        THEN 1 
      END
    ) dat_90,
    (
      CASE
        WHEN a.order_status IN (3, 4) 
        THEN 1 
        ELSE 0 
      END
    ) order_flag,--退货与拒收标示
    HOUR(order_date) order_hour 
  FROM
    gdm.itcast_gdm_order a 
  WHERE dt = '2017-01-01') t 
  LEFT JOIN 
    (SELECT 
      order_id,
      goods_amount 
    FROM
      fdm.itcast_fdm_order_goods) t1
    ON (t.order_id = t1.order_id) 
  LEFT JOIN 
    (SELECT 
      user_id,
      order_addr 
    FROM
      gdm.itcast_gdm_user_order_addr_model) t2 
    ON (t.user_id = t2.user_id) 
GROUP BY t.user_id ;


---客户消费订单模型表-临时表02----统计购物车相关指标
drop table if exists gdm.itcast_gdm_user_consume_order_temp_02;
CREATE TABLE gdm.itcast_gdm_user_consume_order_temp_02 AS 
SELECT 
  user_id,
  COUNT(1) month1_cart_cnt,--最近30天购物车次数
  SUM(goods_num) month1_cart_goods_cnt,--最近30天购物车商品件数
  SUM(
    CASE
      WHEN sumbit_time <> '' 
      THEN goods_num 
      ELSE 0 
    END
  ) month1_cart_submit_cnt,--最近30天购物车提交商品件数
   SUM(
    CASE
      WHEN sumbit_time <> '' 
      THEN goods_num 
      ELSE 0 
    END
  )/SUM(goods_num) month1_cart_rate,--最近30天购物车成功率
 SUM(
    CASE
      WHEN cancle_time <> '' 
      THEN goods_num 
      ELSE 0 
    END
  ) month1_cart_cancle_cnt  --最近30天购物车放弃件数 
FROM
  fdm.itcast_fdm_order_cart 
WHERE dt = '2017-01-01' 
  AND to_date (add_time) >= DATE_SUB('2017-01-01', 29) 
  AND to_date (add_time) <= '2017-01-01' 
GROUP BY user_id ;


---客户消费订单模型表-临时表03----统计常用收货地址和常用支付方式
drop table if exists gdm.itcast_gdm_user_consume_order_temp_03;
create table gdm.itcast_gdm_user_consume_order_temp_03 as 
select 
  t.user_id,
  t.con,
  t.type,
  t.cnt 
from
  (select 
    b.user_id,
    b.con,
    b.type,
    b.cnt,
    row_number() over(distribute by b.user_id, b.type sort by b.cnt, b.type desc) rn 
  from
    (select 
      a.user_id,concat(
        coalesce(area_name, ''),
        coalesce(address, '')) con,
      'address' type,
      count(1) cnt 
    from
      gdm.itcast_gdm_order a where dt = '2017-01-01' 
    group by a.user_id,
      concat(
        coalesce(area_name, ''), 
        coalesce(address, '')    
      ) 
    union
    all 
    select 
      a.user_id,
      a.pay_type con,
      'pay_type' type,
      count(1) cnt 
    from
      gdm.itcast_gdm_order a 
    where dt = '2017-01-01' 
    group by a.user_id,
      a.pay_type) b) t 
where t.rn = 1 ;


--订单表和购物车表整合
drop table if exists gdm.itcast_gdm_user_consume_order_temp_100;
create table gdm.itcast_gdm_user_consume_order_temp_100 as 
select 
  a.user_id 
from
  (select 
    user_id 
  from
    gdm.itcast_gdm_user_consume_order_temp_01 
  union
  all 
  select 
    user_id 
  from
    gdm.itcast_gdm_user_consume_order_temp_02) a 
group by a.user_id ;


--------加载数据----
INSERT overwrite TABLE gdm.itcast_gdm_user_consume_order PARTITION (dt = '2017-01-01') 
SELECT 
  t.user_id,			 --客户ID
  t1.first_order_time,	 --第一次消费时间
  t1.last_order_time,	 --最近一次消费时间
  t1.first_order_ago,	 --首单距今时间
  t1.last_order_ago,	 --尾单距今时间
  t1.month1_hg_order_cnt,--近30天购买次数（不含退拒）
  t1.month1_hg_order_amt,--近30天购买金额（不含退拒）
  t1.month2_hg_order_cnt,--近60天购买次数（不含退拒）
  t1.month2_hg_order_amt,--近60天购买金额（不含退拒）
  t1.month3_hg_order_cnt,--近90天购买次数（不含退拒）
  t1.month3_hg_order_amt,--近90天购买金额（不含退拒）
  t1.month1_order_cnt,    --近30天购买次数（含退拒）
  t1.month1_order_amt,    --近30天购买金额（含退拒）
  t1.month2_order_cnt,    --近60天购买次数（含退拒）
  t1.month2_order_amt,    --近60天购买金额（含退拒）
  t1.month3_order_cnt,    --近90天购买次数（含退拒）
  t1.month3_order_amt,    --近90天购买金额（含退拒）
  t1.max_order_amt,       --最大消费金额
  t1.min_order_amt,       --最小消费金额
  t1.total_order_cnt,     --累计消费次数（不含退拒）
  t1.total_order_amt,     --累计消费金额（不含退拒）
  t1.user_avg_amt,        --客单价（含退拒）
  (
    CASE
      WHEN t1.month3_order_cnt <> 0 
      THEN t1.month3_order_amt / t1.month3_order_cnt 
      ELSE 0 
    END
  ) month3_user_avg_amt,      --近90天的客单价(含退拒)
  t3.common_address,          --常用收货地址
  t3.common_paytype,          --常用支付方式
  t2.month1_cart_cnt,         --近30天购物车的次数
  t2.month1_cart_goods_cnt,   --近30天购物车商品件数
  t2.month1_cart_submit_cnt,  --近30天购物车提交商品件数
  t2.month1_cart_rate,			  --近30天购物车成功率
  t2.month1_cart_cancle_cnt,	 --近30天购物车放弃件数
  t1.return_cnt,                 --退货商品数量
  t1.return_amt,                 --退货商品金额
  t1.reject_cnt,                 --拒收商品数量
  t1.reject_amt,                 --拒收商品金额
  t1.last_return_time,           --最近一次退货时间
  t1.school_order_cnt,           --学校下单总数
  t1.company_order_cnt,          --单位下单总数
  t1.home_order_cnt,             --家里下单总数
  t1.forenoon_order_cnt,         --上午下单总数
  t1.afternoon_order_cnt,        --下午下单总数
  t1.night_order_cnt,            --晚上下单总数
  t1.morning_order_cnt,          --凌晨下单总数
  FROM_UNIXTIME(UNIX_TIMESTAMP())  dw_date 
FROM                             
  gdm.itcast_gdm_user_consume_order_temp_100 t 
  LEFT JOIN gdm.itcast_gdm_user_consume_order_temp_01 t1 
    ON (t.user_id = t1.user_id) 
  LEFT JOIN gdm.itcast_gdm_user_consume_order_temp_02 t2 
    ON (t.user_id = t2.user_id) 
  LEFT JOIN 
    (SELECT 
      user_id,
        MAX(CASE
          WHEN type = 'address' 
          THEN con 
        END
      ) common_address,
        MAX(CASE
          WHEN type = 'pay_type' 
          THEN con 
        END
      ) common_paytype 
    FROM
      gdm.itcast_gdm_user_consume_order_temp_03 group by user_id) t3 
    ON (t.user_id = t3.user_id);
	