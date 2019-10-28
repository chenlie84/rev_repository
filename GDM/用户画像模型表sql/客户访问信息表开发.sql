-----------------客户访问信息表模型开发
create database if not exists gdm;
create  table if not exists gdm.itcast_gdm_user_visit(
user_id string,             --客户ID
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
month1_hour22223_cnt bigint,            --近30天PC端22-23点访问次数
dw_date timestamp
) partitioned by (dt string);


------用户上网轨迹表BDM层--PC端
create database if not exists bdm;
create external table if not exists bdm.itcast_bdm_user_pc_click_log(
  session_id STRING,  --sessionID
  cookie_id STRING,   --cookieID
  visit_time STRING,  --访问时间
  user_id STRING,     --用户ID
  visit_url STRING,   --访问的URL
  visit_os STRING,    --操作系统
  browser_name STRING,--游览器名称
  visit_ip STRING,    --访问ip
  province STRING,    --省份
  city STRING,        --城市
  page_id STRING,     --页面ID
  goods_id STRING,    --商品ID
  shop_id STRING      --商店ID
) partitioned by (dt string)
row format delimited fields terminated by ','
lines terminated by '\n'
location "/business/itcast_bdm_user_pc_click_log";
alter table bdm.itcast_bdm_user_pc_click_log add partition (dt='2017-01-01') location '/business/itcast_bdm_user_pc_click_log/2017-01-01';
hdfs dfs -put /root/source_data/itcast_bdm_user_pc_click_log.txt /business/itcast_bdm_user_pc_click_log/2017-01-01

------用户上网轨迹表FDM层--PC端
create database if not exists fdm;
create table if not exists fdm.itcast_fdm_user_pc_pageview(
  session_id STRING,  --sessionID
  cookie_id STRING,   --cookieID
  user_id STRING,     --用户ID
  in_time STRING,     --访问进入时间
  out_time STRING,    --访问离开时间
  stay_time STRING,   --访问停留时间
  pv BIGINT,          --PV
  visit_os STRING,    --操作系统
  browser_name STRING,--游览器名称
  visit_ip STRING,    --访问ip
  province STRING,    --省份
  city STRING         --城市
) partitioned BY (dt STRING);


-------------加载数据---
INSERT overwrite TABLE fdm.itcast_fdm_user_pc_pageview PARTITION (dt = '2017-01-01') 
SELECT 
  t.session_id,
  t.cookie_id,
  t.user_id,
  MIN(visit_time) in_time,
  MAX(visit_time) out_time,
  (
    case
      WHEN MIN(visit_time) = MAX(visit_time) 
      then 5 
      else unix_timestamp(MAX(visit_time)) - unix_timestamp(MIN(visit_time)) 
    end
  ) stay_time,
  COUNT(1) pv,
  t.visit_os,
  t.browser_name,
  t.visit_ip,
  t.province,
  t.city 
FROM
  bdm.itcast_bdm_user_pc_click_log t 
WHERE dt = '2017-01-01' 
GROUP BY t.session_id,
  t.cookie_id,
  t.user_id,
  t.visit_os,
  t.browser_name,
  t.visit_ip,
  t.province,
  t.city ;



------用户上网轨迹表BDM层--APP端
create database if not exists bdm;
create external table if not exists bdm.itcast_bdm_user_app_click_log(
  user_id string,        --用户ID
  log_time string,       --访问时间
  phone_id string,       --手机ID，唯一标识一台设备
  visit_os string,       --操作系统 android、ios、wp
  os_version string,     --操作系统版本
  app_name string,       --APP的名称
  app_version string,    --APP的版本
  device_token string,   --PUSH码，消息推送的
  visit_ip string,       --访问ip
  province string,       --省份
  city string            --城市
) partitioned by (dt string)
row format delimited fields terminated by ','
lines terminated by '\n'
location "/business/itcast_bdm_user_app_click_log";
alter table bdm.itcast_bdm_user_app_click_log add partition (dt='2017-01-01') location '/business/itcast_bdm_user_app_click_log/2017-01-01';
hdfs dfs -put /root/source_data/itcast_bdm_user_app_click_log.txt /business/itcast_bdm_user_app_click_log/2017-01-01
--Push指运营人员通过自己的产品或第三方工具对用户移动设备进行的主动消息推送。
--用户可以在移动设备锁定屏幕和通知栏看到push消息通知，通知栏点击可唤起APP并去往相应页面。
--我们平时在锁屏上看到的微信消息等等都属于APP消息推送行列。

