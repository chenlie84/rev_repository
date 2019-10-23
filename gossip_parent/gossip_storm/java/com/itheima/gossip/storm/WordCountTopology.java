package com.itheima.gossip.storm;

import org.apache.storm.Config;
import org.apache.storm.LocalCluster;
import org.apache.storm.kafka.bolt.KafkaBolt;
import org.apache.storm.kafka.bolt.mapper.FieldNameBasedTupleToKafkaMapper;
import org.apache.storm.kafka.bolt.selector.DefaultTopicSelector;
import org.apache.storm.kafka.spout.KafkaSpout;
import org.apache.storm.kafka.spout.KafkaSpoutConfig;
import org.apache.storm.topology.TopologyBuilder;

import java.util.Properties;

/**
 * @CLassName WordCountTopology
 * @Description TODO 将所有的spout和bolt联系起来
 **/
public class WordCountTopology {

    public static void main(String[] args) {
        //构建topology对象
        TopologyBuilder topologyBuilder = new TopologyBuilder();
        //设置spout和Bolt


        //tp.setSpout("kafka_spout", new KafkaSpout<>(KafkaSpoutConfig.builder("127.0.0.1:" + port, "topic").build()), 1);
        KafkaSpoutConfig.Builder<String, String> builder = KafkaSpoutConfig.builder("bigdata01:9092", "logs");
        builder.setGroupId("hello_storm");

        //设置从到最新的地方开始消费
        builder.setFirstPollOffsetStrategy(KafkaSpoutConfig.FirstPollOffsetStrategy.LATEST);
        //消费者
        topologyBuilder.setSpout("kafkaSpout", new KafkaSpout<>(builder.build()));  //这个给定的类要进行配置

        topologyBuilder.setBolt("splitBolt",new SplitBolt()).shuffleGrouping("kafkaSpout");

        topologyBuilder.setBolt("wordCountBoltWithRedis",new WordCountBoltWithRedis()).shuffleGrouping("splitBolt");

        //set producer properties.
        Properties props = new Properties();
        props.put("bootstrap.servers", "bigdata01:9092");
        props.put("acks", "all");
        props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

        //发送到指定的topic
        KafkaBolt kafkaBolt = new KafkaBolt()
                .withProducerProperties(props)
                .withTopicSelector(new DefaultTopicSelector("keywords"))
                .withTupleToKafkaMapper(new FieldNameBasedTupleToKafkaMapper());
        topologyBuilder.setBolt("kafkaBolt", kafkaBolt).shuffleGrouping("wordCountBoltWithRedis");

        //本地提交
        LocalCluster localCluster = new LocalCluster();
        Config conf = new Config(); //依然使用默认的配置
        localCluster.submitTopology("wordCount",conf,topologyBuilder.createTopology());
    }

}
