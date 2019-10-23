package com.itheima.gossip.service.impl;

import com.alibaba.dubbo.config.annotation.Reference;
import com.itheima.gossip.mapper.NewsMapper;
import com.itheima.gossip.pojo.News;
import com.itheima.gossip.service.IndexWriterService;
import com.itheima.search.service.IndexWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * @CLassName IndexWriterServiceImpl
 * @Description TODO
 **/
//因为这个是服务的消费者  , 所以其方法不用发布到注册中心  而是从注册那拿方法,所以不用使用dubbo的注解
@Service
public class IndexWriterServiceImpl implements IndexWriterService {

    //注入数据层实现类
    @Autowired
    private NewsMapper newsMapper;

    //注入本地的jedis实现类,用与获取保存的最大值
    @Autowired
    private JedisPool jedisPool;

    //远程注入  写入solr的接口  将数据保存到solr
    @Reference(timeout = 50000)
    private IndexWriter indexWriter;

    @Override
    public void indexWriter() throws Exception {

        //调用dao 获取数据   在调用方法将数据把保存到solr中

        //从redis中获取以前保存的maxid
        Jedis jedis = jedisPool.getResource();
        String maxid = jedis.get("bigdata:gossip:maxid");
        jedis.close();
        //因为一次并不能将所有的数据都进行保存 , 所以是进行分批次的存贮
        //maxid会有为空的时候
        if (StringUtils.isEmpty(maxid)) {
            //如果为空,如第一次  , 就将其赋值为0,所以第一次就是查询所有的数据
            maxid = 0 + "";
        }

        while (true) {
            //获取到数据库的新闻数据
            List<News> newsList = newsMapper.queryNewsListByMaxId(maxid);

            System.out.println("新闻的数量" +  newsList.size());

            //如果list 返回的是口 相当于查不到数据了,就将maxid  保存到redis中
            if (newsList == null || newsList.size() <= 0) {
                jedis = jedisPool.getResource();
                jedis.set("bigdata:gossip:maxid", maxid);
                jedis.close();
                //然后跳出循环
                break;

            }
            //单纯的数据库的数据保存到solr中要考虑其之间的数据类型的的转换问题
            //这之间就有时间格式的转换  solr的格式是: 2019-06-15T19:38:30Z 所以就要考虑之间的转换  以便出现异常
            SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
            for (News news : newsList) {
                String time = news.getTime();
                //将字符串转换成 date的日期格式
                Date date = format1.parse(time);
                //在将日期格式转成solr格式的字符串
                String time_new = format2.format(date);
                //再将转好的格式重新赋值
                news.setTime(time_new);
            }

            //将数据保存到solr中
            indexWriter.saveNewsList(newsList);

            //更新maxid
            maxid = newsMapper.queryMaxIdByMaxId(maxid);

        }

    }
}
