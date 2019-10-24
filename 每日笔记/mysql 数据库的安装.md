## mysql 数据库的安装

``` shell
mysql数据库的安装（使用yum源进行安装，强烈推荐）

第一步：在线安装mysql相关的软件包

yum  install  mysql  mysql-server  mysql-devel

第二步：启动mysql的服务
/etc/init.d/mysqld start

第三步：通过mysql安装自带脚本进行设置

/usr/bin/mysql_secure_installation

第四步：进入mysql的客户端然后进行授权

 grant all privileges on *.* to 'root'@'%' identified by '123456' with grant option;
 flush privileges;
```

