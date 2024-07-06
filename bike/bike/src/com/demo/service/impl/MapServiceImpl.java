package com.demo.service.impl;

import com.demo.dao.ParkingAreaDAO;
import com.demo.dao.VehicleDAO;
import com.demo.dao.impl.ParkingAreaDAOImpl;
import com.demo.dao.impl.VehicleDAOImpl;
import com.demo.service.MapService;
import com.demo.vo.ParkingArea;
import com.demo.vo.Vehicle;
import com.demo.vo.Vehicle_user;

import java.util.List;

public class MapServiceImpl implements MapService {
    private final ParkingAreaDAO parkingAreaDAO = new ParkingAreaDAOImpl();
    private final VehicleDAO vehicleDAO = new VehicleDAOImpl();

    @Override
    public List<ParkingArea> getParkingAreas() throws Exception {
        return parkingAreaDAO.getParkingAreas();
    }

    @Override
    public List<Vehicle_user> getVehicles() throws Exception {
        return vehicleDAO.getVehicles();
    }
}
