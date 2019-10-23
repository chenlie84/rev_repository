package com.itheima.gossip.pojo;

import java.io.Serializable;

/**
 * @CLassName ResultBean
 * @Description TODO  用来封装查询条件和返回数据的对象
 **/
public class ResultBean implements Serializable {
    private String keywords;
    private String startTime;
    private String endTime;
    private String editor;
    private String source;
    //分页的条件与结果
    private PageBean pageBean;

    public String getKeywords() {
        return keywords;
    }

    public void setKeywords(String keywords) {
        this.keywords = keywords;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getEditor() {
        return editor;
    }

    public void setEditor(String editor) {
        this.editor = editor;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public PageBean getPageBean() {
        return pageBean;
    }

    public void setPageBean(PageBean pageBean) {
        this.pageBean = pageBean;
    }
}
