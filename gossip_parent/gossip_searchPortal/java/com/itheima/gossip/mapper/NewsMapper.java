package com.itheima.gossip.mapper;

import com.itheima.gossip.pojo.News;

import java.util.List;

/**
 * @CLassName NewsMapper
 * @Description TODO  数据库接口
 **/

public interface NewsMapper {

    //通过以前保存的Maxid 查询news新闻数据
    public List<News> queryNewsListByMaxId(String maxId) throws Exception;

    //通过之前的maxid查询以后的maxid
    public String queryMaxIdByMaxId(String maxId) throws Exception;
}
