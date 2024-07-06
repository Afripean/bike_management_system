package com.demo.service.impl;

import com.demo.dao.NoticeDAO;
import com.demo.dao.impl.NoticeDAOImpl;
import com.demo.service.NoticeService;
import com.demo.vo.Notice;

import java.io.Serializable;
import java.util.Map;

/**
 * 公告模块的Service层（业务层）的具体实现类，对NoticeService接口中定义的抽象方法作出具体的功能实现
 */
public class NoticeServiceImpl implements NoticeService {
    //@Override
    public void add(Notice vo) {
        NoticeDAO noticeDAO = new NoticeDAOImpl();
        noticeDAO.add(vo);
    }

    //@Override
    public void delete(long id) {
        NoticeDAO noticeDAO = new NoticeDAOImpl();
        noticeDAO.delete(id);
    }

    //@Override
    public void update(Notice vo) {
        NoticeDAO noticeDAO = new NoticeDAOImpl();
        noticeDAO.update(vo);
    }

    //@Override
    public Notice get(Serializable id) {
        NoticeDAO noticeDAO = new NoticeDAOImpl();
        return noticeDAO.get(id);
    }

    //@Override
    public Map<String, Object> list(Map<String, Object> params) {
        NoticeDAO noticeDAO = new NoticeDAOImpl();
        return noticeDAO.list(params);
    }
}
