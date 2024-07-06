package com.demo.dao.impl;

import com.demo.util.Util;
import com.demo.dao.UserDAO;
import com.demo.vo.User;

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
 * 用户模块的DAO层（数据层）的具体实现类，对UserDAO接口中定义的增删改查等抽象方法作出具体的功能实现
 */
public class UserDAOImpl implements UserDAO {

    //@Override
    public void add(User vo) {
        String sql = "insert into t_user (username,password,real_name,user_sex,user_phone,user_text,user_type) values(?,?,?,?,?,?,?)";
        try {
            Connection c = Util.getConnection();
            System.out.println("数据库连接成功！！！");
            PreparedStatement ps = c.prepareStatement(sql);
            
            ps.setString(1, vo.getUsername());
            ps.setString(2, vo.getPassword());
            ps.setString(3, vo.getRealName());
            ps.setString(4, vo.getUserSex());
            ps.setString(5, vo.getUserPhone());
            ps.setString(6, vo.getUserText());
            ps.setString(7, vo.getUserType());
            ps.execute();
            ps.close();
            c.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //@Override
    public void update(User vo) {
        String sql = "update t_user set username = ? ,password = ? ,real_name = ? ,user_sex = ? ,user_phone = ? ,user_text = ? ,user_type = ?  where id = ?";
        try {
            Connection c = Util.getConnection();
            PreparedStatement ps = c.prepareStatement(sql);
            
            ps.setString(1, vo.getUsername());
            ps.setString(2, vo.getPassword());
            ps.setString(3, vo.getRealName());
            ps.setString(4, vo.getUserSex());
            ps.setString(5, vo.getUserPhone());
            ps.setString(6, vo.getUserText());
            ps.setString(7, vo.getUserType());
            ps.setLong(8, vo.getId());
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
            String sql = "delete from t_user where id = " + id;
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
    public User get(Serializable id) {
        User vo = null;
        try {
            Connection c = Util.getConnection();
            Statement s = c.createStatement();
            String sql = "select * from t_user where id = " + id;
            ResultSet rs = s.executeQuery(sql);
            if (rs.next()) {
                vo = new User();
                vo.setId(rs.getLong("id"));
                vo.setUsername(rs.getString("username"));
                vo.setPassword(rs.getString("password"));
                vo.setRealName(rs.getString("real_name"));
                vo.setUserSex(rs.getString("user_sex"));
                vo.setUserPhone(rs.getString("user_phone"));
                vo.setUserText(rs.getString("user_text"));
                vo.setUserType(rs.getString("user_type"));
            }
            c.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return vo;
    }

    //@Override
    public Map<String, Object> list(Map<String, Object> params) {
        List<User> list = new ArrayList<>();
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
            sqlList = "SELECT * FROM t_user WHERE 1=1 " + condition + " ORDER BY id ASC " + limit + ";";
            ps = c.prepareStatement(sqlList);
            rs = ps.executeQuery();
            while (rs.next()) {
                User vo = new User();
                vo.setId(rs.getLong("id"));
                vo.setUsername(rs.getString("username"));
                vo.setPassword(rs.getString("password"));
                vo.setRealName(rs.getString("real_name"));
                vo.setUserSex(rs.getString("user_sex"));
                vo.setUserPhone(rs.getString("user_phone"));
                vo.setUserText(rs.getString("user_text"));
                vo.setUserType(rs.getString("user_type"));
                list.add(vo);
            }
            String sqlCount = "SELECT count(*) FROM t_user WHERE 1=1 " + condition;
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

    @Override
    public User getbyName(Serializable name) {
        User vo = null;
        try {
            Connection c = Util.getConnection();
            String sql = "SELECT * FROM t_user WHERE username = ?";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, name.toString());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                vo = new User();
                vo.setId(rs.getLong("id"));
                vo.setUsername(rs.getString("username"));
                vo.setPassword(rs.getString("password"));
                vo.setRealName(rs.getString("real_name"));
                vo.setUserSex(rs.getString("user_sex"));
                vo.setUserPhone(rs.getString("user_phone"));
                vo.setUserText(rs.getString("user_text"));
                vo.setUserType(rs.getString("user_type"));
            }
            c.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return vo;
    }

}
