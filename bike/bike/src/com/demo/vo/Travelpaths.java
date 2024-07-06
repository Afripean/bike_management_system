package com.demo.vo;

import java.util.ArrayList;
import java.util.List;

public class Travelpaths {
    private List<Travelpath> travelpathList;

    public Travelpaths() {
        this.travelpathList = new ArrayList<>();
    }

    public List<Travelpath> getTravelpathList() {
        return travelpathList;
    }

    public void setTravelpathList(List<Travelpath> travelpathList) {
        this.travelpathList = travelpathList;
    }

    public void addTravelpath(Travelpath travelpath) {
        if (this.travelpathList == null) {
            this.travelpathList = new ArrayList<>();
        }
        this.travelpathList.add(travelpath);
    }
}
