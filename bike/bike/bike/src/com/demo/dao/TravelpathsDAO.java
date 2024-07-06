package com.demo.dao;

import com.demo.vo.Travelpath;
import com.demo.vo.Travelpaths;
import java.util.List;

public interface TravelpathsDAO {
    // 添加新的行驶轨迹
    void addAnalysis(Travelpath travelpath);
    // 根据轨迹ID获取行驶轨迹
    Travelpath getAnalysisById(int pathId);
    // 获取某个用户的所有行驶轨迹
    Travelpaths getAnalysesByUserId(long userId);
    // 更新行驶轨迹信息
    void updateAnalysis(Travelpath travelpath);
    // 删除行驶轨迹
    void deleteAnalysis(int pathId);
    // 根据用户ID获取所有路径的distance和startTime
    Travelpaths getAnalysesDistanceAndStartTimeByUserId(long userId);
}
