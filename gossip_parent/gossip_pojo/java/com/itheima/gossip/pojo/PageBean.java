package com.itheima.gossip.pojo;

import java.io.Serializable;
import java.util.List;

/**
 * @CLassName PageBean
 * @Description TODO  用来封装前端传来的分页条件 与 分页的结果
 **/
public class PageBean implements Serializable {

    //前端给后端进行分页的条件
    private Integer page = 1;     //将当前页码设置成1 以防止条件为空
    private Integer pageSize = 10; // 每页显示的条数固定成10

    //后端给前端的分页结果
    private Integer pageCount;  //分页的总记录数
    private Integer pageNum;    //总页数
    private List<News> newsList;//当前页显示的数据

    public Integer getPage() {
        return page;
    }

    public void setPage(Integer page) {
        this.page = page;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    public Integer getPageCount() {
        return pageCount;
    }

    public void setPageCount(Integer pageCount) {
        this.pageCount = pageCount;
    }

    public Integer getPageNum() {
        return pageNum;
    }

    public void setPageNum(Integer pageNum) {
        this.pageNum = pageNum;
    }

    public List<News> getNewsList() {
        return newsList;
    }

    public void setNewsList(List<News> newsList) {
        this.newsList = newsList;
    }
}
