package com.demo.service.impl;

import com.demo.dao.VehicleDAO;
import com.demo.dao.impl.VehicleDAOImpl;
import com.demo.service.VehicleService;
import com.demo.vo.Vehicle;
import com.google.gson.Gson;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class VehicleServiceImpl implements VehicleService {


    public void addVehicle(Vehicle vo){
        VehicleDAO vehicleDAO=new VehicleDAOImpl();
        vehicleDAO.addVehicle(vo);
    }


    public void updateVehicle(Vehicle vo) {
        VehicleDAO vehicleDAO=new VehicleDAOImpl();
        vehicleDAO.updateVehicle(vo);
    }


    public void deleteVehicle(int id) {
        VehicleDAO vehicleDAO=new VehicleDAOImpl();
        vehicleDAO.deleteVehicle(id);
    }

    public List<Vehicle> listVehicles() {
        VehicleDAO vehicleDAO=new VehicleDAOImpl();
        return vehicleDAO.listVehicles();
    }
}
