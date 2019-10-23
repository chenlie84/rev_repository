package com.itheima.spider.httpclient;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import java.io.IOException;

/**
 * @ClassName HttpClientGet
 * @Description TODO get请求方式  重点
 */
public class HttpClientGet {
    public static void main(String[] args) throws IOException {
        //1.确定爬取的url地址
        String indexUrl = "http://www.itcast.cn";
        //2.发送请求
        //2.1先要获取一个httpclient对象
        //CloseableHttpClient httpClient = HttpClientBuilder.create().build();
        CloseableHttpClient httpClient = HttpClients.createDefault();

        //设定请求方式
        HttpGet httpGet = new HttpGet(indexUrl);
        //设定请求头
        httpGet.setHeader("User-Agent","Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36");
        //发送请求
        CloseableHttpResponse response = httpClient.execute(httpGet);//发送请求的动作
        //获取响应数据
        int code = response.getStatusLine().getStatusCode();//响应码
        System.out.println(code);
        if(code==200){
            //请求成功
            Header[] headers = response.getHeaders("Content-Type");
            for (Header header : headers) {
                System.out.println(header.getValue());
            }
            //获取响应体
            HttpEntity entity = response.getEntity();
            String html = EntityUtils.toString(entity,"utf-8");
            System.out.println(html);
        }
        httpClient.close();
    }
}
