--用户画像-客户访问信息表
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






