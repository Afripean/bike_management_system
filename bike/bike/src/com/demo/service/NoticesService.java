package com.demo.service;

import com.demo.vo.Notices;

import java.sql.SQLException;
import java.util.List;

public interface NoticesService {
    List<Notices> getNotices() throws SQLException;
}