------用户上网轨迹表FDM层--app端
create database if not exists fdm;
create  table if not exists fdm.itcast_fdm_user_app_pageview(
  user_id string,        --用户ID
  log_time string,       --访问时间 2016-12-12 10:20:30
  log_hour string,		 --访问时间的小时数 10
  phone_id string,       --手机ID，唯一标识一台设备
  visit_os string,       --操作系统 android、ios、wp
  os_version string,     --操作系统版本
  app_name string,       --APP的名称
  app_version string,    --APP的版本
  device_token string,   --PUSH码，消息推送的
  visit_ip string,       --访问ip
  province string,       --省份
  city string            --城市
) partitioned BY (dt STRING);


-------------加载数据---
INSERT overwrite TABLE fdm.itcast_fdm_user_app_pageview PARTITION (dt = '2017-01-01') 
SELECT 
  t.user_id,
  t.log_time,
  HOUR(t.log_time) log_hour,
  t.phone_id,
  t.visit_os,
  t.os_version,
  t.app_name,
  t.app_version,
  t.device_token,
  t.visit_ip,
  t.province,
  t.city 
FROM
  bdm.itcast_bdm_user_app_click_log t 
WHERE dt = '2017-01-01' ;




------近30天PC端访问最常用的指标
drop table if exists gdm.itcast_gdm_user_visit_temp_01;
create table gdm.itcast_gdm_user_visit_temp_01 as 
select 
  t.user_id,
  t.type,
  t.con,
  t.cnt,
  t.rn 
from
  (select 
    b.user_id,
    b.con,
    b.type,
    b.cnt,
    row_number () over (
      distribute by b.user_id,
      b.type sort by b.cnt desc
    ) rn 
  from
    (select 
      a.user_id,
      a.visit_ip con,
      'visit_ip' type,
      count(1) cnt 
    from
      fdm.itcast_fdm_user_pc_pageview a 
    where dt >= date_add('2017-01-01', -29) 
    group by a.user_id,
      a.visit_ip 
    union
    all 
    select 
      a.user_id,
      a.cookie_id con,
      'cookie_id' type,
      count(1) cnt 
    from
      fdm.itcast_fdm_user_pc_pageview a 
    where dt >= date_add('2017-01-01', -29) 
    group by a.user_id,
      a.cookie_id 
    union
    all 
    select 
      a.user_id,
      a.browser_name con,
      'browser_name' type,
      count(1) cnt 
    from
      fdm.itcast_fdm_user_pc_pageview a 
    where dt >= date_add('2017-01-01', -29) 
    group by a.user_id,
      a.browser_name 
    union
    all 
    select 
      a.user_id,
      a.visit_os con,
      'visit_os' type,
      count(1) cnt 
    from
      fdm.itcast_fdm_user_pc_pageview a 
    where dt >= date_add('2017-01-01', -29) 
    group by a.user_id,
      a.visit_os) b) t ;


-------生成客户访问模型表

