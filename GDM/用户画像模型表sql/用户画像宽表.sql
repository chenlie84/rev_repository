--用户画像宽表
create database if not exists adm;
create table if not exists adm.itcast_adm_personas(
user_id string			    ,--用户ID
user_name string			,--用户登陆名
user_sex  string			,--用户性别
user_birthday string		,--用户生日
user_age  bigint			,--用户年龄
constellation string		,--用户星座
province string			    ,--省份
city string					,--城市
city_level string			,--城市等级
hex_mail string				,--邮箱
op_mail string				,--邮箱运营商
hex_phone string			,--手机号
fore_phone string			,--手机前3位
op_phone string				,--手机运营商
add_time timestamp			,--注册时间
login_ip string				,--登陆ip地址
login_source string			,--登陆来源
request_user string			,--邀请人
total_mark bigint			,--会员积分
used_mark bigint			,--已使用积分
level_name string			,--会员等级名称
blacklist bigint			,--用户黑名单
is_married bigint			,--婚姻状况
education string			,--学历
monthly_money double		,--收入
profession string			,--职业
sex_model bigint			,--性别模型
is_pregnant_woman bigint	,--是否孕妇
is_have_children bigint		,--是否有小孩
children_sex_rate double	,--孩子性别概率
children_age_rate double	,--孩子年龄概率
is_have_car bigint			,--是否有车
potential_car_user_rate double,--潜在汽车用户概率
phone_brand string			,--使用手机品牌
phone_brand_level string	,--使用手机品牌档次
phone_cnt bigint			,--使用多少种不同的手机
change_phone_rate bigint	,--更换手机频率
majia_flag string			,--马甲标志
majie_account_cnt bigint	,--马甲账号数量
loyal_model bigint			,--用户忠诚度
shopping_type_model bigint	,--用户购物类型
figure_model bigint			,--身材
stature_model bigint		,--身高
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
total_category_amt STRING,      --累计购物类目次数
month1_cart_category_cnt BIGINT,--近30天购物车类目次数
month3_cart_category_cnt BIGINT,--近90天购物车类目次数
month6_cart_category_cnt BIGINT,--近180天购物车类目次数
total_cart_category_cnt BIGINT, --累计购物车类目次数
last_category_time TIMESTAMP,   --最后一次购买类目时间
last_category_ago BIGINT,       --最后一次购买类目距今天数
latest_pc_visit_date string,            --最近一次PC端访问日期
latest_app_visit_date string,           --最近一次APP端访问日期
latest_pc_visit_session string,         --最近一次PC端访问的session
latest_pc_cookies string,               --最近一次PC端访问的cookies
latest_pc_pv string,                    --最近一次PC端访问的PV
latest_pc_browser_name string,          --最近一次PC端访问使用的游览器
latest_pc_visit_os string,              --最近一次PC端访问使用的操作系统
latest_app_name string,                 --最近一次APP端访问app名称
latest_app_visit_os string,             --最近一次APP端访问使用的操作系统
latest_visit_ip string,                 --最近一次访问IP(不分APP与PC)
latest_city string,                     --最近一次访问城市(不分APP与PC)
latest_province string,                 --最近一次访问省份(不分APP与PC)
first_pc_visit_date string,             --第一次PC端访问日期
first_app_visit_date string,            --第一次APP端访问日期
first_pc_visit_session string,          --第一次PC端访问的session
first_pc_cookies string,                --第一次PC端访问的cookies
first_pc_pv string,                     --第一次PC端访问的PV
first_pc_browser_name string,           --第一次PC端访问使用的游览器
first_pc_visit_os string,               --第一次PC端访问使用的操作系统
first_app_name string,                  --第一次APP端访问app名称
first_app_visit_os string,              --第一次APP端访问使用的操作系统
first_visit_ip string,                  --第一次访问IP(不分APP与PC)
first_city string,                      --第一次访问城市(不分APP与PC)
first_province string,                  --第一次访问省份(不分APP与PC)
day7_app_cnt bigint,                    --近7天APP端访问次数
day15_app_cnt bigint,                   --近15天APP端访问次数
month1_app_cnt bigint,                  --近30天APP端访问次数
month2_app_cnt bigint,                  --近60天APP端访问次数
month3_app_cnt bigint,                  --近90天APP端访问次数	
day7_pc_cnt bigint,                     --近7天PC端访问次数
day15_pc_cnt bigint,                    --近15天PC端访问次数
month1_pc_cnt bigint,                   --近30天PC端访问次数
month2_pc_cnt bigint,                   --近60天PC端访问次数
month3_pc_cnt bigint,                   --近90天PC端访问次数
month1_pc_days bigint,                  --近30天PC端访问天数
month1_pc_pv bigint,                    --近30天PC端访问PV
month1_pc_avg_pv bigint,                --近30天PC端访问平均PV
month1_pc_diff_ip_cnt bigint,           --近30天PC端访问不同ip数
month1_pc_diff_cookie_cnt bigint,       --近30天PC端访问不同的cookie数
month1_pc_common_ip string,             --近30天PC端访问最常用ip
month1_pc_common_cookie string,         --近30天PC端访问最常用的cookie
month1_pc_common_browser_name string,   --近30天PC端访问最常用游览器
month1_pc_common_os string,             --近30天PC端访问最常用的操作系统
month1_hour025_cnt bigint,              --近30天PC端0-5点访问次数
month1_hour627_cnt bigint,              --近30天PC端6-7点访问次数
month1_hour829_cnt bigint,              --近30天PC端8-9点访问次数
month1_hour10212_cnt bigint,            --近30天PC端10-12点访问次数
month1_hour13214_cnt bigint,            --近30天PC端13-14点访问次数
month1_hour15217_cnt bigint,            --近30天PC端15-17点访问次数
month1_hour18219_cnt bigint,            --近30天PC端18-19点访问次数
month1_hour20221_cnt bigint,            --近30天PC端20-21点访问次数
month1_hour22223_cnt bigint             --近30天PC端22-23点访问次数
);

