#### 7.高阶函数

##### ​	7.1作为参数的函数

​	函数可以作为一个参数传入到方法或函数中去

```
  val func=(x:Int) =>{x*x}

    def mymethod(f:Int => Int) ={
      f(10)
    }
    //val map = Array(1,2,3,4,5).map(x => x*x)
    val map = Array(1,2,3,4,5).map(func)
    println(mymethod(func))
    println(map.mkString(","))
```

##### ​	7.2匿名函数

```
def main(args: Array[String]): Unit = {
  println((x:Int,y:String) => x + y)
}
```

##### ​	7.3高阶函数

​	做为方法，可以接受函数作为参数，这个方法称为高阶函数

```
def main(args: Array[String]): Unit = {
    val func:(String,Int)=>(Int,String) ={
      (x,y) => (y+5,x)
    }

    def mymethod(f:(String,Int)=>(Int,String)):Int ={
      val f1 = f("age",20)
      f1._1
    }

    println(mymethod(func))

  }
```

​	高阶函数同样可以返回一个函数类型

```
 def main(args: Array[String]): Unit = {
    def myFunc4(x:Int) = {
      (y:String) => y
    }
    println(myFunc4(50)("sdf"))

  }
```

##### 	7.4参数类型推断

```
def main(args: Array[String]): Unit = {
  val array  = Array(1,2,3,4,5,6,7,8,9)
  //map当中需要传入一个函数，我们可以直接定义一个函数
  array.map((x:Int) => x * 2 )
  //进一步化简 参数推断省去类型信息
  array.map((x) => x * 2 )
  //进一步化简  单个参数可以省去括号
  array.map( x => x * 2 )
  //进一步化简  如果变量只在=>右边只出现一次，可以用_来代替
  array.map( 2 * _ )

}

```

##### ​	7.5闭包与柯里化

```
def main(args: Array[String]): Unit = {
    //函数的柯里化是函数式编程的必然结果
    //函数的柯里化
    def curry(x:Int)(y:Int):Int={

      x+y
    }

    //函数的柯里化
    def curry1(x:Int,y:Int):Int={

      x+y
    }

    def curryMethod(x:Int)={
      //方法的外部参数传入的匿名函数中使用，称为闭包
      (y:Int) => x+y
    }

    println(curry(20)(30))
    println(curry1(20,30))
    println(curryMethod(20)(30))
  }
```

8.类

​	scala中可以通过class创建一个类，类中可以定义各种各样的方法和属性

##### ​	8.1类的定义

```
class Person {
  //定义一个属性，叫做name的，使用val不可变量来进行修饰
  // 用val修饰的变量是可读属性，有getter但没有setter（相当与Java中用final修饰的变量）
  val name:String ="zhangsan"
  //定义一个属性，叫做age的，使用var可变量来进行修饰
  //用var修饰的变量都既有getter，又有setter
  var age:Int = 28

  //类私有字段，只能在类的内部使用或者伴生对象中访问
  //半生对象就是和当前类一样名称的对象  Object Person{}
  private val  address:String = "地球上"

  //类私有字段，访问权限更加严格的，该字段在当前类中被访问
  //在伴生对象里面也不可以访问 
  private[this] var pet = "小强"

  //在类当中定义了一个方法，
  def hello(first:Int,second:String):Int ={
    println(first+"\t"+second)
    250
  }
  /**
    * 定义了一个函数
    */
  val func1 =(x:Int,y:Int) =>{
    x+y
  }

}
```

##### 	8.2类的实例化和使用

```
object ScalaClass {

  def main(args: Array[String]): Unit = {
    //通过new完成一个类的实例化
    val person = new Person
    val person1 = new Person()
    //java中 get set方法
    //val 的变量只提供了get方法
    println(person.name)
    println(person.age)

    //var变量提供了get和set方法
    person.age = 30
    //.age_= 实际就一个底层提供的set方法
    //person .age_= (40)
    println(person.age)
    println(person.hello(34,"he"))
    println(person.func1)

  }

}
```

##### 	8.3属性的getter和setter方法

```
//getter方法
println(person age)
//setter方法
println(person age_= (18))
//getter方法
println(person.age)

```

##### ​	8.4类的构造器

​	scala中有两种构造器：

​		1）主构造器：主构造器一定会调用

