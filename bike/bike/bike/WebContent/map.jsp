
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>地图显示</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/main.css">
    <script src="js/jquery-3.5.1.js"></script>
    <script src="js/bootstrap.js"></script>
    <!-- 使用你的高德地图API Key 和 安全密钥 -->
    <script type="text/javascript">
        window._AMapSecurityConfig = {
            securityJsCode: '7d138b8c0b284b0bce6f7c0202e4765d', // 填写您申请的高德安全密钥
        }
    </script>
    <script type="text/javascript"
            src="https://webapi.amap.com/maps?v=1.4.15&key=adaddc833efb9b37d1d544ada743cb08"></script>
</head>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">共享单车管理系统</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">共享单车管理系统</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
            <ul class="nav navbar-nav navbar-right">
                <li><a href="#">欢迎：<span style="color: yellow">${loginUser.username}</span></a></li>
                <li><a href="AuthServlet?action=logout">退出</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container-fluid">
    <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
            <!-- 侧边栏 -->
            <ul class="nav nav-sidebar">
                <li class="<%= "Map_active".equals(request.getParameter("active")) ? "active" : "" %>">
                    <a class="btn btn-line btn-rect btn-default" href="MapServlet?action=map">地图显示</a>
                </li>
                <li class="<%= "Notices_active".equals(request.getParameter("active")) ? "active" : "" %>">
                    <a class="btn btn-line btn-rect btn-default" href="NoticesServlet?action=notices">公告内容</a>
                </li>
                <li class="<%= "ViewRoutes_active".equals(request.getParameter("active")) ? "active" : "" %>">
                    <a class="btn btn-line btn-rect btn-default" href="AnalysisServlet?action=analysis">碳分析</a>
                </li>
            </ul>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div id="map-container" style="width: 100%; height: 600px;"></div>
            <div id="panel" style="width: 100%; height: 200px;"></div> <!-- 添加这个元素作为路径规划的结果面板 -->
            <button id="save-route" class="btn btn-primary" style="position: absolute; top: 10px; right: 10px;">保存路径</button>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        // 获取后台传递的数据
        var data = JSON.parse('${data}');
        var startPoint, endPoint, pathData, distance;

        // 初始化地图
        var map = new AMap.Map('map-container', {
            center: [114.3657, 30.5365], // 武汉大学的坐标
            zoom: 15 // 缩放级别
        });

        // 添加控件
        AMap.plugin(['AMap.ToolBar', 'AMap.Scale'], function () {
            map.addControl(new AMap.ToolBar());
            map.addControl(new AMap.Scale());
        });

        // 添加停车区域
        var parkingAreas = [];
        data.parkingAreas.forEach(function (area) {
            var path = area.area.coordinates[0].map(function (coord) {
                return new AMap.LngLat(coord[0], coord[1]);
            });
            var polygon = new AMap.Polygon({
                path: path,
                fillColor: '#00eeff',
                borderWeight: 1,
                strokeColor: '#00eeff',
                strokeWeight: 2,
                fillOpacity: 0.4,
            });
            polygon.setExtData(area);
            parkingAreas.push(polygon);
            map.add(polygon);
        });

        // 添加车辆
        var markers = [];
        data.vehicles.forEach(function (vehicle) {
            var marker = new AMap.Marker({
                position: [vehicle.location.coordinates[0], vehicle.location.coordinates[1]],
                title: vehicle.licensePlate,
                icon: new AMap.Icon({
                    size: new AMap.Size(40, 50), // 图标大小
                    image: 'https://webapi.amap.com/theme/v1.3/markers/n/mark_b.png' // 图标 URL
                }),
                map: map
            });
            marker.setExtData(vehicle);
            markers.push(marker);
        });

        markers.forEach(function (marker) {
            marker.on('click', function (e) {
                if (!startPoint) {
                    startPoint = e.lnglat;
                    alert('起点已设置');
                } else {
                    alert('请设置终点为停车区域内部');
                }
            });
        });

        parkingAreas.forEach(function (polygon) {
            polygon.on('click', function (e) {
                if (!startPoint) {
                    alert('请先设置起点为车辆位置');
                } else {
                    endPoint = e.lnglat;
                    alert('终点已设置');
                    // 进行路径规划
                    planRoute(startPoint, endPoint);
                }
            });
        });

        function planRoute(start, end) {
            AMap.plugin('AMap.Driving', function () {
                var driving = new AMap.Driving({
                    map: map,
                    panel: "panel", // 渲染结果的面板
                    extensions: 'all' // 传递服务端加密校验码
                });
                // 根据起终点经纬度规划驾车路线
                driving.search(start, end, function (status, result) {
                    if (status === 'complete') {
                        console.log('绘制路线完成');
                        pathData = result.routes[0].steps.map(step => step.path).flat();
                        distance = result.routes[0].distance;
                    } else {
                        console.error('获取数据失败：' + result);
                    }
                });
            });
        }

        $('#save-route').on('click', function () {
            var username = "${loginUser.username}";
            // 发送用户名到后端并获取用户ID
            $.ajax({
                url: 'UserServlet?action=id',
                method: 'GET',
                data: { username: username },
                success: function(response) {
                    if (response.userid) {
                        var userid = response.userid;
                        console.log('UserID:', userid);

                        // 确保路径数据已存在
                        if (pathData && startPoint && endPoint) {
                            var routeData = {
                                userid: userid,
                                vehicleid: 21,
                                starttime: new Date().toISOString(),
                                endtime: new Date().toISOString(),
                                pathdata: JSON.stringify({
                                    type: "LineString",
                                    coordinates: pathData.map(point => [point.lng, point.lat])
                                }),
                                distance: distance
                            };

                            // 在第一个请求成功后发送保存路径的请求
                            $.ajax({
                                url: 'MapServlet?action=saveRoute',
                                method: 'POST',
                                contentType: 'application/json',
                                data: JSON.stringify(routeData),
                                success: function (response) {
                                    alert('路径保存成功');
                                },
                                error: function (xhr, status, error) {
                                    console.error('保存路径失败：', error);
                                    alert('保存路径失败');
                                }
                            });
                        } else {
                            alert('请先完成路径规划');
                        }
                    } else {
                        alert('获取用户ID失败');
                    }
                },
                error: function (xhr, status, error) {
                    console.error('获取用户ID失败：', error);
                    alert('获取用户ID失败');
                }
            });
        });
    });
</script>
</body>
</html>
