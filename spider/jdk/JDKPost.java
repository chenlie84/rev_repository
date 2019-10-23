package com.itheima.spider.jdk;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * @ClassName JDKPost
 * @Description TODO post方式--了解
 */
public class JDKPost {
    public static void main(String[] args) throws IOException {
        //1.确定爬取的url
        String indexUrl = "http://www.itcast.cn/";
        //2.发送请求
        //2.1字符串变成对象
        URL url = new URL(indexUrl);
        //获取连接
        HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
        urlConnection.setRequestMethod("POST");
        urlConnection.setDoOutput(true);//默认是false,不让往输出中写入数据
        OutputStream out = urlConnection.getOutputStream();//得到一个输出流，将信息写入到的输出流中，发送到网络
        out.write("username=zhangsan&password=123456".getBytes());//将参数写入到输出流中发送出去
        InputStream in = urlConnection.getInputStream();//获取到数据
        //流对接
        int len = 0;
        byte[] b = new byte[1024];
        while ((len=in.read(b))!=-1){
            System.out.println(new String(b,0,len));//string不要导包
        }
        //释放资源
        in.close();
    }
}
