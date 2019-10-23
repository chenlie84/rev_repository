package com.itheima.spider.login;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;

import java.util.ArrayList;
import java.util.List;

/**
 * @ClassName Mmm
 * @Description TODO
 */
public class Mmm {
    public static void main(String[] args) throws Exception {
        //1.确定url
        String indexUrl = "http://home.manmanbuy.com/login.aspx";

        //创建httpclient对象
        CloseableHttpClient httpClient = HttpClients.createDefault();
        //设置请求方式 post  url
        HttpPost httpPost = new HttpPost(indexUrl);
        //请求头
        httpPost.setHeader("User-Agent","Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36");
        httpPost.setHeader("Referer","http://home.manmanbuy.com/login.aspx");
        httpPost.setHeader("Content-Type","application/x-www-form-urlencoded");
        //请求体
        List<NameValuePair> list = new ArrayList<>();
        list.add(new BasicNameValuePair("txtUser", "itcast"));
        list.add(new BasicNameValuePair("txtPass", "www.itcast.cn"));
        list.add(new BasicNameValuePair("__EVENTVALIDATION", "/wEWBQLW+t7HAwLB2tiHDgLKw6LdBQKWuuO2AgKC3IeGDJ4BlQgowBQGYQvtxzS54yrOdnbC"));
        list.add(new BasicNameValuePair("__VIEWSTATE", "/wEPDwULLTIwNjQ3Mzk2NDFkGAEFHl9fQ29udHJvbHNSZXF1aXJlUG9zdEJhY2tLZXlfXxYBBQlhdXRvTG9naW4voj01ABewCkGpFHsMsZvOn9mEZg=="));
        list.add(new BasicNameValuePair("autoLogin", "on"));
        list.add(new BasicNameValuePair("btnLogin", "登陆"));

        HttpEntity entity = new UrlEncodedFormEntity(list,"UTF-8");
        httpPost.setEntity(entity);

        //发送请求 获取响应
        CloseableHttpResponse response = httpClient.execute(httpPost);
        int code = response.getStatusLine().getStatusCode();
        if (code == 302) {
            Header[] headers = response.getHeaders("Location");
            Header[] cookies = response.getHeaders("Set-Cookie");
            String href = "http://home.manmanbuy.com"+headers[0].getValue();
            System.out.println(href);
            //第二次发送请求
            httpClient = HttpClients.createDefault();
            HttpGet httpGet = new HttpGet(href);
            System.out.println(cookies[0].getValue()+" "+cookies[1].getValue());
            //设置请求头
            httpGet.setHeader("Cookie",cookies[0].getValue()+" "+cookies[1].getValue());

            CloseableHttpResponse response1 = httpClient.execute(httpGet);
            int code1 = response1.getStatusLine().getStatusCode();
            if (code1 == 200) {
                String html = EntityUtils.toString(response1.getEntity());
                Document document = Jsoup.parse(html);
                Elements elements = document.select("#aspnetForm > div.udivright > div:nth-child(2) > table > tbody > tr > td:nth-child(1) > table:nth-child(2) > tbody > tr > td:nth-child(2) > div:nth-child(1) > font");
                System.out.println(elements.get(0).text());
            }
        }
        httpClient.close();
    }
}
