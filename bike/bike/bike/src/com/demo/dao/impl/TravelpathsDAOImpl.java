package com.demo.dao.impl;

import com.demo.dao.TravelpathsDAO;
import com.demo.util.Util;
import com.demo.vo.Travelpaths;
import com.demo.vo.Travelpath;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.locks.ReentrantLock;

public class TravelpathsDAOImpl implements TravelpathsDAO {
    private final ReentrantLock lock = new ReentrantLock(); // 添加锁
    // 添加新的行驶轨迹
    @Override
    public void addAnalysis(Travelpath travelpath) {
        String sql = "INSERT INTO travelpaths (userId, vehicleId, startTime, endTime, pathData, distance) VALUES (?, ?, ?, ?, ST_GeomFromText(?), ?)";
        lock.lock(); // 加锁
        try (Connection connection = Util.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, travelpath.getUserId());
            statement.setInt(2, travelpath.getVehicleId());
            statement.setTimestamp(3, travelpath.getStartTime());
            statement.setTimestamp(4, travelpath.getEndTime());
            statement.setString(5, travelpath.getPathData()); // 直接使用WKT格式的字符串
            statement.setBigDecimal(6, travelpath.getDistance());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }finally {
            lock.unlock(); // 释放锁
        }
    }

    // 根据轨迹ID获取行驶轨迹
    @Override
    public Travelpath getAnalysisById(int pathId) {
        lock.lock();
        String sql = "SELECT pathId, userId, vehicleId, startTime, endTime, ST_AsText(pathData) AS pathData, distance, createdAt FROM travelpaths WHERE pathId = ?";
        Travelpath travelpath = null;
        try (Connection connection = Util.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, pathId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                travelpath = new Travelpath();
                travelpath.setPathId(resultSet.getInt("pathId"));
                travelpath.setUserId(resultSet.getLong("userId"));
                travelpath.setVehicleId(resultSet.getInt("vehicleId"));
                travelpath.setStartTime(resultSet.getTimestamp("startTime"));
                travelpath.setEndTime(resultSet.getTimestamp("endTime"));
                travelpath.setPathData(resultSet.getString("pathData")); // 获取WKT格式的字符串
                travelpath.setDistance(resultSet.getBigDecimal("distance"));
                travelpath.setCreatedAt(resultSet.getTimestamp("createdAt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }finally {
            lock.unlock(); // 释放锁
        }
        return travelpath;
    }

    // 获取某个用户的所有行驶轨迹
    @Override
    public Travelpaths getAnalysesByUserId(long userId) {
        lock.lock();
       Travelpaths travelpaths = new Travelpaths();
        try (Connection connection = Util.getConnection()) {
            String sql = "SELECT pathid, userid, vehicleid, starttime, endtime, ST_AsText(pathdata) AS pathData, distance, createdat FROM travelpaths WHERE userId = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setLong(1, userId);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Travelpath travelpath = new Travelpath();
                travelpath.setPathId(resultSet.getInt("pathid"));
                travelpath.setUserId(resultSet.getLong("userid"));
                travelpath.setVehicleId(resultSet.getInt("vehicleid"));
                travelpath.setStartTime(resultSet.getTimestamp("starttime"));
                travelpath.setEndTime(resultSet.getTimestamp("endtime"));
                travelpath.setPathData(resultSet.getString("pathdata")); // 获取WKT格式的字符串
                travelpath.setDistance(resultSet.getBigDecimal("distance"));
                travelpath.setCreatedAt(resultSet.getTimestamp("createdat"));
                // 调试输出
                System.out.println("Adding travelpath: " + travelpath.getPathId());
                travelpaths.addTravelpath(travelpath);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        finally {
            lock.unlock(); // 释放锁
        }
        return travelpaths;
    }

    // 更新行驶轨迹信息
    @Override
    public void updateAnalysis(Travelpath travelpath) {
        lock.lock();
        String sql = "UPDATE travelpaths SET userId = ?, vehicleId = ?, startTime = ?, endTime = ?, pathData = ST_GeomFromText(?), distance = ? WHERE pathId = ?";
        try (Connection connection = Util.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, travelpath.getUserId());
            statement.setInt(2, travelpath.getVehicleId());
            statement.setTimestamp(3, travelpath.getStartTime());
            statement.setTimestamp(4, travelpath.getEndTime());
            statement.setString(5, travelpath.getPathData()); // 直接使用WKT格式的字符串
            statement.setBigDecimal(6, travelpath.getDistance());
            statement.setInt(7, travelpath.getPathId());
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            lock.unlock(); // 释放锁
        }
    }

    // 删除行驶轨迹
    @Override
    public void deleteAnalysis(int pathId) {
        lock.lock();
        String sql = "DELETE FROM travelpaths WHERE pathId = ?";
        try (Connection connection = Util.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, pathId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }finally {
            lock.unlock(); // 释放锁
        }
    }

    // 根据用户ID获取所有路径的distance和startTime
    @Override
    public Travelpaths getAnalysesDistanceAndStartTimeByUserId(long userId) {
        lock.lock();
        String sql = "SELECT pathId, distance, startTime FROM travelpaths WHERE userId = ?";
        Travelpaths travelpaths = new Travelpaths();
        try (Connection connection = Util.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, userId);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Travelpath travelpath = new Travelpath();
                travelpath.setPathId(resultSet.getInt("pathId"));
                travelpath.setDistance(resultSet.getBigDecimal("distance"));
                travelpath.setStartTime(resultSet.getTimestamp("startTime"));
                travelpaths.addTravelpath(travelpath);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            lock.unlock(); // 释放锁
        }
        return travelpaths;
    }
}
