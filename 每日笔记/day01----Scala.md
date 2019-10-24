## day01----Scala

### 1.课程目标

1. ##### Scala的历史发展

   1. Scala: 是一门编程语言 , 一门函数式编程语言 , 诞生时间 : **2003**
   2. java : 92年诞生 , 94-5年才开始被人熟知
   3. Scala进行编译 , 最后生成的也是 .class
   4. 直到 2013年, spark的出现 .
   5. Scala不能**向下兼容**, 所以对于版本的选定要慎重

2. ##### 学习目标

   1. ##### 熟练使用Scala编写spark程序

   2. ##### 手动编写一个建议的spark交互程序

   3. ##### 为读取spark源码准备

### 2.Scala的编译器安装

1. 前提是安装JDK 

### 4..Scala的基本语法

1. 方法的定义
2. 函数的定义
3. 将函数作为参数传进方法中
4. 方法转换成一个函数 (隐式转换)

### 5.懒值加载

1. 关键字 

   ``` scala
   lazy val 
   ```

### 6.数据结构

1. Scala中支持可变集合 和 不可变集合

   1. 不可变集合 :scala.collection .immutable  (**优先使用**)
   2. 可变集合 : scala.collection.mutable

2. ###### **数组**

   ``` scala
   //定长数组
   
   //在数组中不可变的是 长度
   val array = new Array[int](10)
   //如果不设置值,默认值是 0
   array(1)=2  //将下标为1的值设置为2
   
   //指定值设置数组, 通过apply进行初始化
   val array = array(1,2,3)
   
   
   //-----------------------------
   
   //变长数组
   //arraybuffer 完成变长数组
   
   //不用指定长度,进行数组的定义
   val array = new ArrayBuffer[Int]()
   
   array.append(20,30)
   
   //字符串类型
   val array = new ArrayBuffer[String]()
   
   array.append("helloworld")
   
   
   //-----------------------------
   
   //定长数组与变长数组的转换
   //1.定 转 变
   val array1 = array.tobuffer
   array1.append(12,12,12)
   
   //2.变 转 定
   val array2 = array1.toArray
   //不能追加,否则会数组越界
   
   //-----------------------------
   
   //多维数组(了解)
   
   
   //-----------------------------
   
   
   //数组的遍历
   val array = arraybuffer(1,2,3,4,5,6)
   for(x <- array) {
       pritnln(x)
   }
   
   //数组中常见的算法
   array.max
   ```

3. ###### 元组

   ``` scala
   //Scala中提供的数据类型 元组 (tuple)
   
   //元组中可以存放任意类型的数据 , 但是一旦创建,就不能修改
   
   //最多可以放22个数据.
   
   //1.创建元组 , 使用小括号
   val tuple = ("hello",1,23,4,23.3,)
   println(tuple)
   
   //获取元组的数据
   //获取某个元素, _下角标(相当于)
   val firstResult = tuple._1
   
   //
   
   
   //=---------------------------
   //第一种遍历
   //元组的迭代器遍历方式 , 使用少
   
   //第二种遍历 使用多
   //通过元组的迭代器调用foreach(
   //获取元组中的数据 , 赋值给x, 然后进行一个打印
   	x => println(x)
   	//第三种
   	println  //简化的写法
   
   )
   
   //第三种遍历
   
   ```

4. ###### 映射Map

   ``` scala
   //首字母大写重要
   
   //scala 中按照Key Value的形式进行数据的组织
   
   
   //不可变Map
   val map = Map("hello" -> "world" , "name"->"zhangsan")
   //不可变的Map的添加,实际上是生成一个新的Map
   
   //-----------------------------
   
   //可变的Map
   
   
   //获取Map中指定的Key的值
   map.get("hello")
   
   ```

