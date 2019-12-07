#### Linux 上 安装mysql

### 1.下载

1. 选择指定版本

```
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.26-linux-glibc2.12-x86_64.tar.gz
```

2. 也可以在官网上下载，最好下载编译好版本

### 2. 解压并且移动

```
tar -xvf mysql-5.7.26-linux-glibc2.12-x86_64.tar.gz 
mv mysql-5.7.26-linux-glibc2.12-x86_64 /usr/local/
```



### 3. 创建用户，并且赋予权限

```
创建用户
groupadd mysql
useradd -r -g mysql mysql

赋予权限
chown mysql:mysql -R /data/mysql

```



### 4.配置参数

```
vim /etc/my.cnf
```



```
[mysqld]
bind-address=0.0.0.0
port=3306
user=mysql
basedir=/usr/local/mysql-5.7.26
datadir=/data/mysql
socket=/var/lib/mysql/mysql.sock
log-error=/data/mysql/mysql.err
pid-file=/data/mysql/mysql.pid
#character config
character_set_server=utf8mb4
symbolic-links=0
```



### 5.初始化mysql

```
cd /usr/local/mysql-5.7.26/bin/
 ./mysqld --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql-5.7.26/ --datadir=/data/mysql/ --user=mysql --initialize
```



```
查看初始密码
vim /data/mysql/mysql.err
```



### 6.启动mysql，并更改root 密码

```
启动
service mysqld start

SET PASSWORD = PASSWORD('123456');

ALTER USER 'root'@'localhost' PASSWORD EXPIRE NEVER;

flush privileges;
```



### 7.注意事项

``` shell
# 当mysqld 服务不识别的时候
找到mysql.server

[root@bigdata03 mysql]# find / -name mysql.server
/usr/share/mysql/mysql.server
/usr/local/mysql-5.7.26/support-files/mysql.server

# mv /usr/local/mysql-5.7.26/support-files/mysql.server /usr/local/mysql-5.7.26/bin/mysqld

# 服务才会识别，不用安装


# 注意权限问题
```

