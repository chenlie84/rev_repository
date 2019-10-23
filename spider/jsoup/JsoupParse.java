package com.itheima.spider.jsoup;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.junit.Test;

/**
 * @ClassName JsoupParse
 * @Description TODO 解析html
 */
public class JsoupParse {
    @Test
    public void jsoupAsJs() throws Exception{
        Document document = Jsoup.connect("http://www.itcast.cn").get();

        Elements divs = document.getElementsByClass("nav_txt");
        Element div = divs.get(0);//就只有一个div
        Elements uls = div.getElementsByTag("ul");
        Element ul = uls.get(0);
        Elements lis = ul.getElementsByTag("li");
        for (Element li : lis) {
            System.out.println(li.text());
        }
    }

    @Test
    public void jsoupAsCss() throws Exception {
        Document document = Jsoup.connect("http://www.itcast.cn").get();
        Elements lis = document.select(".nav_txt > ul >li");
        for (Element li : lis) {
            System.out.println(li.text());
        }
    }
}