5. ###### 列表

   ``` Scala
   //与Java中的类似
   //创建列表
   //同样可以放不同类型的元素
   
   //访问元素
   val listresult =  list(0)
   
   //从列表中添加元素 在末尾添加 , 生成一个新的列表
   val list2 = list:+ 80
   
   //在头部添加元素,都是创建一个行动列表
   val list3 = 80 +: list
   
   
   //list的创建与追加元素
   //Nil空的列表
   //添加NIl , 将列表作为一个元素,添加进集合
   val list4 = 1::2::3::list::Nil
   //不添加就是 , 将集合中的元素,拆开,当成独个的元素添加
   val list5 = 1::2::3::list
   
   //最后的一定是一个列表 , 
   val list = 1::2::3 // 此种不行
   
   
   //-----------------------------
   
   //变长list的创建
   //mutable,这个包下的类
   //不需指定长度
   val list = new listBuffer[String]
   
   lsit.append("随意添加元素")
   
   
   //将可变的list 转成 不可变的list
   list.tolist
   //方法中就没有添加的方法
   
   ```

6. ######  Set集合

   ``` Scala
   //不可变集合的创建
   //没有NEW , 是通过apply进行初始化
   val set = Set("1","1","2","3")
   //不可重复 , 无序
   
   //-----------------------------
   
   //可变集合的创建
   val set = Scala.Collection.Mutable.Set("1","2","3")
   
   //添加元素
   set.add("4")
   //在原有的集合基础上,进行添加
   set += "5" //相等于  set.+=("5")
   
   set.+("6") //创建了一个新的集合
   
   //删除元素
   set.-= 1
   set.remove(2)
   
   
   //遍历set集合元素
   for (X <- set) {
       println(x)
   }
   
   ```

7. ######  集合元素与函数的映射(相当重要)

   ``` scala
   //map : 将集合中的每一个元素映射到某一个函数,完成相关的操作
   
   //通过Map方法实现元素中的每一个字符串转化成大写
   val list = list("name","zjhangsan")
   ```

8. ###### queue队列

9. ###### 集合中的简化,折叠,与扫描操作

### 7.高阶函数

1. 作为参数的函数

### 8.类的建立

### 9.对象

### 10.继承

9.  scala中的抽象类和java中的类似 

   ``` scala
   abstract class person (val name:String) {
       
   }
   ```

   

### 11.特质Trait

1. 将特质作为接口来使用 , 可以定义抽象的方法,**也可以定义具体的实现的方法**
2. scala中没有implements, 实现特质是通过extends来继承特质
3. 从左往右一次调用 , (有相同的方法)
4. 混合使用trait的具体方法和抽象方法
5. trait的构造机制
   1. 构造器是从左往右进行调用的
6. 特质可以继承类
   1. 此时所有特质的子类就会有一个超级父类

### 12.模式匹配和样例类

1. ###### 模式匹配 : 用于判断数值是什么类型,理解

2. ###### 匹配用到一个关键字 match

   1. ##### 字符匹配

      ``` scala
      main {
          
        charStr match {
          case "+" => println("+")
          ....
            //默认的当没有的匹配上的时候输出的 "_" 代表默认
          case _ => pritnln("")
        }
      }
      
      ```

   2. ###### 字符串匹配

      ``` scala
      main {
      	val arr = Aarray("多个字符串")
          
          
      }
      ```

   3. ######  守卫模式

      ``` scala
      main {
          
         var ch = 500 
        charStr match {
          case "+" => println("+")
          ....
            
            
          case _ if ch.eq("500") =>打印  
            //默认的当没有的匹配上的时候输出的 "_" 代表默认
          case _ => pritnln("")
        }
      }
      ```

   4. ######  匹配类型

      ``` scala
      
      ```

   5. ###### 匹配数组 元组 ,列表

      ``` scala
      
      ```

   6. ###### 样例类

      ``` Scala
      //样例类主要用于模式匹配
      
      
      ```

   7. ######  偏函数

      ``` Scala
      //强调一进一出
      ```

      

### 13.类型参数

1. 



### 记录.下划线 "_"的用法,神一样的存在

1. _ 作为导包的通配符

2. 将方法转换成一个函数

   ``` scala
   def method(x:Int) = {
       x*x
   }
   val myfunc4 = method_
   
   //方法中的参数最多只有22个
   
   ```

3. 通过指定的角标元组的数据 , **_+下角标** ,

4. 匿名函数中如果元素在 => 右侧只出现一次, 那么用**"_"**代替

5. 在继承中 **"_"** 当成默认值 