package com.demo.dao.impl;

import com.demo.dao.ParkingAreaDAO;
import com.demo.vo.ParkingArea;
import com.demo.util.Util;
import com.google.gson.Gson;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ParkingAreaDAOImpl implements ParkingAreaDAO {


    public void addParkingArea(ParkingArea parkingArea) {
        String sql = "INSERT INTO ParkingAreas (areaName, area, createdAt) VALUES (?, ST_GeomFromGeoJSON(?), NOW())";
        try (Connection connection = Util.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, parkingArea.getAreaName());
            statement.setString(2, parkingArea.getAreaGeoJson());
            statement.executeUpdate();
        } catch (SQLException ex) {
            throw new RuntimeException(ex);
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }


    public void updateParkingArea(ParkingArea parkingArea) {
        String sql = "UPDATE ParkingAreas SET areaName = ?, createdAt = ? WHERE areaId = ?";
        try (Connection connection = Util.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, parkingArea.getAreaName());
            statement.setTimestamp(2, parkingArea.getCreatedAt());
            statement.setInt(3, parkingArea.getAreaId());
            statement.executeUpdate();
        } catch (SQLException ex) {
            throw new RuntimeException(ex);
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }


    public void deleteParkingArea(int areaId) {
        String sql = "DELETE FROM ParkingAreas WHERE areaId = ?";
        try (Connection connection = Util.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, areaId);
            statement.executeUpdate();
        } catch (SQLException ex) {
            throw new RuntimeException(ex);
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }

    public List<ParkingArea> listParkingAreas() {
        List<ParkingArea> parkingAreas = new ArrayList<>();
        String sql = "SELECT areaId, areaName, ST_AsGeoJSON(area) AS area, createdAt FROM ParkingAreas";
        try (Connection connection = Util.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                ParkingArea area = new ParkingArea();
                area.setAreaId(resultSet.getInt("areaId"));
                area.setAreaName(resultSet.getString("areaName"));
                area.setAreaGeoJson(resultSet.getString("area"));
                area.setCreatedAt(resultSet.getTimestamp("createdAt"));
                parkingAreas.add(area);
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return parkingAreas;
    }
    private static final Gson gson = new Gson();

    @Override
    public List<ParkingArea> getParkingAreas() throws Exception {
        List<ParkingArea> parkingAreas = new ArrayList<>();
        try (Connection conn = Util.getConnection()) {
            String sql = "SELECT areaId, areaName, ST_AsGeoJSON(area) as area, createdAt FROM ParkingAreas";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) {
                    ParkingArea area = new ParkingArea();
                    area.setAreaId(rs.getInt("areaId"));
                    area.setAreaName(rs.getString("areaName"));
                    area.setArea(gson.fromJson(rs.getString("area"), Map.class));
                    area.setCreatedAt(rs.getTimestamp("createdAt"));
                    parkingAreas.add(area);
                }
            }
        }
        return parkingAreas;
    }
}
