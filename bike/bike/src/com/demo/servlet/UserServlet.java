
package com.demo.servlet;

import com.alibaba.fastjson.JSONObject;
import com.demo.util.Util;
import com.demo.service.UserService;
import com.demo.service.impl.UserServiceImpl;
import com.demo.vo.Travelpaths;
import com.demo.vo.User;
import com.google.gson.Gson;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServlet extends HttpServlet {

    private static final Gson gson = new Gson();

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = Util.decode(request, "action");
        if ("add".equals(action)) {
            User vo = new User();
            vo.setUsername(Util.decode(request, "username"));
            vo.setPassword(Util.decode(request, "password"));
            vo.setRealName(Util.decode(request, "realName"));
            vo.setUserSex(Util.decode(request, "userSex"));
            vo.setUserPhone(Util.decode(request, "userPhone"));
            vo.setUserText(Util.decode(request, "userText"));
            vo.setUserType(Util.decode(request, "userType"));
            UserService userService = new UserServiceImpl();
            userService.add(vo);
            this.redirectList(request, response);
        } else if ("delete".equals(action)) {
            long id = Long.parseLong(Util.decode(request, "id"));
            UserService userService = new UserServiceImpl();
            userService.delete(id);
            this.redirectList(request, response);
        } else if ("edit".equals(action)) {
            User vo = new User();
            vo.setId(Long.valueOf(Util.decode(request, "id")));
            vo.setUsername(Util.decode(request, "username"));
            vo.setPassword(Util.decode(request, "password"));
            vo.setRealName(Util.decode(request, "realName"));
            vo.setUserSex(Util.decode(request, "userSex"));
            vo.setUserPhone(Util.decode(request, "userPhone"));
            vo.setUserText(Util.decode(request, "userText"));
            vo.setUserType(Util.decode(request, "userType"));
            UserService userService = new UserServiceImpl();
            userService.update(vo);
            this.redirectList(request, response);
        } else if ("get".equalsIgnoreCase(action) || "editPre".equalsIgnoreCase(action)) {
            Serializable id = Util.decode(request, "id");
            UserService userService = new UserServiceImpl();
            User vo = userService.get(id);
            response.getWriter().println(gson.toJson(vo));
        }
        else {
            this.redirectList(request, response);
        }
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = Util.decode(request, "action");
        if ("id".equals(action)) {
            UserService userService = new UserServiceImpl();
            User user= userService.getbyName(request.getParameter("username"));
            // 确保用户对象不为空
            if (user != null) {
                // 获取用户ID
                Long userId = user.getId();
                // 打印获取到的用户ID
                System.out.println("Found userID: " + userId);

                // 创建JSON对象
                JSONObject jsonResponse = new JSONObject();
                jsonResponse.put("userid", userId);

                // 发送响应
                PrintWriter out = response.getWriter();
                response.setContentType("application/json");
                out.print(jsonResponse);
                out.flush();

            }

        }else {
            // 用户未找到的情况下返回适当的错误响应
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            PrintWriter out = response.getWriter();
            out.print("{\"error\": \"User not found\"}");
            out.flush();
        }

    }

    private void redirectList(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String searchColumn = Util.decode(request, "searchColumn");
        String keyword = Util.decode(request, "keyword");
        Map<String, Object> params = new HashMap<>();
        params.put("searchColumn", searchColumn);
        params.put("keyword", keyword);
        UserService userService = new UserServiceImpl();
        Map<String, Object> map = userService.list(params);
        request.getSession().setAttribute("list", map.get("list"));

        Integer totalRecord = (Integer) map.get("totalCount");
        String pageNum = Util.decode(request, "pageNum");
        com.demo.util.PageBean<Object> pb = new com.demo.util.PageBean<>(Integer.valueOf(pageNum != null ? pageNum : "1"), totalRecord);
        params.put("startIndex", pb.getStartIndex());
        params.put("pageSize", pb.getPageSize());
        List<Object> list = (List<Object>) userService.list(params).get("list");
        pb.setServlet("UserServlet");
        pb.setSearchColumn(searchColumn);
        pb.setKeyword(keyword);
        pb.setList(list);
        request.getSession().setAttribute("pageBean", pb);
        request.getSession().setAttribute("list", pb.getList());

        response.sendRedirect("introduce.jsp");
    }


}
