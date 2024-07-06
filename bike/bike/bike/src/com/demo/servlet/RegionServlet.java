package com.demo.servlet;

import com.demo.service.ParkingAreaService;
import com.demo.service.VehicleService;
import com.demo.service.impl.ParkingAreaServiceImpl;
import com.demo.service.impl.VehicleServiceImpl;
import com.demo.vo.ParkingArea;
import com.demo.vo.Vehicle;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class RegionServlet extends HttpServlet {

    private VehicleService vehicleService = new VehicleServiceImpl();
    private ParkingAreaService parkingAreaService = new ParkingAreaServiceImpl();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action != null) {
            switch (action) {
                case "addVehicle":
                    try {
                        addVehicle(request, response);
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                    break;
                case "updateVehicle":
                    try {
                        updateVehicle(request, response);
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                    break;
                case "deleteVehicle":
                    deleteVehicle(request, response);
                    break;
                case "addParkingArea":
                    addParkingArea(request, response);
                    break;
                case "updateParkingArea":
                    try {
                        updateParkingArea(request, response);
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                    break;
                case "deleteParkingArea":
                    deleteParkingArea(request, response);
                    break;
                default:
                    response.getWriter().write("Action not supported: " + action);
                    System.out.print("Action not supported: " + action);
                    break;
            }
        } else {
            response.getWriter().write("Action not provided");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action != null) {
            switch (action) {
                case "getVehicles":
                    getVehicles(response);
                    break;
                case "getParkingAreas":
                    getParkingAreas(response);
                    break;
                default:
                    // 默认处理
                    request.getRequestDispatcher("region_manage.jsp").forward(request, response);
                    break;
            }
        } else {
            response.getWriter().write("Action not provided");
        }
    }

    private void addVehicle(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Vehicle vehicle = new Vehicle();
        vehicle.setLicensePlate(request.getParameter("licensePlate"));
        vehicle.setType(request.getParameter("type"));
        vehicle.setStatus(request.getParameter("status"));
        vehicle.setCheDate(request.getParameter("cheDate"));
        vehicle.setCheRen(request.getParameter("cheRen"));
        vehicle.setChePhone(request.getParameter("chePhone"));
        vehicle.setCreatedAt(parseTimestamp(request.getParameter("createdAt")));
        vehicle.setLocation(request.getParameter("location"));
        vehicleService.addVehicle(vehicle);
        response.getWriter().write("Vehicle added successfully");
    }

    private void updateVehicle(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = Integer.parseInt(request.getParameter("vehicleId"));
        Vehicle vehicle = new Vehicle();
        vehicle.setVehicleId(id);
        vehicle.setLicensePlate(request.getParameter("licensePlate"));
        vehicle.setType(request.getParameter("type"));
        vehicle.setStatus(request.getParameter("status"));
        vehicle.setCheDate(request.getParameter("cheDate"));
        vehicle.setCheRen(request.getParameter("cheRen"));
        vehicle.setChePhone(request.getParameter("chePhone"));
        vehicle.setCreatedAt(parseTimestamp(request.getParameter("createdAt")));
        vehicleService.updateVehicle(vehicle);
        response.getWriter().write("Vehicle updated successfully");
    }

    private void deleteVehicle(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("vehicleId"));

        System.out.print(id);
        vehicleService.deleteVehicle(id);
        response.getWriter().write("Vehicle deleted successfully");
    }

    private void getVehicles(HttpServletResponse response) throws IOException {
        List<Vehicle> vehicles = vehicleService.listVehicles();

        // 将数据转换为 JSON 格式
        String jsonResponse = gson.toJson(vehicles);

        // 返回 JSON 数据给前端
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
    }

    private void addParkingArea(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String areaName = request.getParameter("areaName");
        String areaGeoJson = request.getParameter("areaGeoJson");

        ParkingArea parkingArea = new ParkingArea();
        parkingArea.setAreaName(areaName);
        parkingArea.setAreaGeoJson(areaGeoJson);

        parkingAreaService.addParkingArea(parkingArea);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"status\":\"success\"}");
        out.flush();
    }

    private void updateParkingArea(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int areaId = Integer.parseInt(request.getParameter("areaId"));
        String areaName = request.getParameter("areaName");
        String createdAt = request.getParameter("createdAt");

        ParkingArea parkingArea = new ParkingArea();
        parkingArea.setAreaId(areaId);
        parkingArea.setAreaName(areaName);
        parkingArea.setCreatedAt(parseTimestamp(createdAt));

        parkingAreaService.updateParkingArea(parkingArea);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"status\":\"success\"}");
        out.flush();
    }

    private void deleteParkingArea(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int areaId = Integer.parseInt(request.getParameter("areaId"));
        parkingAreaService.deleteParkingArea(areaId);
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"status\":\"success\"}");
        out.flush();
    }

    private void getParkingAreas(HttpServletResponse response) throws IOException {
        List<ParkingArea> parkingAreas = parkingAreaService.listParkingAreas();

        // 将数据转换为 JSON 格式
        String jsonResponse = gson.toJson(parkingAreas);

        // 返回 JSON 数据给前端
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
    }

    private Timestamp parseTimestamp(String createdAt) throws Exception {
        // 尝试解析多种日期格式
        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd", java.util.Locale.ENGLISH);
        SimpleDateFormat sdf2 = new SimpleDateFormat("MMM d, yyyy h:mm:ss a", java.util.Locale.ENGLISH);
        Date date;

        try {
            date = sdf1.parse(createdAt);
        } catch (ParseException e) {
            date = sdf2.parse(createdAt);
        }

        return new Timestamp(date.getTime());
    }

}
