
--用户画像-客户消费订单表模型
create database if not exists gdm;
create  table if not exists gdm.itcast_gdm_user_consume_order(
user_id						string,		--客户ID
first_order_time			timestamp,	--第一次消费时间
last_order_time				timestamp,	--最近一次消费时间
first_order_ago				bigint,		--首单距今时间
last_order_ago				bigint,		--尾单距今时间
month1_hg_order_cnt			bigint,		--近30天购买次数（不含退拒）
month1_hg_order_amt			double,		--近30天购买金额（不含退拒）
month2_hg_order_cnt			bigint,		--近60天购买次数（不含退拒）
month2_hg_order_amt			double,		--近60天购买金额（不含退拒）
month3_hg_order_cnt			bigint,		--近90天购买次数（不含退拒）
month3_hg_order_amt			double,		--近90天购买金额（不含退拒）
month1_order_cnt			bigint,		--近30天购买次数（含退拒）
month1_order_amt			double,		--近30天购买金额（含退拒）
month2_order_cnt			bigint,		--近60天购买次数（含退拒）
month2_order_amt			double,		--近60天购买金额（含退拒）
month3_order_cnt			bigint,		--近90天购买次数（含退拒）
month3_order_amt			double,		--近90天购买金额（含退拒）
max_order_amt				double,		--最大消费金额
min_order_amt				double,		--最小消费金额
total_order_cnt				bigint,		--累计消费次数（不含退拒）
total_order_amt				double,		--累计消费金额（不含退拒）
user_avg_amt				double,		--客单价（含退拒）
month3_user_avg_amt			double,		--近90天的客单价
common_address				string,		--常用收货地址
common_paytype				string,		--常用支付方式
month1_cart_cnt				bigint,		--近30天购物车的次数
month1_cart_goods_cnt		bigint,		--近30天购物车商品件数
month1_cart_submit_cnt		bigint,		--近30天购物车提交商品件数
month1_cart_rate			double,		--近30天购物车成功率
month1_cart_cancle_cnt		double,		--近30天购物车放弃件数
return_cnt					bigint,		--退货商品数量
return_amt					double,		--退货商品金额
reject_cnt					bigint,		--拒收商品数量
reject_amt					double,		--拒收商品金额
last_return_time			timestamp,	--最近一次退货时间
school_order_cnt			bigint,		--学校下单总数
company_order_cnt			bigint,		--单位下单总数
home_order_cnt				bigint,		--家里下单总数
forenoon_order_cnt			bigint,		--上午下单总数
afternoon_order_cnt			bigint,		--下午下单总数
night_order_cnt				bigint,		--晚上下单总数
morning_order_cnt			bigint,		--凌晨下单总数
dw_date						timestamp
) partitioned by (dt string);