## hadoop01 Linux&shell&运行环境的准备

### 1.搭建虚拟机

### 2.Linux基础增强

1. **查找命令**

   1. **grep**  针对当前文本进行过滤
      1. grep  ^开头的符号  $结尾符号
   2. **find命令** : 用于在目录中检索文件
      1. find  目录  参数  "文件或者目录" 
      2. find .  查找当前目录
      3. find . -name  指定参数 是文件的名
      4. find . -name "*.log"  查找以log为结尾的文件
      5. find . -name "*.log" ls  显示结果为ls命令的形式
      6. -perm 777  查找权限为777的文件
      7. -type f 查找文件类型的命令
      8. -type d | sort  查找当前所有目录并排序
   3. locate: 搜索档案系统中的指定文件
      1. 自带有一个数据库.通过当前数据库进行过查找,如果数据库没有就查不到.
      2. 使用该命令,需要下载 或者更新数据库updatedb
      3. locate /etc/sh   #查找sh开头的文件
   4. whereis:用于定位命令(或者可执行)文件,源代码文件,帮助文件.
      1. whereis  Is #命令  查找ls命令 的文件
      2. 参数 -m    ,     -s
   5. which:用于指定命令的检索
      1. which ls  #查找ls命令的文件

2. **用户和用户组**

   1. useradd hadoop #添加一个用户
   2. passwd hadoop #添加密码
   3. 所有的用户目录都在/home
   4. su 命令用于切换用户

3. **su和sudo命令**

   1. su用于用户的之间的切换,切换到root用户需要密码
   2. visudo 与下等效 修改普通用户的执行权限
   3. sudo可以使用  vim /etc/sudoers #修改配置文件

4. **Linux的权限管理**

   1. chmod -R 777 a.txt  #修改执行权限 -R递归修改
   2. chmod -R u-x 或者 u+x a.txt  #增加或者 减少权限

5. **系统服务管理**

   1.   防火墙的命令    **service**  iptables start | stop |status | restart   # 启动 停止 状态 重启
   2. 查看防火墙的状态  设定防火墙开机**on** 自启或**off**停止启动 

6. **网络管理**

   1. 主机名配置

      1. 查看主机名 修改主机名(**永久生效**)

         ``` shell
         vi /etc/sysconfig/network #  修改主机名
         #全限定域名 FQDN
         HOSTNAME=node01.hadoop.com
         #临时修改  hostname 查看主机名
         hostname node01.hadoop.com
         ```

   2. IP地址配置

      1. 方式一 : setup **不建议**
      2. 方式二: **修改配置文件**
      3. 方式三:ifconfig 命令 **重启后无效**

   3. 域名映射

      ``` shell
      vim /etc/hosts
      #修改映射
      ip地址 主机名 起一个简单的主机名 #可以多个映射 
      192.168.70.100
      ```

   4. 网路偶端口监听

      ``` shell
      netstat -nltp  #查看端口使用情况
      ```

   5. crontab 配置 **重要**

      ``` shell
      #crontab : 用于定时完成任务
      
      crontab -l  ## 列出所有存在的crontab
      
      crontab -e  ## 编辑用户目前的crontab
      
      # 在编辑之前要确认crontab 是否开启,并且确定时间的同步
      
      #通过crontab配置虚拟机时钟的同步
      
      */1 * * * * /usr/sbin/ntppdate ntp4.aliyun.com  #完成时间同步, 每隔一分钟进行同步
      
      # * 分钟
      # * 小时
      # * 某月中的一天
      # * 某个月
      # * 一周中的某一天
      
      ```

      

