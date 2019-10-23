package com.itheima.spider.jsoup;

import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import java.io.IOException;

/**
 * @ClassName JsoupDocument
 * @Description TODO 用jsoup解析html，获取document对象
 */
public class JsoupDocument {
    public static void main(String[] args) throws IOException {
        //第一种  给我一个html字符串
        String html = "<!DOCTYPE html>\n" +
                "<html lang=\"en\">\n" +
                "<head>\n" +
                "    <meta charset=\"UTF-8\">\n" +
                "    <title>获取document的方式一</title>\n" +
                "</head>\n" +
                "<body>\n" +
                "\n" +
                "</body>\n" +
                "</html>";
        //将HTML字符串转换成dom 对象
        Document document = Jsoup.parse(html);

        //通过dom对象对html进行操作
        Element head = document.head();
        String text = head.text();
        System.out.println(text);


        //第二种方式  解析文件，基本不用
        //Document document1 = Jsoup.parse(new File("d:/index.html"), "UTF-8");



        //第三种方式  可以发送请求,获取数据（Document） 这种方式只适合不封ip的网站
        String indexUrl = "http://www.itcast.cn";
        Connection connect = Jsoup.connect(indexUrl);
        Document document2 = connect.get();
        System.out.println(document2.head().text());


        //第四种 解析html代码片段
        String htmlString = "<a>这个是jsoup解析的第四种方式</a>";
        Document document3 = Jsoup.parseBodyFragment(htmlString);
        System.out.println(document3.text());


    }
}