INSERT overwrite TABLE gdm.itcast_gdm_user_visit PARTITION (dt = '2017-01-01') 
SELECT 
  t.user_id,--客户ID
  MAX(
    CASE
      WHEN pc.rn_desc = 1 
      THEN pc.in_time 
    END
  ) latest_pc_visit_date,--最近一次PC端访问日期
  MAX(
    CASE
      WHEN app.rn_desc = 1 
      THEN app.log_time 
    END
  ) latest_app_visit_date,--最近一次APP端访问日期
  MAX(
    CASE
      WHEN pc.rn_desc = 1 
      THEN pc.session_id 
    END
  ) latest_pc_visit_session,--最近一次PC端访问的session
  MAX(
    CASE
      WHEN pc.rn_desc = 1 
      THEN pc.cookie_id 
    END
  ) latest_pc_cookies,--最近一次PC端访问的cookies
  MAX(
    CASE
      WHEN pc.rn_desc = 1 
      THEN pc.pv 
    END) latest_pc_pv,--最近一次PC端访问的PV
  MAX(
    CASE
      WHEN pc.rn_desc = 1 
      THEN pc.browser_name 
    END
  ) latest_pc_browser_name,--最近一次PC端访问使用的游览器
  MAX(
    CASE
      WHEN pc.rn_desc = 1 
      THEN pc.visit_os 
    END
  ) latest_pc_visit_os,--最近一次PC端访问使用的操作系统
  MAX(
    CASE
      WHEN app.rn_desc = 1 
      THEN app.app_name 
    END
  ) latest_app_name,--最近一次APP端访问app名称
  MAX(
    CASE
      WHEN app.rn_desc = 1 
      THEN app.visit_os 
    END
  ) latest_app_visit_os,--最近一次APP端访问使用的操作系统
  MAX(
    CASE
      WHEN pc.rn_desc = 1 
      AND app.rn_desc = 1 
      AND pc.in_time >= app.log_time 
      THEN pc.visit_ip
      WHEN pc.rn_desc = 1 
      AND app.rn_desc = 1 
      AND pc.in_time < app.log_time 
      THEN app.visit_ip  
    END
  ) latest_visit_ip,--最近一次访问IP(不分APP与PC)
  MAX(
    CASE
      WHEN pc.rn_desc = 1 
      AND app.rn_desc = 1 
      AND pc.in_time >= app.log_time 
      THEN pc.city
      WHEN pc.rn_desc = 1 
      AND app.rn_desc = 1 
      AND pc.in_time < app.log_time 
      THEN app.city 
    END
  ) latest_city,--最近一次访问城市(不分APP与PC)
  MAX(
    CASE
      WHEN pc.rn_desc = 1 
      AND app.rn_desc = 1 
      AND pc.in_time >= app.log_time 
      THEN pc.province 
      WHEN pc.rn_desc = 1 
      AND app.rn_desc = 1 
      AND pc.in_time < app.log_time 
      THEN app.province 
    END
  ) latest_province,--最近一次访问省份(不分APP与PC)
  MAX(
    CASE
      WHEN pc.rn_asc = 1 
      THEN pc.in_time 
    END
  ) first_pc_visit_date,--第一次PC端访问日期
  MAX(
    CASE
      WHEN app.rn_asc = 1 
      THEN app.log_time 
    END
  ) first_app_visit_date,--第一次APP端访问日期
  MAX(
    CASE
      WHEN pc.rn_asc = 1 
      THEN pc.session_id 
    END
  ) first_pc_visit_session,--第一次PC端访问的session
  MAX(
    CASE
      WHEN pc.rn_asc = 1 
      THEN pc.cookie_id 
    END
  ) first_pc_cookies,--第一次PC端访问的cookies
  MAX(
    CASE
      WHEN pc.rn_asc = 1 
      THEN pc.pv 
    END) first_pc_pv,--第一次PC端访问的PV
  MAX(
    CASE
      WHEN pc.rn_asc = 1 
      THEN pc.browser_name 
    END
  ) first_pc_browser_name,--第一次PC端访问使用的游览器
  MAX(
    CASE
      WHEN pc.rn_asc = 1 
      THEN pc.visit_os 
    END
  ) first_pc_visit_os,--第一次PC端访问使用的操作系统
  MAX(
    CASE
      WHEN app.rn_asc = 1 
      THEN app.app_name 
    END
  ) first_app_name,--第一次APP端访问app名称
  MAX(
    CASE
      WHEN app.rn_asc = 1 
      THEN app.visit_os 
    END
  ) first_app_visit_os,--第一次APP端访问使用的操作系统
  MAX(
    CASE
      WHEN pc.rn_asc = 1 
      AND app.rn_asc = 1 
      AND pc.in_time <= app.log_time 
      THEN pc.visit_ip 
      WHEN pc.rn_asc = 1 
      AND app.rn_asc = 1 
      AND pc.in_time > app.log_time 
      THEN app.visit_ip 
    END
  ) first_visit_ip,--第一次访问IP(不分APP与PC)
  MAX(
    CASE
      WHEN pc.rn_asc = 1 
      AND app.rn_asc = 1 
      AND pc.in_time <= app.log_time 
      THEN pc.city 
      WHEN pc.rn_asc = 1 
      AND app.rn_asc = 1 
      AND pc.in_time > app.log_time 
      THEN app.city 
    END
  ) first_city,--第一次访问城市(不分APP与PC)
  MAX(
    CASE
      WHEN pc.rn_asc = 1 
      AND app.rn_asc = 1 
      AND pc.in_time <= app.log_time 
      THEN pc.province 
      WHEN pc.rn_asc = 1 
      AND app.rn_asc = 1 
      AND pc.in_time > app.log_time 
      THEN app.province 
    END
  ) first_province,--第一次访问省份(不分APP与PC)
  SUM(
    CASE
      WHEN app.dat_7 = 1 
      THEN 1 
    END) day7_app_cnt,--近7天APP端访问次数
  SUM(
    CASE
      WHEN app.dat_15 = 1 
      THEN 1 
    END) day15_app_cnt,--近15天APP端访问次数
  SUM(
    CASE
      WHEN app.dat_30 = 1 
      THEN 1 
    END) month1_app_cnt,--近30天APP端访问次数
  SUM(
    CASE
      WHEN app.dat_60 = 1 
      THEN 1 
    END) month2_app_cnt,--近60天APP端访问次数
  SUM(
    CASE
      WHEN app.dat_90 = 1 
      THEN 1 
    END) month3_app_cnt,--近90天APP端访问次数
  COUNT(
    CASE
      WHEN pc.dat_7 = 1 
      THEN pc.session_id 
    END
  ) day7_pc_cnt,--近7天PC端访问次数
  COUNT(
    CASE
      WHEN pc.dat_15 = 1 
      THEN pc.session_id 
    END
  ) day15_pc_cnt,--近15天PC端访问次数
  COUNT(
    CASE
      WHEN pc.dat_30 = 1 
      THEN pc.session_id 
    END
  ) month1_pc_cnt,--近30天PC端访问次数
  COUNT(
    CASE
      WHEN pc.dat_60 = 1 
      THEN pc.session_id 
    END
  ) month2_pc_cnt,--近60天PC端访问次数
  COUNT(
    CASE
      WHEN pc.dat_90 = 1 
      THEN pc.session_id 
    END
  ) month3_pc_cnt,--近90天PC端访问次数 2017-01-01 12:20:30
  COUNT(DISTINCT substr(pc.in_time,0,10)) month1_pc_days,--近30天PC端访问天数
  SUM(
    CASE
      WHEN pc.dat_30 = 1 
      THEN pc.pv 
    END) month1_pc_pv,--近30天PC端访问PV
  SUM(
    CASE
      WHEN pc.dat_30 = 1 
      THEN pc.pv 
    END) / COUNT(DISTINCT substr(pc.in_time,0,10)) month1_pc_avg_pv,--近30天PC端访问平均PV
  MAX(b.month1_pc_diff_ip_cnt),--近30天PC端访问不同ip数
  MAX(b.month1_pc_diff_cookie_cnt),--近30天PC端访问不同的cookie数
  MAX(b.month1_pc_common_ip),--近30天PC端访问最常用ip
  MAX(b.month1_pc_common_cookie),--近30天PC端访问最常用的cookie
  MAX(b.month1_pc_common_browser_name),--近30天PC端访问最常用游览器
  MAX(b.month1_pc_common_os),--近30天PC端访问最常用的操作系统
  COUNT(
    CASE
      WHEN pc.visit_hour >= 0 
      AND pc.visit_hour <= 5 
      THEN pc.session_id 
    END
  ) month1_hour025_cnt,--近30天PC端0-5点访问次数
  COUNT(
    CASE
      WHEN pc.visit_hour >= 6 
      AND pc.visit_hour <= 7 
      THEN pc.session_id 
    END
  ) month1_hour627_cnt,--近30天PC端6-7点访问次数
  COUNT(
    CASE
      WHEN pc.visit_hour >= 8 
      AND pc.visit_hour <= 9 
      THEN pc.session_id 
    END
  ) month1_hour829_cnt,--近30天PC端8-9点访问次数
  COUNT(
    CASE
      WHEN pc.visit_hour >= 10 
      AND pc.visit_hour <= 12 
      THEN pc.session_id 
    END
  ) month1_hour10212_cnt,--近30天PC端10-12点访问次数
  COUNT(
    CASE
      WHEN pc.visit_hour >= 13 
      AND pc.visit_hour <= 14 
      THEN pc.session_id 
    END
  ) month1_hour13214_cnt,--近30天PC端13-14点访问次数
  COUNT(
    CASE
      WHEN pc.visit_hour >= 15 
      AND pc.visit_hour <= 17 
      THEN pc.session_id 
    END
  ) month1_hour15217_cnt,--近30天PC端15-17点访问次数
  COUNT(
    CASE
      WHEN pc.visit_hour >= 18 
      AND pc.visit_hour <= 19 
      THEN pc.session_id 
    END
  ) month1_hour18219_cnt,--近30天PC端18-19点访问次数
  COUNT(
    CASE
      WHEN pc.visit_hour >= 20 
      AND pc.visit_hour <= 21 
      THEN pc.session_id 
    END
  ) month1_hour20221_cnt,--近30天PC端20-21点访问次数
  COUNT(
    CASE
      WHEN pc.visit_hour >= 22 
      AND pc.visit_hour <= 23 
      THEN pc.session_id 
    END
  ) month1_hour22223_cnt,--近30天PC端22-23点访问次数
  FROM_UNIXTIME(UNIX_TIMESTAMP()) dw_date 
