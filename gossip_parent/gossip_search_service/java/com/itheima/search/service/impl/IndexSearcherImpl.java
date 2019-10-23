package com.itheima.search.service.impl;

import com.alibaba.dubbo.config.annotation.Service;
import com.itheima.gossip.pojo.News;
import com.itheima.gossip.pojo.ResultBean;
import com.itheima.search.service.IndexSearcher;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.impl.CloudSolrServer;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @CLassName IndexSearcherImpl
 * @Description TODO  搜索接口的实现类
 **/
@Service
@SuppressWarnings("all")
public class IndexSearcherImpl implements IndexSearcher {

    @Autowired
    private CloudSolrServer cloudSolrServer;

    @Override
    public List<News> findByKeywords(String keywords) throws Exception {

        //设置查询的条件
        SolrQuery solrQuery = new SolrQuery("text:" + keywords);

        //高亮的设置
        solrQuery.setHighlight(true);    //开启高亮
        solrQuery.addHighlightField("title");   //添加高亮的字段
        solrQuery.addHighlightField("content");
        solrQuery.setHighlightSimplePre("<font color='red'>");  //设置高亮的字段的颜色属性
        solrQuery.setHighlightSimplePost("</font>");
        //不用设置切片

        QueryResponse response = cloudSolrServer.query(solrQuery);

        //获取高亮的数据
        Map<String, Map<String, List<String>>> highlighting = response.getHighlighting();

        //获取未被高亮的数据
        //获取到的对象结合会存在类型转换的问题  , 从solr中获取的时间对象  会转换成  string 会报错
        //List<News> newsList = response.getBeans(News.class); 所以不行
        //所以进行手动转换
        SolrDocumentList documents = response.getResults();
        System.out.println("查询的总记录数:" + documents.getNumFound());
        //设置时间格式
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        //创建一个空的集合来贮存news对象
        List<News> newsList = new ArrayList<>();

        for (SolrDocument document : documents) {
            String id = (String) document.get("id");
            String title = (String) document.get("title");
            String content = (String) document.get("content");
            Date time = (Date) document.get("time");
            //转成java需要的格式
            String time_new = format.format(time);
            String source = (String) document.get("source");

            System.out.println(source);
            String editor = (String) document.get("editor");
            String docurl = (String) document.get("docurl");

            //通过id获取高亮的部分
            Map<String, List<String>> stringListMap = highlighting.get(id);
            //获取title部分的高亮数据
            List<String> titleList = stringListMap.get("title");
            //判断是否有数据
            if (titleList != null && titleList.size() > 0) {
                //当有数据被高亮的时候,才会被赋值
                title = titleList.get(0);
            }
            //获取content高亮的部分
            List<String> contentList = stringListMap.get("content");
            //判断是否有数据
            if (contentList != null && contentList.size() > 0) {
                //当有数据被高亮的时候,才会被赋值
                content = contentList.get(0);
            }

            //封装成News对象
            News news = new News();
            news.setId(id);
            news.setTitle(title);
            news.setContent(content);
            news.setSource(source);
            news.setTime(time_new);
            news.setDocurl(docurl);
            news.setEditor(editor);

            //转到集合
            newsList.add(news);
        }

        //将封装后的数据进行返回
        return newsList;
    }

