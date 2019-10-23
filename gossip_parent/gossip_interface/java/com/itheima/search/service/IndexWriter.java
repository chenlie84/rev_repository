package com.itheima.search.service;

import com.itheima.gossip.pojo.News;

import java.util.List;

public interface IndexWriter {

    //编写保存数据的接口
    public void saveNewsList(List<News> newsList) throws Exception;
}
