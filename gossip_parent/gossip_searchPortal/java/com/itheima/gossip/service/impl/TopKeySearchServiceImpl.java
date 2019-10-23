package com.itheima.gossip.service.impl;

import com.itheima.gossip.service.TopKeySearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.Tuple;

import java.util.*;

/**
 * @CLassName TopKeySearchServiceImpl
 * @Description TODO
 **/
@Service
public class TopKeySearchServiceImpl implements TopKeySearchService {

    //操作redis
    @Autowired
    private JedisPool jedisPool;

    @Override
    public List<Map<String, Object>> topKeyByNum(Integer num) throws Exception {
        //获取redis中存在的数据
        Jedis jedis = jedisPool.getResource();

        //2.执行查询
        Set<Tuple> set = jedis.zrevrangeWithScores("bigdata:gossip:topkey", 0, num);

        //3.处理数据
        //set中包含了热词  与  得分
        List<Map<String,Object>> mapList = new ArrayList<>();

        for (Tuple tuple : set) {
            String topkey = tuple.getElement();  //热词
            double score = tuple.getScore();     //点击量

            //返回listMap所以要将数据保存在  , 先将数据存放到map之中, 再见map存放到 list中 封装数据
            Map<String,Object> map = new HashMap<>();
            map.put("topkey",topkey);
            map.put("score",score);

            mapList.add(map);
        }

        //System.out.println(mapList);

        //4.释放资源
        jedis.close();

        return mapList;
    }
}
