package com.demo.service;


import com.demo.vo.Travelpaths;

import java.io.Serializable;

public interface TravelpathsService {
    /**
     * 根据主键Id查询轨迹详情
     *
     * @param id
     * @return
     */
    Travelpaths get(long id);
}
