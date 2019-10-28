#表结构
# desc employee;
empid                   int                                         
deptid                  int                                         
sex                     string                                      
salary                  double  
#表记录
select * from employee;
1       10      female  5500.0
2       10      male    4500.0
3       20      female  1900.0
4       20      male    4800.0
5       40      female  6500.0
6       40      female  14500.0
7       40      male    44500.0
8       50      male    6500.0
9       50      male    7500.0


CREATE TABLE `employee`  (
  `empid` int,
  `deptid` int,
  `sex` string,
  `salary` double
);

-- ----------------------------
-- Records of employee
-- ----------------------------
INSERT INTO `employee` VALUES (1, 10, 'female', 5500.00);
INSERT INTO `employee` VALUES (2, 10, 'male', 4500.00);
INSERT INTO `employee` VALUES (3, 20, 'female', 1900.00);
INSERT INTO `employee` VALUES (4, 20, 'male', 4800.00);
INSERT INTO `employee` VALUES (5, 40, 'female', 6500.00);
INSERT INTO `employee` VALUES (6, 40, 'female', 14500.00);
INSERT INTO `employee` VALUES (7, 40, 'male', 44500.00);
INSERT INTO `employee` VALUES (8, 50, 'male', 6500.00);
INSERT INTO `employee` VALUES (9, 50, 'male', 7500.00);

SET FOREIGN_KEY_CHECKS = 1;







########### 将员工按照薪资待遇划分等级
#			(小于5000为低等收入，5000-10000为中等收入，10000以上为高等收入)
########### 将员工按照性别打上标识 
#			female为1, male为0
select *,
case 
when salary < 5000 then "低等收入" 
when salary>= 5000 and salary < 10000 then "中等收入"
when salary > 10000 then "高等收入"  
end  as level,
case sex
when "female" then 1 
when "male" then 0
end as flag 
from employee;
#统计结果
1       10      female  5500.0  中等收入        1
2       10      male    4500.0  低等收入        0
3       20      female  1900.0  低等收入        1
4       20      male    4800.0  低等收入        0
5       40      female  6500.0  中等收入        1
6       40      female  14500.0 高等收入        1
7       40      male    44500.0 高等收入        0
8       50      male    6500.0  中等收入        0
9       50      male    7500.0  中等收入        0

############### 统计每个部门薪资最高的员工信息
select *,
row_number() over(distribute by deptid sort by salary desc ) rn
from employee;

##统计结果
1       10      female  5500.0  1
2       10      male    4500.0  2
4       20      male    4800.0  1
3       20      female  1900.0  2
7       40      male    44500.0 1
6       40      female  14500.0 2
5       40      female  6500.0  3
9       50      male    7500.0  1
8       50      male    6500.0  2

## 直接取出rn的编号为1的记录就是每个部门薪资最高的员工信息
select * 
from  
(select *,
row_number() over(distribute by deptid sort by salary desc ) rn from employee) t 
where t.rn=1;
##最终结果
1       10      female  5500.0  1
4       20      male    4800.0  1
7       40      male    44500.0 1
9       50      male    7500.0  1