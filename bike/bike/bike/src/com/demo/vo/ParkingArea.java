package com.demo.vo;

import java.sql.Timestamp;
import java.util.Map;

public class ParkingArea {
    private int areaId;
    private Map<String, Object> area;
    private String areaName;
    private String areaGeoJson;
    private Timestamp createdAt;

    // Getters and Setters
    public int getAreaId() {
        return areaId;
    }

    public void setAreaId(int areaId) {
        this.areaId = areaId;
    }

    public String getAreaName() {
        return areaName;
    }

    public void setAreaName(String areaName) {
        this.areaName = areaName;
    }

    public String getAreaGeoJson() {
        return areaGeoJson;
    }

    public void setAreaGeoJson(String areaGeoJson) {
        this.areaGeoJson = areaGeoJson;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public void setArea(Map<String, Object> area) {
        this.area = area;
    }

}


