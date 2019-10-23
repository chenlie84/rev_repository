package com.itheima.gossip.util;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

/**
 * @ClassName JedisUtil
 * @Description TODO  提供一个方法，调用方法的时候返回一个jedis对象
 */
public class JedisUtils {

    private static JedisPool jedisPool;

    static {
        //创建连接池配置对象
        JedisPoolConfig config = new JedisPoolConfig();
        config.setMaxTotal(100);//最大连接数
        config.setMaxWaitMillis(3000);//最长等待时间
        config.setMinIdle(5);//最小空闲数
        config.setTestOnBorrow(true);//每次获取到连接后是否测试连接有效
        //创建连接池对象
        jedisPool = new JedisPool(config, "192.168.70.14", 6379);
    }

    public static Jedis getConn(){
        //从连接池中获取连接对象jedis，必须连接池才行
        return jedisPool.getResource();
    }

}
