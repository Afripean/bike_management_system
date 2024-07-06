package com.demo.service;

import com.demo.vo.Vehicle;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public interface VehicleService {
    void addVehicle(Vehicle vo);
    void updateVehicle(Vehicle vo);
    void deleteVehicle(int id);
    List<Vehicle> listVehicles();
}
