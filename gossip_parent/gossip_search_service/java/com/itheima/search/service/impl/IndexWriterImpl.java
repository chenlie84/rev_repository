package com.itheima.search.service.impl;

import com.alibaba.dubbo.config.annotation.Service;
import com.itheima.gossip.pojo.News;
import com.itheima.search.service.IndexWriter;
import org.apache.solr.client.solrj.impl.CloudSolrServer;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

/**
 * @CLassName IndexWriterImpl
 * @Description TODO  写入的接口的实现类
 **/
//因为这个工程是一个服务的提供者 所以需要将方法 发布到注册中心  所以使用的是dubbo的service 注解
@Service(timeout = 50000)
public class IndexWriterImpl implements IndexWriter {

    @Autowired
    private CloudSolrServer cloudSolrServer;

    @Override
    public void saveNewsList(List<News> newsList) throws Exception {
        //添加数据
        cloudSolrServer.addBeans(newsList);
        cloudSolrServer.commit();
    }
}
