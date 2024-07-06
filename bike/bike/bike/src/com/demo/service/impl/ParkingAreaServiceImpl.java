package com.demo.service.impl;

import com.demo.dao.ParkingAreaDAO;
import com.demo.dao.impl.ParkingAreaDAOImpl;
import com.demo.service.ParkingAreaService;
import com.demo.vo.ParkingArea;
import com.google.gson.Gson;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ParkingAreaServiceImpl implements ParkingAreaService {


    public void addParkingArea(ParkingArea vo){
        ParkingAreaDAO parkingAreaDAO=new ParkingAreaDAOImpl();
        parkingAreaDAO.addParkingArea(vo);
    }

    public void updateParkingArea(ParkingArea vo) {
        ParkingAreaDAO parkingAreaDAO=new ParkingAreaDAOImpl();
        parkingAreaDAO.updateParkingArea(vo);
    }


    public void deleteParkingArea(int id){
        ParkingAreaDAO parkingAreaDAO=new ParkingAreaDAOImpl();
        parkingAreaDAO.deleteParkingArea(id);
    }

    public List<ParkingArea> listParkingAreas() {
        ParkingAreaDAO parkingAreaDAO=new ParkingAreaDAOImpl();
        return parkingAreaDAO.listParkingAreas();
    }

}
