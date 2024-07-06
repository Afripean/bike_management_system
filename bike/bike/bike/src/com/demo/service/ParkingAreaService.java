package com.demo.service;

import com.demo.vo.ParkingArea;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public interface ParkingAreaService {
    void addParkingArea(ParkingArea vo);
    void updateParkingArea(ParkingArea vo);
    void deleteParkingArea(int id);
    List<ParkingArea> listParkingAreas();
}
