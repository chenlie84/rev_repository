package com.itheima.kafka.consumer;

import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;

import java.util.Arrays;
import java.util.Properties;

/**
 * @CLassName OrderConsumer
 * @Description TODO  消息的消费者
 **/
public class OrderConsumer {

    public static void main(String[] args) {
        //链接kafka集群

        Properties props = new Properties();
        //消费者配置参数
        props.put("bootstrap.servers", "bigdata01:9092");//连接到哪个kafka集群
        props.put("group.id", "test");//设置消费者组
        props.put("enable.auto.commit", "true");//自动提交，offset是否会自动保存到kafka的对应的topic上
        props.put("auto.commit.interval.ms", "1000");//每1秒钟提交一次偏移量
        props.put("key.deserializer",
                "org.apache.kafka.common.serialization.StringDeserializer");
        props.put("value.deserializer",
                "org.apache.kafka.common.serialization.StringDeserializer");
        KafkaConsumer<String,String> kafkaConsumer = new KafkaConsumer<String, String>(props);
        kafkaConsumer.subscribe(Arrays.asList("order"));

        while (true) {
            ConsumerRecords<String, String> records = kafkaConsumer.poll(100);

        }

    }

}
