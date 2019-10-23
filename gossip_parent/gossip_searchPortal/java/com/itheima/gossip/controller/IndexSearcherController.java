package com.itheima.gossip.controller;

import com.itheima.gossip.pojo.News;
import com.itheima.gossip.pojo.PageBean;
import com.itheima.gossip.pojo.ResultBean;
import com.itheima.gossip.service.IndexSearcherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.List;

/**
 * @CLassName IndexSearcherController
 * @Description TODO  搜索的web层
 **/
@RestController
public class IndexSearcherController {

    @Autowired
    private IndexSearcherService indexSearcherService;

    @RequestMapping("/s")
    public List<News> findByKeywords(String keywords) {

        try {
            //判断 keywords 有可能没有值 就传递了请求 所以进行判断
            if (StringUtils.isEmpty(keywords)) {
                //没有数据,跳转到首页
                //keywords = "*:*";
                return null;
            }

            //web层的异常 , 就不能向上抛了
            List<News> newsList = indexSearcherService.findByKeywords(keywords);
            return newsList;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @RequestMapping("/ps")
    public ResultBean findByQuery(ResultBean resultBean) {

        //判断resultbean 不为null
        if (resultBean == null) {
            return null;
        }
        //判断keywords不为null
        if (StringUtils.isEmpty(resultBean.getKeywords())) {
            return null;
        }

        //lua中为了保证不乱码,多keywords进行了编码,所以用其传递过来的keywords进行查询的时候,必须对其进行解码
        try {
            String keywords = URLDecoder.decode(resultBean.getKeywords(), "UTF-8");
            System.out.println("keywords" + keywords);
            resultBean.setKeywords(keywords);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        //判断pagebean不为null
        //前端中没有分页的条件也就不会有 pagebean对象  , 如果没有pagebean对象 需要先进行创建
        if (resultBean.getPageBean() == null) {
            PageBean pageBean = new PageBean();
            resultBean.setPageBean(pageBean);
        }

        try {
            return indexSearcherService.findByQuery(resultBean);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

    }

}
