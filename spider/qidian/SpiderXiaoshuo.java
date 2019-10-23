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

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.net.URI;

/**
 * @ClassName SpiderXiaoshuo
 * @Description TODO 爬取起点小说
 */
public class SpiderXiaoshuo {
    //1.确定目标
    private static  String indexUrl = "https://www.qidian.com/";
    //2.发送请求，获取数据   创建httpclient 和 httpget对象
    private static  CloseableHttpClient httpClient = HttpClients.createDefault();
    private static  HttpGet httpGet = new HttpGet(indexUrl);

    public static void main(String[] args) throws Exception {


        //2.1 模拟浏览器
        httpGet.setHeader("Cache-Control", "no-cache");
        httpGet.setHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36");

        //发送请求, 获取响应
        CloseableHttpResponse response = httpClient.execute(httpGet);
        int code = response.getStatusLine().getStatusCode();
        if (code == 200) {
            //得到html
            String html = EntityUtils.toString(response.getEntity(), "UTF-8");
            Document document = Jsoup.parse(html);
            //获取第一个小说的超链接
            Elements a1 = document.select("[class=rank-list mr0] > div > ul > li > div > div > h4 > a");
            //第二个之后再用另外的表达式--作业  找另外14个a标签
            Elements a2 = document.select("[class=rank-list mr0] > div > ul > li[class!=unfold] > div > a");

            for (Element a : a2) {
                System.out.println(a);
                String http = "https:";
                String href = http + a.attr("href");
                System.out.println("--------------------------------------------------");
                System.out.println(href);

                //第二次发送请求
                httpClient = HttpClients.createDefault();
                URI uri = new URI(href);
                httpGet.setURI(uri);//重新设定访问的地址
                CloseableHttpResponse response1 = httpClient.execute(httpGet);
                int code1 = response1.getStatusLine().getStatusCode();

                System.out.println(code1);
                if (code1 == 200) {
                    String html1 = EntityUtils.toString(response1.getEntity());
                    Document document1 = Jsoup.parse(html1);
                    Elements elements = document1.select("#readBtn");
                    String href1 = http + elements.get(0).attr("href");
                    //第三次发送请求
                    httpClient = HttpClients.createDefault();
                    URI uri1 = new URI(href1);
                    httpGet.setURI(uri1);//重新设定访问的地址
                    CloseableHttpResponse response2 =httpClient.execute(httpGet);
                    int code2 = response2.getStatusLine().getStatusCode();


                    if (code2 == 200) {
                        String html2 = EntityUtils.toString(response2.getEntity());
                        Document document2 = Jsoup.parse(html2);

                        BufferedWriter bw = writerText(document2);

                        String end = getDoc(document2,bw);

                        System.out.println(end);

                    }
                }
            }
            httpClient.close();
        }
    }

    public static BufferedWriter writerText(Document document) throws Exception {

        System.out.println("--------------------------------------");
        String id = document.select("#j_textWrap").attr("data-cid");
        //System.out.println(id);
        Elements h1s = document.select("#j_textWrap > div > div.book-cover-wrap > h1");
        String text = h1s.get(0).text();


        Elements h3s = document.select("#chapter-"+id+" > div > div.text-head > h3");
        System.out.println(h3s);
        String title = h3s.get(0).text();
        System.out.println(title);

        BufferedWriter bw = new BufferedWriter(new FileWriter("E:\\小说\\"+text+".txt",true));
        bw.write(title);
        bw.newLine();
        Elements ps = document.select("[class=read-content j_readContent] > p");
        for (Element p : ps) {
            bw.write(p.text());
            bw.newLine();
            bw.flush();
            System.out.println(p.text());
        }
        return bw;

    }

    public static String getDoc(Document document,BufferedWriter bw) throws Exception {
        String http = "https:";

        Elements a = document.select("#j_chapterNext");  //j_chapterNext
        String href = http + a.get(0).attr("href");
        String end = a.text();

        if (!"书末页".equals(end) ) {
            //第三次请求
            httpClient = HttpClients.createDefault();
            URI uri = new URI(href);
            httpGet.setURI(uri);//重新设定访问的地址
            CloseableHttpResponse response = httpClient.execute(httpGet);
            int code = response.getStatusLine().getStatusCode();

            if (code == 200) {
                String html = EntityUtils.toString(response.getEntity());
                document = Jsoup.parse(html);
                //写入到文件
                Elements h3s = document.select("[class=text-wrap] > div > div.text-head > h3");
                System.out.println(h3s);
                String title = h3s.get(0).text();
                System.out.println(title);

                System.out.println("-------------------------------------------------------");

                //BufferedWriter bw = new BufferedWriter(new FileWriter("E:\\小说\\"+text+title+".txt", true));
                bw.write(title);
                bw.newLine();
                Elements ps = document.select("[class=read-content j_readContent] > p");
                for (Element p : ps) {
                    bw.write(p.text());
                    bw.newLine();
                    bw.flush();
                    //System.out.println(p.text());
                }

                //递归调用 ， 进入下一章
                getDoc(document,bw);


            }else {
                System.out.println("请求状态错误!!!!!!!!!");
            }

        }else {
            //当进入写一个小说的时候关闭流
            bw.close();
            return end;
        }
        return end;
    }
}
