package com.demo.dao.impl;

import com.demo.dao.NoticesDao;
import com.demo.util.Util;
import com.demo.vo.Notices;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class NoticesDaoImpl implements NoticesDao {

    @Override
    public List<Notices> getNotices() throws SQLException {
        List<Notices> notices = new ArrayList<>();
        try (Connection conn = Util.getConnection()) {
            String sqlNotices = "SELECT id, notice_name, notice_text, notice_type FROM t_notice";
            try (PreparedStatement pstmt = conn.prepareStatement(sqlNotices)) {
                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) {
                    Notices notice = new Notices();
                    notice.setId(rs.getInt("id"));
                    notice.setNoticeName(rs.getString("notice_name"));
                    notice.setNoticeText(rs.getString("notice_text"));
                    notice.setNoticeType(rs.getString("notice_type"));
                    notices.add(notice);
                }
            }
        } catch (Exception e) {
            throw new SQLException("Error getting notices", e);
        }
        return notices;
    }
}
