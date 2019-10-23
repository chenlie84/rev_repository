package com.itheima.search.service;

import com.itheima.gossip.pojo.News;
import com.itheima.gossip.pojo.ResultBean;

import java.util.List;

//搜索的接口
public interface IndexSearcher {

    //通过关键字搜索
    public List<News> findByKeywords(String keywords) throws Exception;

    //以ResultBean对象 为条件进行数据的查询  , 最后的获取的数据封装进 resultBean中
    public ResultBean findByQuery(ResultBean resultBean) throws Exception;

}
