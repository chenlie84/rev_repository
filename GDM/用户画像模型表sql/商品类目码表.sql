-------商品类目码表
create database if not exists gdm;
create external table if not exists gdm.itcast_gdm_category_code(
third_category_id bigint,--三级分类ID
third_category_name string,--三级分类名称
second_category_id bigint,--二级分类ID
second_catery_name string,--二级分类名称
first_category_id bigint,--一级分类ID
first_category_name string --一级分类名称
)row format delimited fields terminated by ','
lines terminated by '\n'
location  '/business/itcast_gdm_category_code';
load data local inpath '/root/source_data/itcast_gdm_category_code.txt' overwrite into table gdm.itcast_gdm_category_code;