​		2）辅构造器：辅构造器的调用一定会调用主构造器

```
package cn.itcast.scala.chapter8
//在类名上创建的叫主构造器
class Dog(name:String,age:Int) {

  var gender:String =""
  //辅构造器
  def this(name:String,age:Int,gender:String){
    this(name,age)
    this.gender = gender
  }
  var color =""

  def this(name:String,age:Int,gender:String,color:String){
    //辅构造器可以调用辅构造器
    this(name,age,gender)
    this.color = color
  }
}
object DogTest{

  def main(args: Array[String]): Unit = {
    val dog = new Dog("小黑",3)
    val dog1 = new Dog("小白",4,"weizhi")
  }
}
```

#### 9.对象

​	java中有static的概念，scala没有static的修饰，有一个Oeject，可以理解为Oeject中都是一些静态方法和属性

​	对象的使用：

```
object SessionFactory{

  //获取session实例
  val session = new Session
  def getSession():Session ={
    session
  }

  def main(args: Array[String]): Unit = {
    for(i <- 1 to 10){
      //object中的对象可以直接调用里面的方法
      val session1 = SessionFactory.getSession
      println(session1)
    }

  }

}
```

##### ​	9.2.伴生类与伴生对象

​	1）一定有一个class类和object对象，放在一个文件中

​	2）伴生类与伴生对象的名称是一致的

​	3）最大特点是可以互相访问。

```
class ClassObject {
  val id = 1
  private var name = "itcast"
  def printName(): Unit ={
    //在Dog类中可以访问伴生对象Dog的私有属性
    println(ClassObject.CONSTANT + name )
  }
}


object ClassObject{
  //伴生对象中的私有属性
  private val CONSTANT = "汪汪汪 : "
  def main(args: Array[String]) {
    val p = new ClassObject
    //访问私有的字段name
    p.name = "123"
    p.printName()
  }
}

```

##### ​	9.3apply

​	apply是一个特殊方法，往往作为初始化使用。

```
class ApplyObjectClass(name:String) {
  println(name)
}

object ApplyObjectClass{

  def apply(name: String): ApplyObjectClass ={
    new ApplyObjectClass(name)
  }

  def main(args: Array[String]): Unit = {
    val cls = new ApplyObjectClass("zhangsan")
    val cls1 = ApplyObjectClass("zhangsan")
    val ints = new Array[Int](5)
    Array(1,2,3)
    Array.apply(1,2,3)
  }
}
```

##### ​	9.4scala当中的main方法（了解）

```
object Main_Demo1 {
  def main(args: Array[String]): Unit = {

    println("hello ")
  }
}
object Main_Demo2  extends App{
  //里面所有的内容都会在App里面的Main方法中执行
  println("hello1")
}
```

##### ​	9.5枚举（了解）

​	scala中没有enum，但是可以通过object Test  extends  Enumeration 来完成枚举的操作。

#### 10.继承

​	10.1 scala中的继承

```
class Person {

  val name ="zhangsan"
  def getName =this.name
}

class Student extends  Person{
  override val name: String = "zhangsanfeng"
  val score:String = "A"
  def getScore= this.score
}

object Test{

  def main(args: Array[String]): Unit = {
    val student = new Student
    
  }
}
```

##### ​	10.2 Scala中override 和 super 关键字

```
class Person1 {
  private val name = "leo"
  val age=50
  def getName = this.name
}
class Student1 extends Person1{
  private val score = "A"
  //子类可以覆盖父类的 val field,使用override关键字
  override val age=30
  def getScore = this.score
  //覆盖父类非抽象方法，必须要使用 override 关键字
  //同时调用父类的方法，使用super关键字
  override def getName = "your name is " + super.getName
}

object Test1{
  def main(args: Array[String]): Unit = {
    val student = new Student1
    println(student.getName)
  }
}

```

##### ​	10.3.Scala中isInstanceOf 和 asInstanceOf

​B extends A      B.instanceOf(A)  (A)B   

B.isinstanceOf(A) :用于判断B是否是A的子类或者是A的相同类型

B.asinstanceOf(A) ：用于将B强制转换为A类型

```
 def main(args: Array[String]): Unit = {
    val student:Student3 = new Student3
    val person:Person3 = new Student3
    var student2:Student3 = null
    println(person.isInstanceOf[Student3])
    if(person.isInstanceOf[Student3]){
      student2 =  person.asInstanceOf[Student3]
    }
    println(student2.isInstanceOf[Person3])
  }
```

