package com.itheima.gossip.controller;

import com.itheima.gossip.service.TopKeySearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * @CLassName TopKeySearchController
 * @Description TODO  topkey的 web
 *
 **/
@RestController
public class TopKeySearchController {

    @Autowired
    private TopKeySearchService topKeySearchService;

    @RequestMapping("/top")
    public List<Map<String,Object>> topKeyFindByNum(Integer num) throws Exception {
        //判断参数是否为空
        if (num == null || num <= 0) {
            num = 9;

        }
        //调用服务层
        List<Map<String, Object>> mapList = topKeySearchService.topKeyByNum(num);

        return mapList;
    }


}
