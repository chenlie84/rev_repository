package com.itheima.cache.service.test;

import com.itheima.cache.service.NewsCacheService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * @CLassName CacheServiceTest
 * @Description TODO  测试缓存服务
 **/
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:applicationContext.xml")
public class CacheServiceTest {

    @Autowired
    private NewsCacheService newsCacheService;

    @Test
    public void cacheTest() throws Exception {
        newsCacheService.cacheNews("韩庚");
    }


}
