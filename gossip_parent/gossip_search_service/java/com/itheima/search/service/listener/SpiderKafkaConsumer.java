package com.itheima.search.service.listener;

import com.alibaba.dubbo.common.json.JSON;
import com.itheima.gossip.pojo.News;
import com.itheima.search.service.IndexWriter;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.listener.MessageListener;
import org.springframework.stereotype.Component;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;

/**
 * @CLassName SpiderKafkaConsumer
 * @Description TODO  自定义监听类
 **/
@Component  //扫描注解
public class SpiderKafkaConsumer implements MessageListener<String,String>{

    //注入 索引写入服务
    @Autowired
    private IndexWriter indexWriter;

    @Override
    public void onMessage(ConsumerRecord<String, String> data) {
        try {
            //直接获取到,kafka中的发送来的数据
            String newsjson = data.value();
            //将json字符串转换成 news对象
            News news = JSON.parse(newsjson, News.class);

            System.out.println(news);

            //封装成的news对象中数据类型有的不一致,要进行改变
            SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
            Date date_old = format1.parse(news.getTime());
            String time = format2.format(date_old);
            //将转换好的格式进行封装
            news.setTime(time);

            //调用写入索引的服务
            indexWriter.saveNewsList(Arrays.asList(news));

        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