##### ​	10.4Scala中getClass 和 classOf

​	isInstanceOf：只能判断一个类是否另一个类的子类或当前类

​	如果要精确的判断一个对象到底属于哪个类：getClass 和 classOf

​	getClass：obj.getClass可以精确获取对象的类

​	classOf:精确的获取类

​	obj.getClass  == classOf[]

```
 def main(args: Array[String]): Unit = {
    val p:Person4 = new Student4

    println(p.isInstanceOf[Student4])
    println(p.isInstanceOf[Person4])
    println(p.getClass == classOf[Person4]) //false
    //精准判断对象类型
    println(p.getClass == classOf[Student4]) //true
  }
```

##### 	10.5Scala中使用模式匹配进行类型判断

```
package cn.itcast.extends_demo

class Person5 {}
class Student5 extends Person5
object Student5{
  def main(args: Array[String]) {
    val p:Person5=new Student5
    p match {
      // 匹配是否为Person类或其子类对象
      case per:Person5 => println("This is a Person5's Object!")
      // 匹配所有剩余情况
      case _  =>println("Unknown type!")
    }
  }
}

```

##### ​	10.6 Scala中protected(理解)

```
class Person6{
  protected var name:String="tom"
  protected[this] var hobby:String ="game"
  protected def sayBye=println("再见...")
}
class Student6 extends Person6{
  //父类使用protected 关键字来修饰 field可以直接访问
  def  sayHello =println("Hello "+name)
  //父类使用protected 关键字来修饰method可以直接访问
  def  sayByeBye=sayBye
  def makeFriends(s:Student6)={
    println("My hobby is "+hobby+", your hobby is UnKnown")
  }
}
object Student6{
  def main(args: Array[String]) {
    val s:Student6=new Student6
    s.sayHello
    s.makeFriends(s)
    s.sayByeBye
  }

```

##### ​	10.7Scala中调用父类的constructor

​	在继承的时候，子类直接由主构造器调用父构造器

```
class Person7(val name:String,val age:Int) {

  var score:Double = 0.0

  //第一个辅助构造器
  def this(name:String,score:Double){
    this(name,20)
    this.score = score
  }
  var address = ""
  //第二个辅助构造器
  def this(name:String,address:String){
    this(name,20)
    this.address = address
  }

}
class Student7(name:String,score :Double) extends Person7(name,score)
object Student7{
  def main(args: Array[String]): Unit = {
     val student = new Student7("zhangsan",100.0)
    println(student.name)
  }
}
```

##### ​	10.8scala中的抽象类（理解）

​	scala中的抽象类和java类似，可以定义未实现的方法或属性。

```
abstract class Person9 (val name:String){

  def sayHello:String
  def sayGoodbye:String
}

class Student9(name:String) extends Person9(name) {
  override def sayHello: String = "hello," + name

  override def sayGoodbye: String = "goodbye," +name
}

object Student9 extends App{
  val lisi = new Student9("lisi")
  println(lisi.sayHello)
  println(lisi.sayGoodbye)

}
```

##### ​	10.9Scala中抽象field

```
abstract class Person10 (val name:String){
//抽象fields
    val age:Int
}
class Student10(name: String) extends Person10(name) {
   val age: Int = 50
}

```

#### 11.特质Trait

##### ​	11.1.将trait作为接口使用

​	1)trait可以作为接口使用，可以定义抽象的方法，也可以定义具体实现的方法。

​	2）scala中没有implements，实现接口通过extends 继承trait。

​		通过extends ... with 的方式实现多继承。

​		extends  Animal with Seriable

```
trait HelloTrait {
  def  sayHello()
}

trait MakeFriendsTrait{
  def  makeFriends(c:Children)
}

class Children(val name:String) extends HelloTrait with MakeFriendsTrait{
  override def sayHello(): Unit = println("hello" + name)

  override def makeFriends(c:Children): Unit = println("Hello, my name is " + this.name + ", your name is " + c.name)
}

object Children{

  def main(args: Array[String]): Unit = {
    val c1 = new Children("zhangsan")
    val c2 = new Children("lisi")
    c1.sayHello()
    c1.makeFriends(c2)
  }
}
```

