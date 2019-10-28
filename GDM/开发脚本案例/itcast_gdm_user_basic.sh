#!/bin/sh
#获取昨天的时间
yesterday=`date -d '-1 day' "+%Y-%m-%d"`

#指定运行哪天的数据
if [ $1 ];then
	yesterday=$1
fi


#定义任务提交的脚本
SPARK_SUBMIT_INFO="/export/servers/spark/bin/spark-sql --master spark://node01:7077 --executor-memory 1g --total-executor-cores 2 --conf spark.sql.warehouse.dir=hdfs://node01:8020/user/hive/warehouse"

#创建BDM层表
SQL_BDM="create database if not exists bdm;
create external table if not exists bdm.itcast_bdm_user( 
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
add_time string				,--注册时间
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
profession string			--职业
) partitioned by (dt string)
row format delimited fields terminated by ','
location '/business/bdm/itcast_bdm_user' ;
alter table bdm.itcast_bdm_user add partition (dt='$yesterday');"

#创建FDM层表
SQL_FDM="create database if not exists fdm;
create table if not exists fdm.itcast_fdm_user_wide( 
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
add_time string				,--注册时间
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
dw_date  timestamp
) partitioned by (dt string);"


##加载数据到FDM层表
LOAD_FDM="
insert overwrite table fdm.itcast_fdm_user_wide partition(dt='$yesterday')
select 
t.user_id,
t.user_name,
t.user_sex,
t.user_birthday,
t.user_age,
t.constellation,
t.province,
t.city,
t.city_level,
t.hex_mail,
t.op_mail,
t.hex_phone,
t.fore_phone,
t.op_phone,
t.add_time,
t.login_ip,
t.login_source,
t.request_user,
t.total_mark,
t.used_mark,
t.level_name,
t.blacklist,
t.is_married,
t.education,
t.monthly_money,
t.profession, 
from_unixtime(unix_timestamp())  dw_date 
from bdm.itcast_bdm_user t where dt='$yesterday';"

#创建GDM层表
SQL_GDM="create database if not exists gdm;
create  table if not exists gdm.itcast_gdm_user_basic( 
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
add_time string				,--注册时间
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
dw_date timestamp
) partitioned by (dt string);"


##加载数据到GDM层表
LOAD_GDM="insert overwrite table  gdm.itcast_gdm_user_basic partition(dt='$yesterday') 
select 
t.user_id,
t.user_name,
t.user_sex,
t.user_birthday,
t.user_age,
t.constellation,
t.province,
t.city,
t.city_level,
t.hex_mail,
t.op_mail,
t.hex_phone,
t.fore_phone,
t.op_phone,
t.add_time,
t.login_ip,
t.login_source,
t.request_user,
t.total_mark,
t.used_mark,
t.level_name,
t.blacklist,
t.is_married,
t.education,
t.monthly_money,
t.profession, 
null sex_model,--数据挖掘模型-开始
null is_pregnant_woman,
null is_have_children,
null children_sex_rate,
null children_age_rate,
null is_have_car,
null potential_car_user_rate,
null phone_brand,
null phone_brand_level,
null phone_cnt,
null change_phone_rate,
null majia_flag,
null majie_account_cnt,
null loyal_model,
null shopping_type_model,
null figure_model,
null stature_model,--数据挖掘模型-结束
from_unixtime(unix_timestamp())  dw_date 
from fdm.itcast_fdm_user_wide t where dt='$yesterday';"


##执行创建BDM层表sql语句
echo $SQL_BDM
$SPARK_SUBMIT_INFO -e "$SQL_BDM"

##执行导入数据到BDM层表
hdfs dfs -put /root/source_data/itcast_bdm_user.txt /business/bdm/itcast_bdm_user/dt=$yesterday

##执行创建FDM层表sql语句
echo "$SQL_FDM"
$SPARK_SUBMIT_INFO -e "$SQL_FDM"

##执行导入数据到FDM层表sql语句
echo "$LOAD_FDM"
$SPARK_SUBMIT_INFO -e "$LOAD_FDM"

##执行创建GDM层表sql语句
echo "$SQL_GDM"
$SPARK_SUBMIT_INFO -e "$SQL_GDM"

##执行导入数据GDM层表sql语句
echo "$LOAD_GDM"
$SPARK_SUBMIT_INFO -e "$LOAD_GDM"
