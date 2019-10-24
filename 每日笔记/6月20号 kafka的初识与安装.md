##  kafka

1. 是什么?
   1. 企业级的消息队列,目标是构建企业中统一的,高通量的,低延迟的消息平台

2. **用来干什么的?**
   1. 解耦
      1. kafka能够做到完全解耦合

         ``` java
         //完全解耦合
         消息提供者 只需要把消息提供给 Kafka 它不需要管消息的服务者是否开启或关闭
         消息的消费者 同理 他只需要从Kafka中获取消息就行 
         //提供者 和 消费者 之间没有任何的联系,做到完全的解耦合
         ```

   2. 异构

      1. 同步变异步

      ``` java
      //同步的缺点:
      响应时间,最长	
      如果服务器宕机,
      //多线程的缺点:
      等待时间,比同步短
      但是,当服务器宕机,等待的时间又不是确定
      	
      //异构
      //举例:  用户的注册
      消息的生产者  注册的请求  
      消息的中间件  kafka集群
      消息的消费者  注册的业务  等等其他的业务

      //当没有消息中间件
      发送的求情会直接调用业务,这样代码的耦合度非常高,而注册有很多的步骤,在注册的时候,每一个业务的完成都需要时间,最后一个注册就花费很长的时间,用户是不会等待的.
        
      //当代码之间有了Kafka等消息中间件
      当注册的请求发过来, 不会直接的调用业务,而是发布到消息中间件中,等待业务进行消费,然后直接给用户返回注册成功,所以用户1MS就可以完成注册,虽然返回的是一个虚假的信息,但是当用户转向业务的时候,注册的业务已经调用完成.从而减少用户的等待时间
      ```

   3. 缓冲/削峰

      1. 削峰填谷

      ``` java
      用户的请求在不同的时刻,数量会不同,
      //有的时候,请求会非常的低,即低谷
      //有的时候,请求会非常的高,即峰值
      当达到峰值的时候,服务器就会面临着崩溃的压力,所以为了防止服务器的压力过大,可以在低谷期来处理峰值时的数据,拦截峰值的请求.
       //这样可以做到减少生产成本
      ```

3. 搭建KAfka集群 

   ``` java
   //参考文档
   ```

   1. 启动Kafka

      ``` java
      //在bin目录下执行
      ./kafka-server-start ../conf/server.properties //这种启动方式不推荐 ,因为Ctrl C会直接停止
      //推荐后台执行   2>&1 将日志合并到一个上 最后一个代表后台执行
        nohup ./kafka-server-start.sh ../conf/server.properties 2>&1 &
       
      ```

   2. 创建Topic

      ``` java
      //创建一个订单Topic
      //在Bin目录下执行   kafka借用zookeeper来协调服务 
      ./Kafka-topic.sh --create --zookeepr bigdata01:2181 --replication-factor 1 --partitions 1 --topic order  
      ```

   3. 创建Producer

      ``` java
      //创建一个提供者  broker-list 代表一个Kafka集群掮客
      ./Kafka-console-producer.sh --broker-list bigdata01:9092 --topic order
      ```

   4. 创建Consumer

      ``` java
      //编写一个消费者
      ./Kafka-console-consumer.sh --zookeeper bigdata01:2181 --from-beginning -topic order

      ```