##### ​	11.2在trait中定义具体的方法

```
trait Logger {
  def log(message: String): Unit = println(message)
}
class PersonForLog(val name: String) extends Logger {
  def makeFriends(other: PersonForLog) = {
    println("Hello, " + other.name + "! My name is " + this.name + ", I miss you!!")
    this.log("makeFriends method is invoked with parameter PersonForLog[name = " + other.name + "]")
  }
}
object PersonForLog{
  def main(args: Array[String]) {
    val p1=new PersonForLog("jack")
    val p2=new PersonForLog("rose")
    p1.makeFriends(p2)
    //Hello, rose! My name is jack, I miss you!!
    //makeFriens method is invoked with parameter PersonForLog[name = rose]
  }
}
```

##### ​	11.3在trait中定义具体field

```
trait PersonForField {
  val  age:Int=50
}
class StudentForFieldParent{
  val age1:Int = 80
}

class StudentForField1(val name: String) extends StudentForFieldParent with PersonForField {
  override val age1: Int = 30

}
//继承 trait 获取的field直接被添加到子类中
class StudentForField(val name: String) extends PersonForField {
  def sayHello = println("Hi, I'm " + this.name + ", my  age  is "+ age)
}

object StudentForField{
  def main(args: Array[String]) {
    val s=new StudentForField("tom")
    s.sayHello
  }
}
```

##### ​	11.4在trait中定义抽象field

```
trait SayHelloTrait {
  val msg:String
  def sayHello(name: String) = println(msg + ", " + name)
}

class PersonForAbstractField(val name: String) extends SayHelloTrait {
  //必须覆盖抽象 field
  val msg = "Hello"
  def makeFriends(other: PersonForAbstractField) = {
    this.sayHello(other.name)
    println("I'm " + this.name + ", I want to make friends with you!!")
  }
}
object PersonForAbstractField{
  def main(args: Array[String]) {
    val p1=new PersonForAbstractField("Tom")
    val p2=new PersonForAbstractField("Rose")
    p1.makeFriends(p2)
  }
}
```

##### ​	11.5在实例对象指定混入某个trait

​	class Student

​	new Student()  with  wenkeTrait

​	new Student()  with  likeTrait

```
trait LoggedTrait {
  // 该方法为实现的具体方法
  def log(msg: String) = {}
}
trait MyLogger extends LoggedTrait{
  // 覆盖 log() 方法
override def log(msg: String) = println("log: " + msg)
}

class PersonForMixTraitMethod(val name: String) extends LoggedTrait {
  def sayHello = {
    println("Hi, I'm " + this.name)
    log("sayHello method is invoked!")
  }
}
object PersonForMixTraitMethod{
  def main(args: Array[String]) {
    val tom= new PersonForMixTraitMethod("Tom").sayHello //结果为：Hi, I'm Tom
    // 使用 with 关键字，指定混入MyLogger trait
    val rose = new PersonForMixTraitMethod("Rose") with MyLogger
    rose.sayHello
// 结果为：     Hi, I'm Rose
// 结果为：     log: sayHello method is invoked!
  }
}
```

##### ​	11.6trait 调用链

​	一个类继承多个trait，每一个trait都有相同方法时，是如何完成调用的

​	实际是从继承的右侧一次往左调用

```
trait HandlerTrait {
  def handle(data: String) = {println("last one")}
}
trait DataValidHandlerTrait extends HandlerTrait {
  override def handle(data: String) = {
              println("check data: " + data)
              super.handle(data)
}
}
trait SignatureValidHandlerTrait extends HandlerTrait {
  override def handle(data: String) = {
          println("check signature: " + data)
          super.handle(data)
  }
}
class PersonForRespLine(val name: String) extends SignatureValidHandlerTrait with DataValidHandlerTrait {
  def sayHello = {
        println("Hello, " + this.name)
        this.handle(this.name)
  }
}
object PersonForRespLine{
  def main(args: Array[String]) {
     val p=new PersonForRespLine("tom")
      p.sayHello
      //执行结果：
//    Hello, tom
//    check data: tom
//    check signature: tom
//    last one
  }
}
```

##### 	11.7混合使用 trait 的具体方法和抽象方法