-----加载数据
insert overwrite table adm.itcast_adm_personas 
select  
a.user_id,
a.user_name,
a.user_sex,
a.user_birthday,
a.user_age,
a.constellation,
a.province,
a.city,
a.city_level,
a.hex_mail,
a.op_mail,
a.hex_phone,
a.fore_phone,
a.op_phone,
a.add_time,
a.login_ip,
a.login_source,
a.request_user,
a.total_mark,
a.used_mark,
a.level_name,
a.blacklist,
a.is_married,
a.education,
a.monthly_money,
a.profession, 
a.sex_model,
a.is_pregnant_woman,
a.is_have_children,
a.children_sex_rate,
a.children_age_rate,
a.is_have_car,
a.potential_car_user_rate,
a.phone_brand,
a.phone_brand_level,
a.phone_cnt,
a.change_phone_rate,
a.majia_flag,
a.majie_account_cnt,
a.loyal_model,
a.shopping_type_model,
a.figure_model,
a.stature_model,
b.first_order_time,	 
b.last_order_time,	 
b.first_order_ago,	 
b.last_order_ago,	 
b.month1_hg_order_cnt,
b.month1_hg_order_amt,
b.month2_hg_order_cnt,
b.month2_hg_order_amt,
b.month3_hg_order_cnt,
b.month3_hg_order_amt,
b.month1_order_cnt,   
b.month1_order_amt,   
b.month2_order_cnt,   
b.month2_order_amt,   
b.month3_order_cnt,   
b.month3_order_amt,   
b.max_order_amt,      
b.min_order_amt,      
b.total_order_cnt,    
b.total_order_amt,    
b.user_avg_amt,       
b.month3_user_avg_amt,    
b.common_address,         
b.common_paytype,         
b.month1_cart_cnt,        
b.month1_cart_goods_cnt,  
b.month1_cart_submit_cnt, 
b.month1_cart_rate, 
b.month1_cart_cancle_cnt,
b.return_cnt,             
b.return_amt,             
b.reject_cnt,             
b.reject_amt,             
b.last_return_time,       
b.school_order_cnt,       
b.company_order_cnt,      
b.home_order_cnt,         
b.forenoon_order_cnt,     
b.afternoon_order_cnt,    
b.night_order_cnt,        
b.morning_order_cnt,      
c.first_category_id,
c.first_category_name,
c.second_category_id,
c.second_catery_name,
c.third_category_id,
c.third_category_name,
c.month1_category_cnt,
c.month1_category_amt,
c.month3_category_cnt,
c.month3_category_amt,
c.month6_category_cnt,
c.month6_category_amt,
c.total_category_cnt,
c.total_category_amt,
c.month1_category_cnt,
c.month3_category_cnt,
c.month6_category_cnt,
c.total_category_cnt,
c.last_category_time,
c.last_category_ago,
d.latest_pc_visit_date,         
d.latest_app_visit_date,        
d.latest_pc_visit_session,      
d.latest_pc_cookies,            
d.latest_pc_pv,                 
d.latest_pc_browser_name,       
d.latest_pc_visit_os,           
d.latest_app_name,              
d.latest_app_visit_os,          
d.latest_visit_ip,              
d.latest_city,                  
d.latest_province,              
d.first_pc_visit_date,          
d.first_app_visit_date,         
d.first_pc_visit_session,       
d.first_pc_cookies,             
d.first_pc_pv,                  
d.first_pc_browser_name,        
d.first_pc_visit_os,            
d.first_app_name,               
d.first_app_visit_os,           
d.first_visit_ip,               
d.first_city,                   
d.first_province,               
d.day7_app_cnt,                 
d.day15_app_cnt,                
d.month1_app_cnt,               
d.month2_app_cnt,               
d.month3_app_cnt,               
d.day7_pc_cnt,                  
d.day15_pc_cnt,                 
d.month1_pc_cnt,                
d.month2_pc_cnt,                
d.month3_pc_cnt,                
d.month1_pc_days,               
d.month1_pc_pv,                 
d.month1_pc_avg_pv,             
d.month1_pc_diff_ip_cnt,        
d.month1_pc_diff_cookie_cnt,    
d.month1_pc_common_ip,          
d.month1_pc_common_cookie,      
d.month1_pc_common_browser_name,
d.month1_pc_common_os,          
d.month1_hour025_cnt,           
d.month1_hour627_cnt,           
d.month1_hour829_cnt,           
d.month1_hour10212_cnt,         
d.month1_hour13214_cnt,         
d.month1_hour15217_cnt,         
d.month1_hour18219_cnt,         
d.month1_hour20221_cnt,         
d.month1_hour22223_cnt          
from gdm.itcast_gdm_user_basic a 
left join gdm.itcast_gdm_user_consume_order b on a.user_id=b.user_id 
left join gdm.itcast_gdm_user_buy_category c on a.user_id=c.user_id 
left join gdm.itcast_gdm_user_visit d on a.user_id=d.user_id;

