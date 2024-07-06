<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>查看轨迹</title>
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
                    <a class="btn btn-line btn-rect btn-default" href="UserServlet?action=map">地图显示</a>
                </li>
                <li class="<%= "Notices_active".equals(request.getParameter("active")) ? "active" : "" %>">
                    <a class="btn btn-line btn-rect btn-default" href="UserServlet?action=notices">公告内容</a>
                </li>
                <li class="<%= "ViewRoutes_active".equals(request.getParameter("active")) ? "active" : "" %>">
                    <a class="btn btn-line btn-rect btn-default" href="UserServlet?action=viewRoutes">查看轨迹</a>
                </li>
            </ul>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div id="map-container" style="width: 100%; height: 600px;"></div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        // 获取后台传递的数据
        var data;
        try {
            data = JSON.parse('${data}');
            console.log('Data parsed successfully:', data);
        } catch (e) {
            console.error('Failed to parse data:', e);
            return;
        }

        var map = new AMap.Map('map-container', {
            center: [114.3657, 30.5365], // 武汉大学的坐标
            zoom: 15 // 缩放级别
        });

        // 添加控件
        AMap.plugin(['AMap.ToolBar', 'AMap.Scale'], function () {
            map.addControl(new AMap.ToolBar());
            map.addControl(new AMap.Scale());
        });

        // 绘制路径
        data.forEach(function (route) {
            console.log('Processing route:', route);
            try {
                var pathData = JSON.parse(route.pathdata);
                console.log('Parsed path data:', pathData);
                var path = pathData.coordinates.map(function (coord) {
                    return new AMap.LngLat(coord[0], coord[1]);
                });
                var polyline = new AMap.Polyline({
                    path: path,
                    strokeColor: "#FF0000",
                    strokeWeight: 5,
                    strokeOpacity: 0.8,
                });
                polyline.setMap(map);
            } catch (e) {
                console.error('Error parsing pathdata for route:', route, e);
            }
        });
    });
</script>
</body>
</html>