    //通过传递过来的resultBean 进行过滤查询
    @Override
    public ResultBean findByQuery(ResultBean resultBean) throws Exception {

        //查询
        SolrQuery solrQuery = new SolrQuery("text:" + resultBean.getKeywords());

        //设置高亮
        solrQuery.setHighlight(true);    //开启高亮
        solrQuery.addHighlightField("title");   //添加高亮的字段
        solrQuery.addHighlightField("content");
        solrQuery.setHighlightSimplePre("<font color='red'>");  //设置高亮的字段的颜色属性
        solrQuery.setHighlightSimplePost("</font>");

        //进行过滤查询
        //先判断  时间是否 不为空
        //时间的转换 06/04/2019 20:27:31
        SimpleDateFormat format1 = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
        SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
        String startTime = resultBean.getStartTime();
        String endTime = resultBean.getEndTime();
        if (!StringUtils.isEmpty(startTime) && !StringUtils.isEmpty(endTime)) {
            //当不为空的时候, 有过滤条件,才能进行查询 转成solr的时间格式才能查询
            Date start = format1.parse(startTime);
            startTime = format2.format(start);

            Date end = format1.parse(endTime);
            endTime = format2.format(end);

            solrQuery.addFilterQuery("time:[ " + startTime + " TO " + endTime + " ]");

        }

        if (!StringUtils.isEmpty(resultBean.getEditor())) {
            solrQuery.addFilterQuery("editor:" + resultBean.getEditor());
        }

        if (!StringUtils.isEmpty(resultBean.getSource())) {
            solrQuery.addFilterQuery("source:" + resultBean.getSource());
        }

        //分页查询
        //获取前端传递过来的分页条件
        Integer page = resultBean.getPageBean().getPage();        //当前页
        Integer pageSize = resultBean.getPageBean().getPageSize();//每页的条数
        //对数据进行判断  , 前端传递的数据 有可能为null
        if (page == null) {
            //为其添加默认值
            page = 1;
        }
        if (pageSize == null) {
            pageSize = 10;
        }
        //进行分页查询  起始页码 需要进行计算
        solrQuery.setStart((page - 1)*pageSize);  //设置查询的起始页码
        solrQuery.setRows(pageSize);              //设置查询的条数

        solrQuery.setSort("time", SolrQuery.ORDER.desc);


        //查询条件之后之后在高亮
        QueryResponse response = cloudSolrServer.query(solrQuery);
        //获取高亮的数据
        Map<String, Map<String, List<String>>> highlighting = response.getHighlighting();

        //获取未被高亮的数据
        SolrDocumentList documents = response.getResults();

        System.out.println("总记录数: " + documents.getNumFound());
        //创建一个空集合
        List<News> newsList = new ArrayList<>();
        //设立时间格式
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        //遍历dom对象
        for (SolrDocument document : documents) {
            String id = (String) document.get("id");
            String title = (String) document.get("title");
            String content = (String) document.get("content");
            Date time = (Date) document.get("time");
            //转成java需要的格式
            String time_new = format.format(time);
            String source = (String) document.get("source");

            System.out.println(source);
            String editor = (String) document.get("editor");
            String docurl = (String) document.get("docurl");

            //通过id获取高亮的部分
            Map<String, List<String>> stringListMap = highlighting.get(id);
            //获取title部分的高亮数据
            List<String> titleList = stringListMap.get("title");
            //判断是否有数据
            if (titleList != null && titleList.size() > 0) {
                //当有数据被高亮的时候,才会被赋值
                title = titleList.get(0);
            }
            //获取content高亮的部分
            List<String> contentList = stringListMap.get("content");
            //判断是否有数据
            if (contentList != null && contentList.size() > 0) {
                //当有数据被高亮的时候,才会被赋值
                content = contentList.get(0);
            }

            //封装成News对象
            News news = new News();
            news.setId(id);
            news.setTitle(title);
            news.setContent(content);
            news.setSource(source);
            news.setTime(time_new);
            news.setDocurl(docurl);
            news.setEditor(editor);

            //转到集合
            newsList.add(news);
        }

        //当pagabean不为null的时候 才可以封装数据
        long numFound = documents.getNumFound();
        resultBean.getPageBean().setPageCount((int)numFound);
        resultBean.getPageBean().setNewsList(newsList);

        //封装数据  获取总页数
        double pageNum = Math.ceil((double) numFound / pageSize);//101/10  = 10.1   ceil(10.1) = 11.0 向上取整
        resultBean.getPageBean().setPageNum((int) pageNum);

        return resultBean;
    }
}
