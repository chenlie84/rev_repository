package com.itheima.gossip.service.impl;

import com.alibaba.dubbo.config.annotation.Reference;
import com.itheima.gossip.pojo.News;
import com.itheima.gossip.pojo.ResultBean;
import com.itheima.gossip.service.IndexSearcherService;
import com.itheima.search.service.IndexSearcher;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * @CLassName IndexSearcherServiceImpl
 * @Description TODO  实现搜索服务的实现类
 **/
@Service  //服务的消费者
public class IndexSearcherServiceImpl implements IndexSearcherService{

    @Reference(timeout = 50000)  //远程注入
    private IndexSearcher indexSearcher;


    @Override
    public List<News> findByKeywords(String keywords) throws Exception {
        List<News> newsList = indexSearcher.findByKeywords(keywords);

        //这里有一段代码,要解决时间不同步的问题

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        for (News news : newsList) {
            String time = news.getTime();
            Date date = format.parse(time);
            date.setTime(date.getTime()-(1000*60*60*8));
            time = format.format(date);
            news.setTime(time);

            //切割数据
            String content = news.getContent();
            //只有内容没有被高亮的才切割,并且在前一百个字
            if (!content.contains("<font color='red'>") && content.length() > 117) {
                content = content.substring(0, 107) + "....";
            }

            news.setContent(content);
        }


        return newsList;
    }

    @Override
    public ResultBean findByQuery(ResultBean resultBean) throws Exception {
        //调用查询服务
        resultBean = indexSearcher.findByQuery(resultBean);

        List<News> newsList = resultBean.getPageBean().getNewsList();
        for (News news : newsList) {
            //切割数据
            String content = news.getContent();
            //只有内容没有被高亮的才切割,并且在前一百个字
            if (!content.contains("<font color='red'>") && content.length() > 117) {
                content = content.substring(0, 107) + "....";
            }

            news.setContent(content);
        }

        return resultBean;
    }
}