------建立hive/hbase关联表

CREATE TABLE if not exists adm.itcast_adm_personas_hbase (
  user_id STRING,
  user_name STRING,
  user_sex STRING,
  user_birthday STRING,
  user_age BIGINT,
  constellation STRING,
  province STRING,
  city STRING,
  city_level STRING,
  hex_mail STRING,
  op_mail STRING,
  hex_phone STRING,
  fore_phone STRING,
  op_phone STRING,
  add_time TIMESTAMP,
  login_ip STRING,
  login_source STRING,
  request_user STRING,
  total_mark BIGINT,
  used_mark BIGINT,
  level_name STRING,
  blacklist BIGINT,
  is_married BIGINT,
  education STRING,
  monthly_money DOUBLE,
  profession STRING,
  sex_model BIGINT,
  is_pregnant_woman BIGINT,
  is_have_children BIGINT,
  children_sex_rate DOUBLE,
  children_age_rate DOUBLE,
  is_have_car BIGINT,
  potential_car_user_rate DOUBLE,
  phone_brand STRING,
  phone_brand_level STRING,
  phone_cnt BIGINT,
  change_phone_rate BIGINT,
  majia_flag STRING,
  majie_account_cnt BIGINT,
  loyal_model BIGINT,
  shopping_type_model BIGINT,
  figure_model BIGINT,
  stature_model BIGINT,
  first_order_time TIMESTAMP,
  last_order_time TIMESTAMP,
  first_order_ago BIGINT,
  last_order_ago BIGINT,
  month1_hg_order_cnt BIGINT,
  month1_hg_order_amt DOUBLE,
  month2_hg_order_cnt BIGINT,
  month2_hg_order_amt DOUBLE,
  month3_hg_order_cnt BIGINT,
  month3_hg_order_amt DOUBLE,
  month1_order_cnt BIGINT,
  month1_order_amt DOUBLE,
  month2_order_cnt BIGINT,
  month2_order_amt DOUBLE,
  month3_order_cnt BIGINT,
  month3_order_amt DOUBLE,
  max_order_amt DOUBLE,
  min_order_amt DOUBLE,
  total_order_cnt BIGINT,
  total_order_amt DOUBLE,
  user_avg_amt DOUBLE,
  month3_user_avg_amt DOUBLE,
  common_address STRING,
  common_paytype STRING,
  month1_cart_cnt BIGINT,
  month1_cart_goods_cnt BIGINT,
  month1_cart_submit_cnt BIGINT,
  month1_cart_rate DOUBLE,
  month1_cart_cancle_cnt DOUBLE,
  return_cnt BIGINT,
  return_amt DOUBLE,
  reject_cnt BIGINT,
  reject_amt DOUBLE,
  last_return_time TIMESTAMP,
  school_order_cnt BIGINT,
  company_order_cnt BIGINT,
  home_order_cnt BIGINT,
  forenoon_order_cnt BIGINT,
  afternoon_order_cnt BIGINT,
  night_order_cnt BIGINT,
  morning_order_cnt BIGINT,
  first_category_id BIGINT,
  first_category_name STRING,
  second_category_id BIGINT,
  second_catery_name STRING,
  third_category_id BIGINT,
  third_category_name STRING,
  month1_category_cnt BIGINT,
  month1_category_amt STRING,
  month3_category_cnt BIGINT,
  month3_category_amt STRING,
  month6_category_cnt BIGINT,
  month6_category_amt STRING,
  total_category_cnt BIGINT,
  total_category_amt STRING,
  month1_cart_category_cnt BIGINT,
  month3_cart_category_cnt BIGINT,
  month6_cart_category_cnt BIGINT,
  total_cart_category_cnt BIGINT,
  last_category_time TIMESTAMP,
  last_category_ago BIGINT,
  latest_pc_visit_date STRING,
  latest_app_visit_date STRING,
  latest_pc_visit_session STRING,
  latest_pc_cookies STRING,
  latest_pc_pv STRING,
  latest_pc_browser_name STRING,
  latest_pc_visit_os STRING,
  latest_app_name STRING,
  latest_app_visit_os STRING,
  latest_visit_ip STRING,
  latest_city STRING,
  latest_province STRING,
  first_pc_visit_date STRING,
  first_app_visit_date STRING,
  first_pc_visit_session STRING,
  first_pc_cookies STRING,
  first_pc_pv STRING,
  first_pc_browser_name STRING,
  first_pc_visit_os STRING,
  first_app_name STRING,
  first_app_visit_os STRING,
  first_visit_ip STRING,
  first_city STRING,
  first_province STRING,
  day7_app_cnt BIGINT,
  day15_app_cnt BIGINT,
  month1_app_cnt BIGINT,
  month2_app_cnt BIGINT,
  month3_app_cnt BIGINT,
  day7_pc_cnt BIGINT,
  day15_pc_cnt BIGINT,
  month1_pc_cnt BIGINT,
  month2_pc_cnt BIGINT,
  month3_pc_cnt BIGINT,
  month1_pc_days BIGINT,
  month1_pc_pv BIGINT,
  month1_pc_avg_pv BIGINT,
  month1_pc_diff_ip_cnt BIGINT,
  month1_pc_diff_cookie_cnt BIGINT,
  month1_pc_common_ip string,
  month1_pc_common_cookie string,
  month1_pc_common_browser_name string,
  month1_pc_common_os string,
  month1_hour025_cnt BIGINT,
  month1_hour627_cnt BIGINT,
  month1_hour829_cnt BIGINT,
  month1_hour10212_cnt BIGINT,
  month1_hour13214_cnt BIGINT,
  month1_hour15217_cnt BIGINT,
  month1_hour18219_cnt BIGINT,
  month1_hour20221_cnt BIGINT,
  month1_hour22223_cnt BIGINT
) STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler' WITH SERDEPROPERTIES (
  "hbase.columns.mapping" = ":key,
