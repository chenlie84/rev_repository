package com.itheima.cache.service;

/*
    热词消费的接口,从消息队列中获取数据  , 没有返回值
 */
public interface NewsCacheService {

    //根据消费到的热词进行查询，将查询结果中的热点新闻缓存到redis

    public void cacheNews(String keywords) throws Exception;

}
