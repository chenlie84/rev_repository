# 6月17号 笔记  搜索项目的建立

## 1.回顾

1. pojo工程的建立

   1. news 实体类

2. searcher接口的建立

   1. 为服务的消费者和提供者提供接口 以便服务的调用

   2. IndexWriter接口   包名 com.itheima.search.service

      ``` java
      public viod saveNewsList(list<News> newsList) throws exception;
      ```

3. searcher_service  war工程的建立

   1. 搜索服务的  业务层  实现服务的接口

   2. IndexWriterImpl实现类

      ``` java
      @Service  //dubbo 
      public class IndexWriterImpl implements IndexWriter {
        
        @Autowired
        private CloudSolrServer cloudSolrServer;
        
        @Override
        public void saveNewsList() throws Exception {
        	  //调用solr的增加的方法,将从数据库获取的数据保存到solr索引库中,建立索引
             //以便搜索服务的查询功能的使用
          
        }
        
      }
      ```


4. searcherPortal    war工程的建立

   1. 搜索服务的  web层   调用服务的接口
   2. IndexWriterService
   3. IndexWriterServiceImpl


## 2.json格式的转换   百度一下

``` java
JSON 语法规则
JSON 语法是 JavaScript 对象表示语法的子集。

数据在名称/值对中
数据由逗号分隔


//大括号保存对象
//中括号保存数组
```