basicInfo:user_name,
basicInfo:user_sex,
basicInfo:user_birthday,
basicInfo:user_age,
basicInfo:constellation,
basicInfo:province,
basicInfo:city,
basicInfo:city_level,
basicInfo:hex_mail,
basicInfo:op_mail,
basicInfo:hex_phone,
basicInfo:fore_phone,
basicInfo:op_phone,
basicInfo:add_time,
basicInfo:login_ip,
basicInfo:login_source,
basicInfo:request_user,
basicInfo:total_mark,
basicInfo:used_mark,
basicInfo:level_name,
basicInfo:blacklist,
basicInfo:is_married,
basicInfo:education,
basicInfo:monthly_money,
basicInfo:profession,
basicInfo:sex_model,
basicInfo:is_pregnant_woman,
basicInfo:is_have_children,
basicInfo:children_sex_rate,
basicInfo:children_age_rate,
basicInfo:is_have_car,
basicInfo:potential_car_user_rate,
basicInfo:phone_brand,
basicInfo:phone_brand_level,
basicInfo:phone_cnt,
basicInfo:change_phone_rate,
basicInfo:majia_flag,
basicInfo:majie_account_cnt,
basicInfo:loyal_model,
basicInfo:shopping_type_model,
basicInfo:figure_model,
basicInfo:stature_model,
order:first_order_time,
order:last_order_time,
order:first_order_ago,
order:last_order_ago,
order:month1_hg_order_cnt,
order:month1_hg_order_amt,
order:month2_hg_order_cnt,
order:month2_hg_order_amt,
order:month3_hg_order_cnt,
order:month3_hg_order_amt,
order:month1_order_cnt,
order:month1_order_amt,
order:month2_order_cnt,
order:month2_order_amt,
order:month3_order_cnt,
order:month3_order_amt,
order:max_order_amt,
order:min_order_amt,
order:total_order_cnt,
order:total_order_amt,
order:user_avg_amt,
order:month3_user_avg_amt,
order:common_address,
order:common_paytype,
order:month1_cart_cnt,
order:month1_cart_goods_cnt,
order:month1_cart_submit_cnt,
order:month1_cart_rate,
order:month1_cart_cancle_cnt,
order:return_cnt,
order:return_amt,
order:reject_cnt,
order:reject_amt,
order:last_return_time,
order:school_order_cnt,
order:company_order_cnt,
order:home_order_cnt,
order:forenoon_order_cnt,
order:afternoon_order_cnt,
order:night_order_cnt,
order:morning_order_cnt,
category:first_category_id,
category:first_category_name,
category:second_category_id,
category:second_catery_name,
category:third_category_id,
category:third_category_name,
category:month1_category_cnt,
category:month1_category_amt,
category:month3_category_cnt,
category:month3_category_amt,
category:month6_category_cnt,
category:month6_category_amt,
category:total_category_cnt,
category:total_category_amt,
category:month1_cart_category_cnt,
category:month3_cart_category_cnt,
category:month6_cart_category_cnt,
category:total_cart_category_cnt,
category:last_category_time,
category:last_category_ago,
visit:latest_pc_visit_date,
visit:latest_app_visit_date,
visit:latest_pc_visit_session,
visit:latest_pc_cookies,
visit:latest_pc_pv,
visit:latest_pc_browser_name,
visit:latest_pc_visit_os,
visit:latest_app_name,
visit:latest_app_visit_os,
visit:latest_visit_ip,
visit:latest_city,
visit:latest_province,
visit:first_pc_visit_date,
visit:first_app_visit_date,
visit:first_pc_visit_session,
visit:first_pc_cookies,
visit:first_pc_pv,
visit:first_pc_browser_name,
visit:first_pc_visit_os,
visit:first_app_name,
visit:first_app_visit_os,
visit:first_visit_ip,
visit:first_city,
visit:first_province,
visit:day7_app_cnt,
visit:day15_app_cnt,
visit:month1_app_cnt,
visit:month2_app_cnt,
visit:month3_app_cnt,
visit:day7_pc_cnt,
visit:day15_pc_cnt,
visit:month1_pc_cnt,
visit:month2_pc_cnt,
visit:month3_pc_cnt,
visit:month1_pc_days,
visit:month1_pc_pv,
visit:month1_pc_avg_pv,
visit:month1_pc_diff_ip_cnt,
visit:month1_pc_diff_cookie_cnt,
visit:month1_pc_common_ip,
visit:month1_pc_common_cookie,
visit:month1_pc_common_browser_name,
visit:month1_pc_common_os,
visit:month1_hour025_cnt,
visit:month1_hour627_cnt,
visit:month1_hour829_cnt,
visit:month1_hour10212_cnt,
visit:month1_hour13214_cnt,
visit:month1_hour15217_cnt,
visit:month1_hour18219_cnt,
visit:month1_hour20221_cnt,
visit:month1_hour22223_cnt"
) TBLPROPERTIES (
  "hbase.table.name" = "itcast_adm_personas_hbase_20170101",
  "hbase.mapred.output.outputtable"="itcast_adm_personas_hbase_20170101"
) ;

insert overwrite table adm.itcast_adm_personas_hbase select * from adm.itcast_adm_personas;
