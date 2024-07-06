package com.demo.service.impl;

import com.demo.dao.NoticesDao;
import com.demo.dao.impl.NoticesDaoImpl;
import com.demo.service.NoticesService;
import com.demo.vo.Notices;

import java.sql.SQLException;
import java.util.List;

public class NoticesServiceImpl implements NoticesService {
    private NoticesDao noticesDao = new NoticesDaoImpl();

    @Override
    public List<Notices> getNotices() throws SQLException {
        return noticesDao.getNotices();
    }
}
