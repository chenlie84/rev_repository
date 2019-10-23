package com.itheima.gossip.storm;

import com.alibaba.fastjson.JSON;
import com.itheima.gossip.pojo.TopKey;
import com.itheima.gossip.util.JedisUtils;
import org.apache.storm.topology.BasicOutputCollector;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseBasicBolt;
import org.apache.storm.tuple.Fields;
import org.apache.storm.tuple.Tuple;
import org.apache.storm.tuple.Values;
import redis.clients.jedis.Jedis;

import java.util.Set;

/**
 * @CLassName WordCountBolt
 * @Description TODO  获取Splitbolt中的数据 , 进行统计次数  //将数据存到redis中的版本
 **/

@SuppressWarnings("all")
public class WordCountBoltWithRedis extends BaseBasicBolt {



    @Override
    public void execute(Tuple input, BasicOutputCollector collector) {
        //获取关键词
        String keywords = input.getStringByField("keywords");
        //创建map 编写统计次数的逻辑 , 根据Key获取value也就是统计的次数
        Jedis jedis = JedisUtils.getConn();
        Double count = jedis.zscore("bigdata:gossip:topkey", keywords);

        if(count == null) {
            //判断如果是第一次获取就说明count为null,则将其value保存为一
            jedis.zadd("bigdata:gossip:topkey",1,keywords);
        }else {
            //如果不是就加一
            jedis.zadd("bigdata:gossip:topkey",count+1,keywords);
        }

      /*  //每过三秒, 传递到kafka中
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }*/

        TopKey topKey = new TopKey();

        //再从redis中获取前10的数据,传递到kafkaBolt中
        Set<redis.clients.jedis.Tuple> tuples = jedis.zrevrangeWithScores("bigdata:gossip:topkey", 0, 9);
        for (redis.clients.jedis.Tuple tuple : tuples) {
            String element = tuple.getElement(); //关键字
            double score = tuple.getScore();     //点击量
            topKey.setKeyword(element);
            topKey.setScore(score);
            System.out.println(element + " ..... " + score);
        }

        String jsonString = JSON.toJSONString(topKey);
        collector.emit(new Values(jsonString));

        jedis.close();
    }

    //下游是kafkaBolt
    @Override
    public void declareOutputFields(OutputFieldsDeclarer declarer) {
        //注意：必须叫message 是下游kafkaBolt要求的

       declarer.declare(new Fields("message"));

    }
}
