package com.demo.dao;

import com.demo.vo.ParkingArea;
import java.util.List;

public interface ParkingAreaDAO {
    void addParkingArea(ParkingArea parkingArea);
    void updateParkingArea(ParkingArea parkingArea);
    void deleteParkingArea(int id);
    List<ParkingArea> listParkingAreas();
    List<ParkingArea> getParkingAreas() throws Exception;
}