FROM
  (SELECT 
    user_id 
  FROM
    fdm.itcast_fdm_user_wide 
  WHERE dt = '2017-01-01') t 
  LEFT JOIN 
    (SELECT 
      a.*,
      (
        CASE
          WHEN in_time >= DATE_SUB('2017-01-01', 6) 
          AND in_time <= '2017-01-01' 
          THEN 1 
        END
      ) dat_7,
      (
        CASE
          WHEN in_time >= DATE_SUB('2017-01-01', 14) 
          AND in_time <= '2017-01-01' 
          THEN 1 
        END
      ) dat_15,
      (
        CASE
          WHEN in_time >= DATE_SUB('2017-01-01', 29) 
          AND in_time <= '2017-01-01' 
          THEN 1 
        END
      ) dat_30,
      (
        CASE
          WHEN in_time >= DATE_SUB('2017-01-01', 59) 
          AND in_time <= '2017-01-01' 
          THEN 1 
        END
      ) dat_60,
      (
        CASE
          WHEN in_time >= DATE_SUB('2017-01-01', 89) 
          AND in_time <= '2017-01-01' 
          THEN 1 
        END
      ) dat_90,
      hour(in_time) visit_hour,
      row_number () over (
        distribute BY a.user_id sort BY a.in_time DESC
      ) rn_desc,
      row_number () over (
        distribute BY a.user_id sort BY a.in_time ASC
      ) rn_asc 
    FROM
      fdm.itcast_fdm_user_pc_pageview a 
    WHERE in_time >= DATE_ADD('2017-01-01', -89) 
      AND in_time <= '2017-01-01') pc 
    ON (t.user_id = pc.user_id) 
  LEFT JOIN 
    (SELECT 
      user_id,
      sum(
        CASE
          WHEN TYPE = 'visit_ip' 
          THEN cnt 
        END
      ) month1_pc_diff_ip_cnt,
      MAX(
        CASE
          WHEN TYPE = 'visit_ip' and rn= 1
          THEN con 
        END
      ) month1_pc_common_ip,
      sum(
        CASE
          WHEN TYPE = 'cookie_id' 
          THEN cnt 
        END
      ) month1_pc_diff_cookie_cnt,
      MAX(
        CASE
          WHEN TYPE = 'cookie_id' and rn = 1
          THEN con 
        END
      ) month1_pc_common_cookie,
      MAX(
        CASE
          WHEN TYPE = 'browser_name' and rn = 1
          THEN con 
        END
      ) month1_pc_common_browser_name,
      MAX(
        CASE
          WHEN TYPE = 'visit_os' and rn = 1
          THEN con 
        END
      ) month1_pc_common_os 
    FROM
      gdm.itcast_gdm_user_visit_temp_01 
    GROUP BY user_id) b 
    ON (t.user_id = b.user_id) 
  LEFT JOIN 
    (SELECT 
      a.*,
      (
        CASE
          WHEN log_time >= DATE_SUB('2017-01-01', 6) 
          AND log_time <= '2017-01-01' 
          THEN 1 
        END
      ) dat_7,
      (
        CASE
          WHEN log_time >= DATE_SUB('2017-01-01', 14) 
          AND log_time <= '2017-01-01' 
          THEN 1 
        END
      ) dat_15,
      (
        CASE
          WHEN log_time >= DATE_SUB('2017-01-01', 29) 
          AND log_time <= '2017-01-01' 
          THEN 1 
        END
      ) dat_30,
      (
        CASE
          WHEN log_time >= DATE_SUB('2017-01-01', 59) 
          AND log_time <= '2017-01-01' 
          THEN 1 
        END
      ) dat_60,
      (
        CASE
          WHEN log_time >= DATE_SUB('2017-01-01', 89) 
          AND log_time <= '2017-01-01' 
          THEN 1 
        END
      ) dat_90,
      row_number () over (
        distribute BY a.user_id sort BY a.log_time DESC
      ) rn_desc,
      row_number () over (
        distribute BY a.user_id sort BY a.log_time ASC
      ) rn_asc 
    FROM
      fdm.itcast_fdm_user_app_pageview a 
 WHERE log_time >= DATE_ADD('2017-01-01', -89) 
      AND log_time <= '2017-01-01') app 
    ON (t.user_id = app.user_id) 
GROUP BY t.user_id ;