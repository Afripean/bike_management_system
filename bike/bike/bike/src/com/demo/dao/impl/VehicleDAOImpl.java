package com.demo.dao.impl;

import com.demo.dao.VehicleDAO;
import com.demo.util.Util;
import com.demo.vo.Vehicle;
import com.demo.vo.Vehicle_user;
import com.google.gson.Gson;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class VehicleDAOImpl implements VehicleDAO {

    private static final Gson gson = new Gson();
    @Override
    public void addVehicle(Vehicle vehicle) {
        String sql = "INSERT INTO vehicles (licensePlate, type, status, che_date, che_ren, che_phone, createdAt, location, che_area, lastMaintenanceDate) VALUES (?, ?, ?::vehicle_status, ?, ?, ?, ?, ST_SetSRID(ST_MakePoint(?, ?), 4326), ?, ?)";
        try (Connection connection = Util.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, vehicle.getLicensePlate());
            statement.setString(2, vehicle.getType());
            statement.setString(3, vehicle.getStatus());
            statement.setDate(4, vehicle.getCheDate() != null ? java.sql.Date.valueOf(vehicle.getCheDate()) : null);
            statement.setString(5, vehicle.getCheRen());
            statement.setString(6, vehicle.getChePhone());
            statement.setTimestamp(7, vehicle.getCreatedAt());
            statement.setDouble(8, Double.parseDouble(vehicle.getLocation().split(",")[0]));
            statement.setDouble(9, Double.parseDouble(vehicle.getLocation().split(",")[1]));
            statement.setInt(10, 11); // 设置 che_area 为 11
            statement.setDate(11, java.sql.Date.valueOf("2024-07-01")); // 设置 lastMaintenanceDate 为 2024-07-01
            statement.executeUpdate();
        } catch (SQLException ex) {
            throw new RuntimeException(ex);
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }

    @Override
    public void updateVehicle(Vehicle vehicle) {
        String sql = "UPDATE vehicles SET licenseplate = ?, type = ?, status = ?::vehicle_status, che_date = ?, che_ren = ?, che_phone = ?, createdat = ?, che_area = ?, lastmaintenancedate = ? WHERE vehicleid = ?";
        try (Connection connection = Util.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, vehicle.getLicensePlate());
            statement.setString(2, vehicle.getType());
            statement.setString(3, vehicle.getStatus());
            statement.setDate(4, vehicle.getCheDate() != null ? java.sql.Date.valueOf(vehicle.getCheDate()) : null);
            statement.setString(5, vehicle.getCheRen());
            statement.setString(6, vehicle.getChePhone());
            statement.setTimestamp(7, vehicle.getCreatedAt());
            statement.setInt(8, 11); // 设置 che_area 为 11，或者根据需求动态设置
            statement.setDate(9, java.sql.Date.valueOf("2024-07-01")); // 设置 lastMaintenanceDate 为 2024-07-01，或者根据需求动态设置
            statement.setInt(10, vehicle.getVehicleId());
            statement.executeUpdate();
        } catch (Exception ex) {
            throw new RuntimeException("Error updating vehicle: " + ex.getMessage(), ex);
        }
    }




    @Override
    public void deleteVehicle(int id) {
        String sql = "DELETE FROM vehicles WHERE vehicleId = ?";
        try (Connection connection = Util.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Vehicle> listVehicles() {
        List<Vehicle> vehicles = new ArrayList<>();
        String sql = "SELECT v.vehicleId, v.licensePlate, v.type, v.status, v.che_area, v.che_date, v.che_ren, v.che_phone, " +
                "ST_AsGeoJSON(v.location) AS location, v.lastMaintenanceDate, v.createdAt, p.areaName " +
                "FROM vehicles v " +
                "JOIN ParkingAreas p ON v.che_area = p.areaId";
        try (Connection connection = Util.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                Vehicle vehicle = new Vehicle();
                vehicle.setVehicleId(resultSet.getInt("vehicleId"));
                vehicle.setLicensePlate(resultSet.getString("licensePlate"));
                vehicle.setType(resultSet.getString("type"));
                vehicle.setStatus(resultSet.getString("status"));
                vehicle.setCheArea(resultSet.getString("areaName"));
                vehicle.setCheDate(formatDate(resultSet.getTimestamp("che_date")));
                vehicle.setCheRen(resultSet.getString("che_ren"));
                vehicle.setChePhone(resultSet.getString("che_phone"));
                vehicle.setLocation(resultSet.getString("location"));
                vehicle.setLastMaintenanceDate(formatDate(resultSet.getTimestamp("lastMaintenanceDate")));
                vehicle.setCreatedAt(resultSet.getTimestamp("createdAt"));
                vehicles.add(vehicle);
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return vehicles;
    }

    private String formatDate(Timestamp timestamp) {
        if (timestamp == null) {
            return null;
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(timestamp);
    }



    @Override
    public List<Vehicle_user> getVehicles() throws Exception {
        List<Vehicle_user> vehicles = new ArrayList<>();
        try (Connection conn = Util.getConnection()) {
            String sql = "SELECT vehicleId, licensePlate, type, status, ST_AsGeoJSON(location) as location, lastMaintenanceDate, createdAt FROM Vehicles";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) {
                    Vehicle_user vehicle = new Vehicle_user();
                    vehicle.setVehicleId(rs.getInt("vehicleId"));
                    vehicle.setLicensePlate(rs.getString("licensePlate"));
                    vehicle.setType(rs.getString("type"));
                    vehicle.setStatus(rs.getString("status"));
                    vehicle.setLocation(gson.fromJson(rs.getString("location"), Map.class));
                    vehicle.setLastMaintenanceDate(rs.getTimestamp("lastMaintenanceDate"));
                    vehicle.setCreatedAt(rs.getTimestamp("createdAt"));
                    vehicles.add(vehicle);
                }
            }
        }
        return vehicles;
    }
}