```
trait ValidTrait {
  //抽象方法
  def getName: String
  //具体方法，具体方法的返回值依赖于抽象方法

  def valid: Boolean = {"Tom".equals(this.getName)
  }
}
class PersonForValid(val name: String) extends ValidTrait {
  def getName: String = this.name
}

object PersonForValid{
  def main(args: Array[String]): Unit = {
    val person = new PersonForValid("Rose")
    println(person.valid)
  }
}
```

##### 	11.8trait的构造机制

​		trait中构造调用是从左往右进行调用的

```
class Person_One {
  println("Person's constructor!")
}
trait Logger_One {
  println("Logger's constructor!")
}
trait MyLogger_One extends Logger_One {
  println("MyLogger's constructor!")
}
trait TimeLogger_One extends Logger_One {
  println("TimeLogger's contructor!")
}
class Student_One extends Person_One with MyLogger_One with TimeLogger_One {
  println("Student's constructor!")
}
object exe_one {
  def main(args: Array[String]): Unit = {
    val student = new Student_One
    //执行结果为：
    //      Person's constructor!
    //      Logger's constructor!
    //      MyLogger's constructor!
    //      TimeLogger's contructor!
    //      Student's constructor!
  }
}
```

##### ​	11.9trait 继承 class

​	在Scala中trait 也可以继承 class，此时这个 class 就会成为所有继承该 trait 的子类的超级父类。

```
class MyUtil {
  def printMsg(msg: String) = println(msg)
}
trait Logger_Two extends MyUtil {
  def log(msg: String) = this.printMsg("log: " + msg)
}
class Person_Three(val name: String) extends Logger_Two {
    def sayHello {
        this.log("Hi, I'm " + this.name)
        this.printMsg("Hello, I'm " + this.name)
  }
}
object Person_Three{
  def main(args: Array[String]) {
      val p=new Person_Three("Tom")
      p.sayHello
    //执行结果：
//      log: Hi, I'm Tom
//      Hello, I'm Tom
  }
}

```

#### 12.模式匹配和样例类

​	用于判断数值是一个什么类型。

​	匹配用到一个关键字 match，类似于java中switch

##### ​	12.1字符匹配

```
 def main(args: Array[String]): Unit = {
    //字符匹配
    val charStr = "a"

    charStr match {
      case "+" => println("+")
      case "-" => println("-")
      case "*" => println("*")
      case "/" => println("/")
      case _ =>println("哥们，没有匹配上")

    }
  }
```

##### ​	12.2 匹配字符串

```
def main(args: Array[String]): Unit = {
    //字符串匹配
      val arr = Array("hadoop","zookeeper","hbase")
      val str = arr(Random.nextInt(arr.length -1))
    
    str match {
      case "zookeeper" =>println("zookeeper")
      case "hadoop" =>println("hadoop")
      case "hbase" =>println("hbase")
      case _ => println("nothing")
    }
  }
```

##### 	12.3守卫模式

```
def main(args: Array[String]): Unit = {

    var ch  = "500"
    ch match {
      case "+" => println("+")
      case "-" => println("-")
      case "*" => println("*")
      case "/" => println("/")
      case _ if ch.equals("500") =>println("500")
      case _ =>println("哥们，没有匹配上")
    }
  }
```

##### ​	12.4匹配类型

```
def main(args: Array[String]): Unit = {
  //在模式匹配中，除了Array集合外的其他集合，相关的泛型都会被擦出掉
  val a =8
  val obj = if(a == 1) 1
  else if(a == 2) "2"
  else if(a == 3) BigInt(3)
  else if(a == 9) Map(1 -> 1)
  else if(a == 4) Map("aa" -> 1)
  else if(a == 5) Map(1 -> "aa")
  else if(a == 6) Array(1, 2, 3)
  else if(a == 7) Array("aa", 1)
  else if(a == 8) Array("aa")

  val result = obj match  {
    case x:Int => x
    case s:String => s
    case x:BigInt => BigInt(3)
    case x:Map[BigInt,Int] =>"map[BigInt,Int]"
    case x:Map[Int,String] =>"map[Int,String]"
    case m:Array[Int] =>"Array[Int] "
    case m:Array[String] =>"Array[String]"
    case m:Array[Any] =>"Array[Any]"

    case _ =>"nothing"


  }

  println(result +"," +result.getClass)

}
```

​	5.匹配数组、元组、集合

