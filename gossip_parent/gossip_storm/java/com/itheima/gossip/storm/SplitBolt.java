package com.itheima.gossip.storm;

import org.apache.storm.topology.BasicOutputCollector;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseBasicBolt;
import org.apache.storm.tuple.Fields;
import org.apache.storm.tuple.Tuple;
import org.apache.storm.tuple.Values;

/**
 * @CLassName SplitBolt
 * @Description TODO  kafkaSpout这个类中获取数据, 这个类是storm提供好的  处理从上传递过来的数据
 **/
public class SplitBolt extends BaseBasicBolt {

    @Override
    public void execute(Tuple input, BasicOutputCollector collector) {
        //要获取tuple中的数据 , 就要对其结构清晰
        String line = input.getString(4);
        System.out.println(line);
        // 获取到的数据是这个样子的Safari/537.36#CS#2019-06-26T17:59:55+08:00#CS#192.168.70.15#CS##CS#志玲结婚
        //判断如果包含就往下执行
        if (line.contains("#CS#")) {
            //查找其最后一次出现的索引
            int index = line.lastIndexOf("#CS#");
            //根据索引进行切割 加4 是因为根据切割会在这个字符的最开始切割,会包括这个字符
            //获取志玲结婚这个关键词
            String keywords = line.substring(index + 4);

            //提交, values 底层就是一个arrayList
            collector.emit(new Values(keywords));

        }

    }

    @Override
    public void declareOutputFields(OutputFieldsDeclarer declarer) {
        //定义字段
        declarer.declare(new Fields("keywords"));
    }
}
