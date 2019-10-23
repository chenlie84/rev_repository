package com.itheima.spider.jdk;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * @ClassName JDKGet
 * @Description TODO  原生jdk-get发送请求---了解
 */
public class JDKGet {

    public static void main(String[] args) throws Exception {
        //1.确定爬取的url
        String indexUrl = "http://www.itcast.cn/?usernmae=zhangsan&password=123456";
        //2.发送请求
        //2.1将字符串格式的url转化为对象格式
        URL url = new URL(indexUrl);
        //2.2获取连接
        HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
        //2.3发送请求，获取数据
        InputStream in = urlConnection.getInputStream();
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