```
def main(args: Array[String]): Unit = {
  val arr = Array(0, 3, 5)
  arr match {
    case Array(0, x, y) => println(x + " " + y)
    case Array(0) => println("only 0")
      //匹配数组以1 开始作为第一个元素
    case Array(1, _*) => println("0 ...")
    case _ => println("something else")
  }

  val lst = List(3, -1)
  lst match {
    case 0 :: Nil => println("only 0")
    case x :: y :: Nil => println(s"x: $x y: $y")
    case 0 :: tail => println("0 ...")
    case _ => println("something else")
  }

  val tup = (1, 3, 7)
  tup match {
    case (1, x, y) => println(s"1, $x , $y")
    case (_, z, 5) => println(z)
    case  _ => println("else")
  }

}
```

##### ​	12.6样例类

​	样例类主要用于模式匹配

​	case class Student（id:String）:多例的

​	case object Student1：单例

```

case class SubmitTask(id: String, name: String)
case class HeartBeat(time: Long)
case object CheckTimeOutTask
//1、样例类当中的主构造器参数默认为val的
//2、样例类当中的apply和unapply方法自动生成
object CaseDemo04 extends App {
  val arr = Array(CheckTimeOutTask, HeartBeat(12333), SubmitTask("0001", "task-0001"))
  //val arr1 = arr(Random.nextInt(arr.length-1))
  arr(2) match {
    case SubmitTask(id, name) => {
      println(s"$id,$name")
      println(id)
      println(name)
      println(id+"\t"+name)
    }
    case HeartBeat(time) => {
      println(time)
    }
    case CheckTimeOutTask => {
      println("check")
    }
  }
}

```

##### ​	12.7偏函数（了解）

```
val func1: PartialFunction[String, Int] = {
  case "one" => 1
  case "two" => 2
 // case _ => -1
}

def func2(num: String) : Int = num match {
  case "one" => 1
  case "two" => 2
  case _ => -1
}

def main(args: Array[String]) {
  println(func1("one"))
  println(func2("one"))
  //如果偏函数当中没有匹配上，那么就会报错，我们可以通过isDefinedAt来进行判断
 // println(func1("three"))
  println(func1.isDefinedAt("three"))
  if(func1.isDefinedAt("three")){
    println("hello world")
  }else{
    println("world hello")
  }
}
```

13.类型参数（了解）

##### ​	13.11、 scala当中的类的泛型

```
object Demo8 {
  def main(args: Array[String]): Unit = {
    val result1 = new MyClass("hello",50)
    val result2 = new MyClass[Any,Any]("zhangsan","Lisi");
  }
}

/**
  * 定义一个class类，接收两个参数，但是两个参数都是泛型，泛型的类型，会根据我们
  * 创建类的实例化对象的时候，动态的传递进行动态的推断
  * @param first
  * @param second
  * @tparam T
  * @tparam B
  */
class  MyClass[T,B](first:T,second:B){
  println(first+","+second)
}
```

##### ​	13.2函数的泛型

```
object methodType{
  def getMiddle[T](canshu:T) ={
    canshu
  }
  def main(args: Array[String]): Unit = {
    // 从参数类型来推断类型
    println(getMiddle(Array("Bob", "had", "a", "little", "brother")).getClass.getTypeName)
    //指定类型，并保存为具体的函数。
    val f = getMiddle[String] _
    println(f("Bob"))
  }
}
```

##### ​	13,3scala当中的上下界之泛型类型的限定

​	JAVA：  student extends  Person

?  extends  T    上界     必须是T的子类

?  super    T      下界     必须是T的父类

​	scala中：上界：  <: 泛型的上界

​			  下界	>: 泛型的下界  

​	A--B--C--D--E   B继承A   C继承B  D继承C  

​			student[T <: C]   C D  E

​			student[T >: C]   A  B  C

##### ​	14.scala当中的视图界定

```
  * 使用 <%  来实现我们类型的隐式转换
  * scala Int是基本类型，完成不了Comparable的比较
  * 会将Int转换为RichInt再进行比较
```

##### ​	15.scala当中的协变，逆变和非变

​	class Cat  extends  Animal

​	java 中 ：List<Cat>     extends   List<Animal>  两个列表没有关系

​	List<Cat>   extends   List<Animal>   称为协变

​	List<Animal>   extends   List<Cat>    称为逆变

​	List<Cat>  = List<Cat>   不变 （非变）