package com.demo.servlet;


import com.demo.service.TravelpathsService;
import com.demo.service.UserService;
import com.demo.service.impl.TravelpathsServiceImpl;
import com.demo.service.impl.UserServiceImpl;
import com.demo.vo.Travelpaths;
import com.demo.vo.User;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AnalysisServlet")
public class AnalysisServlet extends HttpServlet {
    private TravelpathsService travelpathsService = new TravelpathsServiceImpl();
    private UserService userService = new UserServiceImpl();
    protected  void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{

            request.setAttribute("active", "Analysis_active");
            request.getRequestDispatcher("carbonAnalysis.jsp").forward(request, response);

    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{


       User user= userService.getbyName(request.getParameter("name"));
        // 确保用户对象不为空
        if (user != null) {
            // 获取用户ID
            Long userId = user.getId();

            // 通过用户ID获取旅行路径对象
            Travelpaths travelPaths = travelpathsService.get(userId);

            // 将旅行路径对象存储在请求属性中
            request.setAttribute("travelPaths", travelPaths);
            request.getRequestDispatcher("carbonAnalysis.jsp").forward(request, response);
//            // 转发请求到 carbonAnalysis.jsp
//            RequestDispatcher dispatcher = request.getRequestDispatcher("carbonAnalysis.jsp");
//            dispatcher.forward(request, response);
        } else {
            // 处理用户未找到的情况
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
        }


    }
}
