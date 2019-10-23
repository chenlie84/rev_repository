package com.itheima.gossip.timing;

import com.itheima.gossip.service.IndexWriterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Date;

/**
 * @CLassName IndexWriterTiming
 * @Description TODO  spring的一个定时器
 **/
@Component
public class IndexWriterTiming {

    @Autowired
    private IndexWriterService indexWriterService;

    @Scheduled(cron = "0 * 11 * * ?")
    public void indexWirter() throws Exception {
        System.out.println(new Date().toLocaleString());
        indexWriterService.indexWriter();
    }

}
