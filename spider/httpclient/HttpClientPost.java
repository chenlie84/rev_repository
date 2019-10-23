package com.itheima.spider.httpclient;

import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * @ClassName HttpClientPost
 * @Description TODO post请求
 */
public class HttpClientPost {
    public static void main(String[] args) throws Exception {
        //1.确定爬取的url地址
        String indexUrl = "http://www.itcast.cn";

        //2.发送请求
        //2.1获取httpclient对象
        CloseableHttpClient httpClient = HttpClients.createDefault();
        //设置请求方式
        HttpPost httpPost = new HttpPost(indexUrl);
        //设置请求头
        httpPost.setHeader("User-Agent","Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36");
        //设置请求体
        List<NameValuePair> list = new ArrayList<>();
        NameValuePair nameValuePair1 = new BasicNameValuePair("username","zhangsan");
        NameValuePair nameValuePair2 = new BasicNameValuePair("age","18");
        NameValuePair nameValuePair3 = new BasicNameValuePair("sex","男");
        list.add(nameValuePair1);
        list.add(nameValuePair2);
        list.add(nameValuePair3);
        UrlEncodedFormEntity entity = new UrlEncodedFormEntity(list,"utf-8");
        httpPost.setEntity(entity);
        //2.2发送请求
        CloseableHttpResponse response = httpClient.execute(httpPost);
        int code = response.getStatusLine().getStatusCode();
        if (code == 200) {
            //发送正常可以获取数据
            String html = EntityUtils.toString(response.getEntity(), "utf-8");
            System.out.println(html);
        }
        httpClient.close();
    }
}
