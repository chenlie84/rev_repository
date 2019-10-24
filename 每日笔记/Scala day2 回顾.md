## Scala day2 回顾

1. 高阶函数  将函数作为方法的参数来使用
2. 柯里化 , 
3. Scala类
   1. class来定义
      1. var 有get和set方法
      2. val 只有get
      3. 主构造器
      4. 辅助构造器 this() ,之间不能互相调用 , 必须调用主构造器
4. Scala对象
   1. object 来定义对象  
   2. 往往定义的是类似java中静态的方法和属性
   3. 半生类和半生对象
      1. 这两个会放在放在一个文件中
      2. 名称一样
      3. 不可以访问private[this] 修饰的变量
   4. apply : 用于初始化 
5. Scala继承
   1. 关键字 extends  也只支持单继承
6. Trait特质  类似 java 中的特质
   1. 使用extends 来进行实现
   2. 使用with 来实现 多继承特质
   3. 既可以 定义抽象的变量和方法 , 也可以定义实现后的方法
7. 模式匹配 和  样例类
   1. match { case }  
   2. 样例类 case class Student() 用于类型的判断, 和数据的传递
8. 泛型 (了解)      

























