package com.demo.dao;

import com.demo.vo.Vehicle;
import com.demo.vo.Vehicle_user;

import java.util.List;

public interface VehicleDAO {
    void addVehicle(Vehicle vehicle);
    void updateVehicle(Vehicle vehicle);
    void deleteVehicle(int id);
    List<Vehicle> listVehicles();

    List<Vehicle_user> getVehicles() throws Exception;
}