4. Kafka的API

   1. 依赖

      ``` xml
       <dependencies>
              <!--kafka的依赖-->
              <dependency>
                  <groupId>org.apache.kafka</groupId>
                  <artifactId>kafka-clients</artifactId>
                  <version>0.11.0.1</version>
              </dependency>

          </dependencies>

      ```

      ​

   2. kafkaProducer

      ``` java
      package com.itheima.kafka.producer;

      import org.apache.kafka.clients.producer.KafkaProducer;
      import org.apache.kafka.clients.producer.ProducerRecord;

      import java.util.Properties;

      /**
       * @ClassName OrderProducer
       * @Description TODO 订单数据的生产者
       */
      public class OrderProducer {
          public static void main(String[] args) {
              //连接kafka集群
              Properties props = new Properties();
              //配置集群参数--不需要记，但是要理解
              props.put("bootstrap.servers", "node01:9092");
              props.put("acks", "all");//确认码为-1
              props.put("retries", 0);//重试的次数 ，如果不为0的话，有可能会有重复数据
              props.put("batch.size", 16384);//每个批次发送数据的个数上限
              props.put("linger.ms", 1);//时间的上限
              props.put("buffer.memory", 33554432);
              props.put("key.serializer",
                      "org.apache.kafka.common.serialization.StringSerializer");
              props.put("value.serializer",
                      "org.apache.kafka.common.serialization.StringSerializer");
              KafkaProducer<String,String> kafkaProducer = new KafkaProducer<String, String>(props);
              //创建要发送的数据
              //ProducerRecord<String, String> record = new ProducerRecord<String, String>("order",null,"订单2");
              //send发送数据到kafka
              //kafkaProducer.send(record);
              //kafkaProducer.flush();//刷新缓冲区

      //        while (true){
      //            ProducerRecord<String, String> record = new ProducerRecord<String, String>("order",null,"当年她以一曲狮子座成功出道,牵动了万千少女的心,如今曾哥人气已经沦落到18线了,现在网上几乎没有她的消息。同为快乐女声出道的人气歌手春哥现在人气甩曾哥十八条街当年她以一曲狮子座成功出道,牵动了万千少女的心,如今曾哥人气已经沦落到18线了,现在网上几乎没有她的消息。同为快乐女声出道的人气歌手春哥现在人气甩曾哥十八条街");
      //            //send发送数据到kafka
      //            kafkaProducer.send(record);
      //            kafkaProducer.flush();//刷新缓冲区
      //        }
              for(int i=1;i<=100;i++){
                  ProducerRecord<String, String> record = new ProducerRecord<String, String>("spider-test",null,"订单"+i);
                  //send发送数据到kafka
                  kafkaProducer.send(record);
                  kafkaProducer.flush();//刷新缓冲区
              }
          }
      }
      ```

   3. kafkaConsumer

      ``` java
      package com.itheima.kafka.consumer;

      import org.apache.kafka.clients.consumer.ConsumerRecord;
      import org.apache.kafka.clients.consumer.ConsumerRecords;
      import org.apache.kafka.clients.consumer.KafkaConsumer;

      import java.util.Arrays;
      import java.util.Properties;

      /**
       * @ClassName OrderConsumer
       * @Description TODO 订单的消费者，获取数据，获取到数据即可以将数据保存到订单表中
       */
      public class OrderConsumer {
          public static void main(String[] args) {
              //创建连接对象
              Properties props = new Properties();
              //消费者配置参数
              props.put("bootstrap.servers", "node01:9092");//连接到哪个kafka集群
              props.put("group.id", "test1");//设置消费者组
              props.put("enable.auto.commit", "true");//自动提交，offset是否会自动保存到kafka的对应的topic上
              props.put("auto.commit.interval.ms", "1000");//每1秒钟提交一次偏移量
              props.put("key.deserializer",
                      "org.apache.kafka.common.serialization.StringDeserializer");
              props.put("value.deserializer",
                      "org.apache.kafka.common.serialization.StringDeserializer");
              KafkaConsumer<String, String> kafkaConsumer = new KafkaConsumer<String, String>(props);
              //消费数据
              //订阅topic 参数是多个topic的一个集合
              kafkaConsumer.subscribe(Arrays.asList("spider-test"));
              while (true){
                  //拉去100毫秒内的数据
                  ConsumerRecords<String, String> consumerRecords = kafkaConsumer.poll(100);//拉去数据
                  for (ConsumerRecord<String, String> consumerRecord : consumerRecords) {
                      //打印数据
                      System.out.println("消费到的数据："+consumerRecord.value());
                  }
              }
          }
      }
      ```

      ​

5. kafka的原理

   1. 分片与副本机制

      ``` java
      //分片 和 副本
      一个broker会拥有两个不同的分片, 及一个分片会拥有一个副本,在其他的broker 

      ```

   2. 消息贮存与查询机制

      ``` java
      //贮存机制
      segment段 中的两个核心文件,index 和 log
      //index
      存放着序号 , 下一个segment段的index的文件名是该index中的最大数值.
      //log
      当达到1G的时候  , 新的数据会写到下一个segment段

      //查询机制
      //二分查找法
      会通过文件名的大小来比较,从而确定在那个文件,再来通过文件确定文件中消息
      ```

   3. 生产者数据分发策略

      ``` java
      //第一种 指定partition分片

      //第二种 指定key 通过key的hash值进行取模,来进行分配数据

      //第三种 轮循的方式 即既没指定partition,又没有指定key,一条数据一条数据的轮着贮存到分片中
      ```

   4. 消费者负载均衡机制

      ``` java
      //一个分片只能被一个组中的成员消费

      当每个分片都有对应的消费者,每个消费者都能够消费分片中数据,但是但多与分片的消费者,不会消费数据 只会空余出来.
        
       //所以当消费者的能力,不足以满足生产者的速度
        两个办法
        //1.提高分片的数量,从而增加消费者的数量
        //2.提高消费者的消费能力
      ```

   5. 消息不丢失机制

      1. 生产者端消息不丢失

         ``` java
         //消息生产分为两个模式:同步和异步模式  默认是同步模式  但设定缓冲区之后就是 异步模式

         //消息的确认分成三个状态
         0 消息不确认
         1 确认消息是否发送到leader上
         -1 确认消息已经发送到leader上并且已经备份

         //在同步模式下
         生产者会等待10S 当broker没有给出Ack响应,就会认为是失败
         当设置重试 , 如果没有响应,就会报错

         //在异步模式下
         先将数据保存到broker中的缓冲区
         当满足 时间阈值或空间域值中的一个,就会发送消息

         //如果broker迟迟不给Ack,而缓冲区满了以后 , 开发者可以设置是否清除缓冲区的数据
         ```

      2. broker端消息不丢失

         ``` java
         broker端的数据不丢失,是通过副本来实现的,
         因为每一个broker都有,都有两个不同的分片,每一个分片都在两个不同broker上进行贮存,所以但一台broker挂掉,数据的完整性,并不会受到影响
         ```

      3. 消费者端消息不丢失

         ``` java
         只记录offset值 , 当服务器挂掉,再次消费的时候会从记录的那个offset值开始进行消费

         //只记录offset,不会存在丢失数据的可能,只会存在数据的重复
         ```

         ​