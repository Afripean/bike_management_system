package com.demo.vo;

import java.sql.Timestamp;

public class Vehicle {
    private int vehicleId;
    private String licensePlate;
    private String type;
    private String status;
    private String cheArea;
    private String cheDate;
    private String cheRen;
    private String chePhone;
    private String location;
    private String lastMaintenanceDate;
    private Timestamp createdAt;

    // getters and setters
    public int getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(int vehicleId) {
        this.vehicleId = vehicleId;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCheArea() {
        return cheArea;
    }

    public void setCheArea(String cheArea) {
        this.cheArea = cheArea;
    }

    public String getCheDate() {
        return cheDate;
    }

    public void setCheDate(String cheDate) {
        this.cheDate = cheDate;
    }

    public String getCheRen() {
        return cheRen;
    }

    public void setCheRen(String cheRen) {
        this.cheRen = cheRen;
    }

    public String getChePhone() {
        return chePhone;
    }

    public void setChePhone(String chePhone) {
        this.chePhone = chePhone;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getLastMaintenanceDate() {
        return lastMaintenanceDate;
    }

    public void setLastMaintenanceDate(String lastMaintenanceDate) {
        this.lastMaintenanceDate = lastMaintenanceDate;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

