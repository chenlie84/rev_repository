package com.itheima.cache.service.impl;

import com.alibaba.dubbo.config.annotation.Reference;
import com.alibaba.fastjson.JSON;
import com.itheima.cache.service.NewsCacheService;
import com.itheima.gossip.pojo.PageBean;
import com.itheima.gossip.pojo.ResultBean;
import com.itheima.search.service.IndexSearcher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

/**
 * @CLassName NewsCacheServiceImpl
 * @Description TODO  缓存服务的接口,具体实现通过热词从solr中获取数据,再将获取的数据缓存到redis中
 **/
@Service  //这是服务的消费者 不需要发布服务, 所以使用的是spring的注解
public class NewsCacheServiceImpl implements NewsCacheService {

    @Autowired
    private JedisPool jedisPool;

    //这次就是远程注入 , 将索引查询的服务,用过注入的方式,来调用其方法
    @Reference
    private IndexSearcher indexSearcher;

    @Override
    public void cacheNews(String keywords) throws Exception {
        //通过keywords获取数据
        ResultBean resultBean = new ResultBean();  //使用resultbean是为后来的分页
        resultBean.setKeywords(keywords);

        //这样的步骤,获得pageBean是一个null , 为了避免空指针异常,手动创建pageBean对象
        PageBean pageBean = new PageBean();
        resultBean.setPageBean(pageBean);

        //将其返回的数据重新赋值到resultbean上
        //查询的数据是第一页,第一页的目的主要是为了获取总页数
        resultBean = indexSearcher.findByQuery(resultBean);

        //总页数 , 通过总页数获取其页数的长度一次来判断
        Integer pageNum = resultBean.getPageBean().getPageNum();

        //每次查询的数据都将其前五页进行缓存 , 过多的缓存我们不需要所以要进行判断
        if (pageNum > 0) {
            //当pageNum大于0的时候再来判断,让其大于5,我们才进行缓存
            if (pageNum > 5) {
                //只缓存 5 页
                pageNum = 5;
            }

            //用循环来获取每一页的数据  i的变动 就是当前页在进行变动
            for (int i = 1 ; i <= pageNum;i++) {
                //设置变动的页数
                resultBean.getPageBean().setPage(i);
                resultBean = indexSearcher.findByQuery(resultBean);

                //key就是  keywords:I  用于区别每一页的数据  , value就是resultBean的json格式
                String resultBeanJson = JSON.toJSONString(resultBean);

                //将返回的数据保存到redis中
                Jedis jedis = jedisPool.getResource();
                jedis.set(keywords + ":" + i, resultBeanJson);
                //关闭jedis
                jedis.close();

            }


        }





    }
}
