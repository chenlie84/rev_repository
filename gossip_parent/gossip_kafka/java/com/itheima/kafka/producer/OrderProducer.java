package com.itheima.kafka.producer;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;

import java.util.Properties;

/**
 * @CLassName OrderProducer
 * @Description TODO   消息的生产者
 **/
public class OrderProducer {

    public static void main(String[] args) throws InterruptedException {
      /*
      链接Kafka集群
       */
        //配置链接kafka 的信息
        Properties props = new Properties();
        //配置集群参数--不需要记，但是要理解
        props.put("bootstrap.servers", "bigdata01:9092");
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

        for (int i = 0;i <= 1000 ; i++) {
            ProducerRecord<String, String> record = new ProducerRecord<String, String>("order","Hello World");
            kafkaProducer.send(record);
            kafkaProducer.flush();  //刷新缓存

        }





    }


}
