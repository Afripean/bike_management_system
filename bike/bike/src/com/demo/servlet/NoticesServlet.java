package com.demo.servlet;

import com.google.gson.Gson;
import com.demo.util.Util;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NoticesServlet extends HttpServlet {

    private static final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if ("notices".equals(action)) {
            try {
                String data = getNotices();
                request.setAttribute("data", data);
                request.setAttribute("active", "Notices_active");
                request.getRequestDispatcher("notices.jsp").forward(request, response);
            } catch (SQLException e) {
                throw new ServletException(e);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action parameter");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    private String getNotices() throws SQLException {
        List<Map<String, Object>> notices = new ArrayList<>();
        try (Connection conn = Util.getConnection()) {
            String sqlNotices = "SELECT id, notice_name, notice_text, notice_type FROM t_notice";
            System.out.println("Executing SQL: " + sqlNotices);
            try (PreparedStatement pstmt = conn.prepareStatement(sqlNotices)) {
                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) {
                    Map<String, Object> notice = new HashMap<>();
                    notice.put("id", rs.getInt("id"));
                    notice.put("notice_name", rs.getString("notice_name"));
                    notice.put("notice_text", rs.getString("notice_text"));
                    notice.put("notice_type", rs.getString("notice_type"));
                    System.out.println("Fetched notice: " + notice);
                    notices.add(notice);
                }
            }
        } catch (Exception e) {
            throw new SQLException("Error getting notices", e);
        }
        System.out.println("Notices: " + gson.toJson(notices));
        return gson.toJson(notices);
    }
}
