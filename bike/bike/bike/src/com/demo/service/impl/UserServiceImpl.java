package com.demo.service.impl;

import com.demo.dao.UserDAO;
import com.demo.dao.impl.UserDAOImpl;
import com.demo.service.UserService;
import com.demo.vo.User;

import java.io.Serializable;
import java.util.Map;

/**
 * 用户模块的Service层（业务层）的具体实现类，对UserService接口中定义的抽象方法作出具体的功能实现
 */
public class UserServiceImpl implements UserService {
    //@Override
    public void add(User vo) {
        UserDAO userDAO = new UserDAOImpl();
        userDAO.add(vo);
    }

    //@Override
    public void delete(long id) {
        UserDAO userDAO = new UserDAOImpl();
        userDAO.delete(id);
    }

    //@Override
    public void update(User vo) {
        UserDAO userDAO = new UserDAOImpl();
        userDAO.update(vo);
    }

    //@Override
    public User get(Serializable id) {
        UserDAO userDAO = new UserDAOImpl();
        return userDAO.get(id);
    }
    //@Override
    public User getbyName(Serializable name) {
        UserDAO userDAO = new UserDAOImpl();
        return userDAO.getbyName(name);
    }

    //@Override
    public Map<String, Object> list(Map<String, Object> params) {
        UserDAO userDAO = new UserDAOImpl();
        return userDAO.list(params);
    }
}
