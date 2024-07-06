
package com.demo.servlet;

import com.demo.service.MapService;
import com.demo.service.impl.MapServiceImpl;
import com.demo.util.Util;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;


public class MapServlet extends HttpServlet {
    private static final Gson gson = new Gson();
    private final MapService mapService = new MapServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if ("map".equals(action)) {
            try {
                String data = getParkingAreasAndVehicles();
                request.setAttribute("data", data);
            } catch (Exception e) {
                throw new ServletException(e);
            }
            request.setAttribute("active", "Map_active");
            request.getRequestDispatcher("map.jsp").forward(request, response);
        } else if ("saveRoute".equals(action)) {
            try {
                saveRoute(request, response);
            } catch (SQLException e) {
                throw new ServletException("Error saving route data", e);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    private String getParkingAreasAndVehicles() throws Exception {
        Map<String, Object> data = new HashMap<>();
        data.put("parkingAreas", mapService.getParkingAreas());
        data.put("vehicles", mapService.getVehicles());
        return gson.toJson(data);
    }

    private void saveRoute(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        String jsonString = sb.toString();
        System.out.println("Received route data: " + jsonString); // 调试信息

        Map<String, Object> routeData = gson.fromJson(jsonString, Map.class);

        try (Connection conn = Util.getConnection()) {
            String sql = "INSERT INTO travelpaths (userid, vehicleid, starttime, endtime, pathdata, distance, createdat) VALUES (?, ?, ?, ?, ST_GeomFromGeoJSON(?), ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setLong(1, ((Number) routeData.get("userid")).longValue());
                pstmt.setLong(2, ((Number) routeData.get("vehicleid")).longValue());
                pstmt.setTimestamp(3, convertToTimestamp((String) routeData.get("starttime")));
                pstmt.setTimestamp(4, convertToTimestamp((String) routeData.get("endtime")));
                pstmt.setString(5, (String) routeData.get("pathdata"));

                Object distanceObj = routeData.get("distance");
                if (distanceObj == null) {
                    throw new SQLException("Distance field is missing");
                }
                double distanceValue;
                if (distanceObj instanceof Number) {
                    distanceValue = ((Number) distanceObj).doubleValue();
                } else {
                    try {
                        distanceValue = Double.parseDouble(distanceObj.toString());
                    } catch (NumberFormatException e) {
                        throw new SQLException("Invalid distance value: " + distanceObj);
                    }
                }
                System.out.println("Parsed distance: " + distanceValue); // 调试信息

                pstmt.setBigDecimal(6, new BigDecimal(String.format("%.2f", distanceValue)));
                pstmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));

                pstmt.executeUpdate();
                System.out.println("Route data saved successfully"); // 调试信息
            }
        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
            throw new SQLException("Error saving route data", e);
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            throw new SQLException("Error saving route data", e);
        }

        response.getWriter().write("{\"status\":\"success\"}");
    }


    private Timestamp convertToTimestamp(String timeString) throws ParseException {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");
        Date parsedDate = dateFormat.parse(timeString);
        return new Timestamp(parsedDate.getTime());
    }
}
