package com.itheima.cache.service.listener;

import com.alibaba.fastjson.JSON;
import com.itheima.cache.service.NewsCacheService;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.listener.MessageListener;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * @CLassName KeywordsConsumer
 * @Description TODO  自定义监听类
 **/
@Component
public class KeywordsConsumer implements MessageListener<String,String> {

    @Autowired
    private NewsCacheService newsCacheService;

    @Override
    public void onMessage(ConsumerRecord<String, String> data) {

        try {
            // 消费到的排行榜是数组格式
            String topKeywords = data.value();   //返回的数据是一个json格式  并非直接就是一个keywords
            List<Map> mapList = JSON.parseArray(topKeywords, Map.class);
            //遍历获取,keywords
            for (Map map : mapList) {
                String keywords = (String) map.get("topKeywords");
                newsCacheService.cacheNews(keywords);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
