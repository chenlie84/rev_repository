package com.itheima.gossip.storm;

import com.alibaba.fastjson.JSON;
import org.apache.storm.topology.BasicOutputCollector;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseBasicBolt;
import org.apache.storm.tuple.Fields;
import org.apache.storm.tuple.Tuple;
import org.apache.storm.tuple.Values;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @CLassName WordCountBolt
 * @Description TODO  获取Splitbolt中的数据 , 进行统计次数
 **/
public class WordCountBolt extends BaseBasicBolt {
    private Map<String,Integer> map = new HashMap<>();



    @Override
    public void execute(Tuple input, BasicOutputCollector collector) {
        //获取关键词
        String keywords = input.getStringByField("keywords");
        //创建map 编写统计次数的逻辑 , 根据Key获取value也就是统计的次数
        Integer count = map.get(keywords);
        if(count == null) {
            //判断如果是第一次获取就说明count为null,则将其value保存为一
            map.put(keywords,1);
        }else {
            //如果不是就加一
            map.put(keywords,count+1);
        }

        //因为下游的kafkaBolt是不会进行数据的处理,所以在本层就要将数据处理成最终形态,
        //以便下游向kafka发送数据 , 发送的数据的格式是[{"topKeywords":"志玲","score":99}]
        //所以定义一个map封装数据

        //遍历数据,存放是key和value
        //最后要将Map存到list中,形成我们所要的格式
        //这种封装到map中有很大的问题,会不断的创建对象在堆内存,对内存压力压力造成很大的压力
        List<Map> mapList = new ArrayList<>();

        for (String key : map.keySet()) {
            Map<String,Object> map2 = new HashMap<>();
            Integer score = map.get(key);
            //设置关键词 与 热词统计分数
            //问题的临时解决: 对score设置一个值到达到这个值才可以存
            if (score > 3) {
                map2.put("topKeywords",key);
                map2.put("score",score);
                mapList.add(map2);
            }
        }
        //因为Kafka需要json这种数据所以要将得到的Maplist转换成json格式
        String jsonString = JSON.toJSONString(mapList);
        System.out.println("json打印:" + jsonString);
        //提交到KafkaBolt
        collector.emit(new Values(jsonString));

    }

    //下游是kafkaBolt
    @Override
    public void declareOutputFields(OutputFieldsDeclarer declarer) {
        //注意：必须叫message 是下游kafkaBolt要求的
       declarer.declare(new Fields("message"));

    }
}
