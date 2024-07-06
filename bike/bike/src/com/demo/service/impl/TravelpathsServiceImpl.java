package com.demo.service.impl;


import com.demo.dao.TravelpathsDAO;
import com.demo.dao.impl.TravelpathsDAOImpl;
import com.demo.service.TravelpathsService;
import com.demo.vo.Travelpaths;

import java.io.Serializable;

public class TravelpathsServiceImpl implements TravelpathsService {
    //@Override
    public Travelpaths get(long id) {
        TravelpathsDAO travelpathsDAO = new TravelpathsDAOImpl();
        return travelpathsDAO.getAnalysesByUserId(id);
    }
}
