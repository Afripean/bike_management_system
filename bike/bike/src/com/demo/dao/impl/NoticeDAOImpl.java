package com.demo.dao.impl;

import com.demo.util.Util;
import com.demo.dao.NoticeDAO;
import com.demo.vo.Notice;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 公告模块的DAO层（数据层）的具体实现类，对NoticeDAO接口中定义的增删改查等抽象方法作出具体的功能实现
 */
public class NoticeDAOImpl implements NoticeDAO {

    //@Override
    public void add(Notice vo) {
        String sql = "insert into t_notice (notice_name,notice_text,notice_type,create_date) values(?,?,?,?)";
        try {
            Connection c = Util.getConnection();
            PreparedStatement ps = c.prepareStatement(sql);
            
            ps.setString(1, vo.getNoticeName());
            ps.setString(2, vo.getNoticeText());
            ps.setString(3, vo.getNoticeType());
            ps.setString(4, vo.getCreateDate());
            ps.execute();
            ps.close();
            c.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //@Override
    public void update(Notice vo) {
        String sql = "update t_notice set notice_name = ? ,notice_text = ? ,notice_type = ? ,create_date = ?  where id = ?";
        try {
            Connection c = Util.getConnection();
            PreparedStatement ps = c.prepareStatement(sql);
            
            ps.setString(1, vo.getNoticeName());
            ps.setString(2, vo.getNoticeText());
            ps.setString(3, vo.getNoticeType());
            ps.setString(4, vo.getCreateDate());
            ps.setLong(5, vo.getId());
            ps.execute();
            ps.close();
            c.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //@Override
    public boolean delete(long id) {
        try {
            Connection c = Util.getConnection();
            Statement s = c.createStatement();
            String sql = "delete from t_notice where id = " + id;
            s.execute(sql);
            s.close();
            c.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    //@Override
    public Notice get(Serializable id) {
        Notice vo = null;
        try {
            Connection c = Util.getConnection();
            Statement s = c.createStatement();
            String sql = "select * from t_notice where id = " + id;
            ResultSet rs = s.executeQuery(sql);
            if (rs.next()) {
                vo = new Notice();
                vo.setId(rs.getLong("id"));
                vo.setNoticeName(rs.getString("notice_name"));
                vo.setNoticeText(rs.getString("notice_text"));
                vo.setNoticeType(rs.getString("notice_type"));
                vo.setCreateDate(rs.getString("create_date"));
            }
            c.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return vo;
    }

    //@Override
    public Map<String, Object> list(Map<String, Object> params) {
        List<Notice> list = new ArrayList<>();
        int totalCount = 0;
        String condition = "";
        String sqlList;
        if (params.get("searchColumn") != null && !"".equals(params.get("searchColumn"))) {
            condition += " and \"" + params.get("searchColumn") + "\" like '%" + params.get("keyword") + "%'";
        }
        try {
            Connection c = Util.getConnection();
            PreparedStatement ps;
            ResultSet rs;
            String limit = (params.get("startIndex") != null && params.get("pageSize") != null) ? " LIMIT " + params.get("pageSize") + " OFFSET " + params.get("startIndex") : "";
            sqlList = "SELECT * FROM t_notice WHERE 1=1 " + condition + " ORDER BY id ASC " + limit + ";";
            ps = c.prepareStatement(sqlList);
            rs = ps.executeQuery();
            while (rs.next()) {
                Notice vo = new Notice();
                vo.setId(rs.getLong("id"));
                vo.setNoticeName(rs.getString("notice_name"));
                vo.setNoticeText(rs.getString("notice_text"));
                vo.setNoticeType(rs.getString("notice_type"));
                vo.setCreateDate(rs.getString("create_date"));
                list.add(vo);
            }
            String sqlCount = "SELECT count(*) FROM t_notice WHERE 1=1 " + condition;
            ps = c.prepareStatement(sqlCount);
            rs = ps.executeQuery();
            if (rs.next()) {
                totalCount = rs.getInt(1);
            }
            rs.close();
            ps.close();
            c.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("totalCount", totalCount);
        return result;
    }

}