### 3. Linux的shell 编程

 1. shell script : 我们编写的

 2. 版本 

    ``` shell
    /bin/sh
    
    /bin/bash
    
    
    ```

	3.  格式  

    	1. 以.sh 作为文件的后缀,不用管也行,但是规范方便别人观看

    	2. 开头#!/bin/bash , 决定用哪个解释器来执行脚本

        ``` sh
        #!/bin/bash
        # this is 注释
        echo "hello world"
        
        ```

        ``` shell
        #执行方式
        #第一种
        sh hello.sh
        
        #第二种 某些情况下行不通,最好给定权限 chmod u+x ./hello.sh
        . hello.sh
        
        source hello.sh
        # source 与 . 同效
        
        
        ```

	4.  **shell变量**

    	1. 变量的使用

        变量=值  **变量前后一定没有空格,除了变量之间没有空格,到处是空格**

        **规则**

    ``` shell
    #!/bin/bash
    # this is 注释
    echo "hello world"
    
    word=helloword1111 
    
    #当有空格必须加引号
    
    word="hello word"
    
    echo $word  #通过 $ 对变量进行引用 
    
    echo ${word}zhangsan #区分变量相当于拼接字符串 
    #结果: helloword1111zhangsan
    
    ```

    2.  变量类型

       1. 局部变量 :只针对局部有效,其他范围无效
       2. 环境变量 : 是配置环境变量,在全局范围或者用户范围
       3. shell变量 : 只在当前shell脚本中生效

    3. 参数传递

       $n 接受参数

       ``` shell
       #!/bin/bash
       # this is 注释
       echo "hello world"
       
       echo $0 #将执行的脚本的名称
       
       echo $1
       echo $2
       echo $3
       
       sh hello.sh abc def 213
       
       #打印参数
       
       
       
       ```

    4.  特殊字符

       ```shell
       #!/bin/bash
       # this is 注释
       echo "hello world"
       
       echo $0 #将执行的脚本的名称
       
       echo $1
       echo $2
       echo $3
       
       echo $#  # 输出 参数的个数
       
       echo $* #将参数作为一个整体输出
       
       
       ```

    5. shell运算符

       完成加减乘除的运算

       ``` shell
       #!/bin/bash
       # this is 注释
       #变量定义之间不能有空格
       a=4
       b=20
       
       #加法运算  ` 飘  不是单引号 ''他来完成运算
       #表达式与运算符之间要有空格
       echo ` expr $a + $b `
       
       #减法
       echo ` expr $b - $a `
       
       #乘法运算 *号要加转义
       echo ` expr $a \* $b `
       
       #除法
       echo ` expr $b / $a `
       ```

	5. **流程控制**

    	1. if  else 语句

        ``` shell
        #!/bin/bash
        
        a=10
        b=20
        
        #注意空格
        if [ $a -gt $b ]
        then  
        	echo 'a>b'
        elif [ $a -eq $b ]
        then 
        	echo 'a=b'
        else
        	echo 'a<b'
        fi
        ```

    	2. **for 循环**

        	1. 方式一 用的最多

        ``` shell
        for N in 1 2 3  #从123之间循环
        do	#执行
        #被执行的命令
        	echo $N
        done  #代表执行完成
        
        ```

        2. 方式二

        ``` shell
        for (())
        do
        done
        ```

    	3. **while语法**

        	1. 方式一

        ``` shell
        #!/bin/bash
        
        i=1
        while (( i <= 3 ))
        do
        	let i++ #单独的i++ 是不行的必须 加let 
        	echo $i
        done
        
        
        #无限循环
        
        while true
        do
        	command
        done
        
        
        
        
        ```

    	4. **case语句**

        ``` shell
        #!/bin/bash
        echo ' 输出 1 - 4 之间的数字 '
        echo ' 你输入的数字为: '
        
        read aNum
        case $aNum in
        	1) echo '你选择了 1 '
        	;;
        	2) echo '2'
        	;;
        	3) echo '3'
        	;;
        	4) echo '4'
        	;;
        	*) echo '哪一个都没选'
        	;;
        esac
        
        ```

	6.  **函数使用**

    ``` shell
    #!/bin/bash
    
    hello(){
        
        echo 'Hello World'
        echo $1
        echo $2
    }
    
    #调用函数 后边就是参数的写法
    hellO acb 123
    
    
    #在外部调用传参
    hello $1 $2
    
    
    sh hello.sh 123 abcw
    
    
    
    
    ```

    

### 4.大数据环境的准备(见教案)