package com.itheima.gossip.service;

import com.itheima.gossip.pojo.News;
import com.itheima.gossip.pojo.ResultBean;

import java.util.List;

//调用 搜索的服务
public interface IndexSearcherService {

    public List<News> findByKeywords(String keywords) throws Exception;

    public ResultBean findByQuery(ResultBean resultBean) throws Exception;
}
