package com.itheima.spider.qidian;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.net.URI;

/**
 * @ClassName SpiderXiaoshuo
 * @Description TODO 爬取微博
 */
@SuppressWarnings("all")
public class SpiderVGTime {

    public static void main(String[] args) throws Exception {
        //1.确定目标
        String indexUrl = "https://www.vgtime.com/topic/index/load.jhtml?page=1";
        //2.发送请求，获取数据
        CloseableHttpClient httpClient = HttpClients.createDefault();
        //2.1 模拟浏览器
        HttpGet httpGet = new HttpGet(indexUrl);
        httpGet.setHeader("Cache-Control", "no-cache");
        httpGet.setHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36");
        //发送请求
        CloseableHttpResponse response = httpClient.execute(httpGet);
        int code = response.getStatusLine().getStatusCode();

        if (code == 200) {
            //得到html的对象
            String html = EntityUtils.toString(response.getEntity(), "UTF-8");
            Document document = Jsoup.parse(html);
           /* Elements body = document.getElementsByTag("body");
            System.out.println(body);*/

            //获取 网址  进行第二次请求
            Elements a = document.select("body > li > div > a ");


            String href = "";

            for (Element element : a) {
                System.out.println(element);
                String http = "https://www.vgtime.com";
                href = http + a.attr("href");
                System.out.println(href);
            }

            Elements h2 = document.select("body > li > div > a > h2");

            for (Element element1 : h2) {

                System.out.println("新闻" + element1);
                httpClient = HttpClients.createDefault();
                URI uri = new URI(href);
                httpGet.setURI(uri);//重新设定访问的地址
                CloseableHttpResponse response1 = httpClient.execute(httpGet);
                int code1 = response1.getStatusLine().getStatusCode();

                //System.out.println(code1);

                if (code1 == 200) {
                    String html1 = EntityUtils.toString(response1.getEntity());
                    Document document1 = Jsoup.parse(html1);
                    String title = document1.select(".art_tit").text();
                    System.out.println(title);
                    String text = document1.select(".topicContent front_content").text();
                    System.out.println(text);
                }

            }
                //System.out.println(href);

            System.out.println(code);
        }
    }
}
