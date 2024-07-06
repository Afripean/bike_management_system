package com.demo.service;

import com.demo.vo.ParkingArea;
import com.demo.vo.Vehicle;
import com.demo.vo.Vehicle_user;

import java.util.List;

public interface MapService {
    List<ParkingArea> getParkingAreas() throws Exception;
    List<Vehicle_user> getVehicles() throws Exception;
}
