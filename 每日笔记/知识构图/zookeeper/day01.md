1.三台虚拟机的构建

2.linux基础及shell增强

3.大数据集群环境的准备

4.zookeeper的相关操作

5.网络编程（了解）



#### 1.三台虚拟机的构建

​	1）复制三台虚拟机

​	2）虚拟机修改mac地址

​	更改mac地址：

​	vim /etc/udev/rules.d/70-persistent-net.rules

​	3）虚拟机修改ip地址

​	更改ip地址

​	vim /etc/sysconfig/network-scripts/ifcfg-eth0



#### 2.linux基础增强

##### ​	1.查找命令

​	1）grep:常用于文本检索

​		ps -ef|grep sshd   #用于查看sshd的进程信息

​		cat a.txt | grep -f b.txt  #从文件中读取关键词进行搜索

​	2）find :用于在目录中检索文件

​		find 【目录】 【参数】 【文件或目录名称】 【命令】

​		find . -name "*.log" -ls   #查找当目录，以.log 结尾的普通文件

​		find . -type f -name "*.log"  #查找当目录，以.log 结尾的普通文件

​	3）locate:搜索档案系统中指定的文件。

​		其中有一个自带的数据库。

​		使用前需要先更新一下数据库

​		locate /etc/sh  #查找sh开头的文件

​	4）whereis：常用于检索命令文件（可执行文件、源代码文件、帮助文件）

​		whereis ls

​	5) which：用于指定命令的检索

​		which  ls

##### 	2.用户和用户组

​	useradd hadoop   #添加一个用户

​	passwd  hadoop  #添加密码

##### 	3.su与sudo

​	su  用于用户之间的切换

​	sudo  执行root用户级别的命令

​	visudo  修改普通用户的执行权限  ==  	vim  /etc/sudoers  #修改配置文件

##### ​	4.linux权限管理

​	chmod：#修改执行权限

​	chmod  -R  777 /a.txt  

​	chmod -R  u+x /a.txt

​	chown：#修改文件或目录的所有者

​	chown -R hadoop:hadoop a.txt

##### ​	5.系统服务管理

​	service  iptables start|stop|status |restart  #服务的启动和停止等

​	chkconfig：设定开机自启或停止启动

​	chkconfig iptables on|off

##### ​	6.网络管理

###### ​	1）主机名配置

​		vi /ect/sysconfig/network  #修改主机名称

​		FQDN:全限定域名

​		hostname  #查看主机名

​		hostname   node01  #指定临时主机名

###### ​	2）修改ip地址

​	vi   /etc/sysconfig/network-scripts/ifcfg-eth0 	

###### ​	3）域名映射

​	vim /etc/hosts

###### ​	4)网络端口监听

​	netstat   -nltp

###### ​	5）crontab配置

​	crontab：用于定时完成执行任务

​	crontab -l  [-u user] ## 列出用户目前的 crontab.
​	crontab -e [-u user] ## 编辑用户目前的 crontab.	

​	完成时间的同步：

​	crontab  -e

​	*/1 * * * * /usr/sbin/ntpdate ntp4.aliyun.com

#### 3.linux的shell编程

​	shell使用C语言编写的程序。

​	shell script：我们去编写的脚本

​	shell有多种版本，sh  bash

​	1）shell脚本的格式

​	编写的脚本基本以.sh作为文件的后缀

​	#!/bin/bash

​	2)shell脚本执行

​		1）通过sh命令 执行脚本  sh   hello.sh

​		2)给文件进行授权

​		chmod u+x   ./hello.sh

​		. hello.sh

​	3)shell的变量

​	变量=值，变量=前后一定没有空格      ，除了变量之间没有空格，其他地方到处是空格

​	变量的引用：

​		1）通过$引用变量

​	echo  $word

​	如果引用的变量连接字符串时，通过echo  ${word}引用

​	echo  ${word}zhangsan

​		2）变量类型：

​		局部变量：只针对局部有效，其他范围无效。

​		环境变量：是配置的环境变量，在全局范围或者是用户范围有效。

​		shell变量：是shell脚本中的变量，在shell脚本中生效。

​		3）参数传递

​		$n接收参数

​		$0 接收的当前执行脚本的名称

​		4)shell的运算符

​		

​	4）shell流程控制

​		1）if.. else

if
condition1
then
command1
elif condition2
then
command2
else
commandN
fi	

​		2)for

​	for N in 1 2 3
​		do
​		echo $N
​		done	

​		3)while 

​		while expression
​		do
​		command
​		…
​		done	

​		4)case

case 值 in
模式 1)
command1
command2
...
commandN
;;
模式 2）
command1
command2
...
commandN
;;
esac



​	5）shell函数

​[ function ] funname [()]
{
action;
[return int;]
} 	



#### 4.大数据环境准备（详见教案）



#### 5.zookeeper介绍

​	zookeeper是一个分布式协调服务的开源框架。最终解决的是数据一致性。zookeeper是一个分布式小文件系统。zookeeper可以进行简单的事务处理。

​	znode节点：用于存储zookeeper中的数据。

##### 5.1zookeeper的架构

​	主从结构：一个主节点，多个从节点。

​	主备结构：作为主节点，一个是正在运行的主节点，另外一个是备用节点

​	zookeeper中的事务：添加znode节点，删除节点，修改节点过程中，需要事务管理。

​						查询一个节点不需要事务。

​	leader：集群中的核心节点，用于事务的处理。

​	follower:集群中的从节点，用于非事务性的处理，将事务性请求转发给leader进行处理。

​	observer：观察集群中的状态，并进行状态更新。observer不会进行投票选举。用于非事务性的处理，将事务性请求转发给leader进行处理。

##### 5.2.zookeeper特性

​	1）全局数据一致性：每一个节点都会保存一份相同的数据。

​	2）可靠性：

​	3）顺序性：

​	4）原子性：

​	5）实时性：

##### 5.3zookeeper部署（详见教案）



##### 5.4zookeeper shell操作

​	bin/zkCli.sh

​	1)创建节点：

​	创建永久性节点：create  /test "test"

​	创建顺序节点：create  -s  /test "xxx"

​	创建临时节点:  create -e /test-tmp "xxxx"   #只在当前会话有效，退出会自动删除

​	2）读取节点

​	ls  /test    #读取test下的子节点

​	get /test   #获取test存取的信息

​	3）设置数据信息

​	set /test "zookeeper sdsadf"

​	4）删除节点

​	 delete /test01

​	 rmr /test   #有子节点的情况下，需要使用rmr删除

​	5） 查看历史命令

​		history

##### 5.5zookeeper的数据模型

​	zookeeper的数据模型，按照znode节点进行数据的存储和管理。像树状结构。进行节点存储。

​	znode节点和文件目录的区别：

​	1）znode兼具文件和目录两种特点

​	2）znode具有原子操作

​	3）znode有大小限制 最多1m

​	4）znode引用绝对路径，进行访问

##### 5.6znode节点类型

​	1）永久节点：

​	2）临时节点：

​	3）永久序列化节点：

​	4）临时序列化节点：create -e -s /lisi boy

##### 5.7zookeeper的watch机制

​	watch机制用于观察节点的状态变化。

##### ​	特点

​	1)一次性触发

​	2）事件封装

​	3）event异步发送

​	4）先注册再触发



#### 6.网络编程

​	1.ip地址

​	A:192.XXX.XX.XX.

​	B:192.168.XXX.XXX

​	C:192.168.47.XXX

​	D:组播

​	E:未开放

​	2.rpc

​	rpc:远程调用协议