package com.demo.dao;

import com.demo.vo.Notices;

import java.sql.SQLException;
import java.util.List;

public interface NoticesDao {
    List<Notices> getNotices() throws SQLException;
}
