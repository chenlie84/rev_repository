package com.itheima.gossip.service;

import java.util.List;
import java.util.Map;

public interface TopKeySearchService {

    //通过传递的数值来获取热搜词  模拟状态
    public List<Map<String , Object>> topKeyByNum(Integer num) throws Exception;



}
