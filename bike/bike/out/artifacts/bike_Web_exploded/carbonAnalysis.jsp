<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.demo.vo.Travelpath" %>
<%@ page import="com.demo.vo.Travelpaths" %>
<%@ page import="java.math.BigDecimal" %>

<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Carbon Analysis</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/main.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
<div class="container">
    <h1>Carbon Analysis</h1>
    <%
        String processed = request.getParameter("processed");
        if (processed == null) {
    %>
    <form id="carbonForm" method="post" action="AnalysisServlet">
        <input type="hidden" name="action" value="analysis">
        <input type="hidden" name="name" value="${loginUser.username}">
        <input type="hidden" name="processed" value="true">
    </form>
    <script>
        document.getElementById('carbonForm').submit();
    </script>
    <%
        } else {
            Travelpaths travelPathsObj = (Travelpaths) request.getAttribute("travelPaths");
            if (travelPathsObj != null) {
                List<Travelpath> travelPathsList = travelPathsObj.getTravelpathList();
                BigDecimal totalDistance = BigDecimal.ZERO;
                Map<String, BigDecimal> monthlyDistances = new HashMap<>();
                Map<String, Integer> monthlyCounts = new HashMap<>();

                for (Travelpath travelPath : travelPathsList) {
                    if (travelPath != null) {
                        // 总距离
                        totalDistance = totalDistance.add(travelPath.getDistance());

                        // 按月统计
                        String month = new java.text.SimpleDateFormat("yyyy-MM").format(travelPath.getStartTime());
                        monthlyDistances.put(month, monthlyDistances.getOrDefault(month, BigDecimal.ZERO).add(travelPath.getDistance()));
                        monthlyCounts.put(month, monthlyCounts.getOrDefault(month, 0) + 1);
                    }
                }

                // 假设每公里骑行共享电动车可以节省 0.2 千克碳排放
                BigDecimal carbonSaved = totalDistance.multiply(new BigDecimal("0.2"));
                // 假设制作一件衣服需要 1 千克碳排放
                int clothesMade = carbonSaved.intValue();

                out.print("<p>总距离: " + totalDistance + " 公里</p>");
                out.print("<p>总共节省的碳排放: " + carbonSaved + " 千克</p>");
                out.print("<p>这些碳排放可以制作 " + clothesMade + " 件衣服</p>");

                // 转换数据为 JavaScript 格式
                out.print("<script>");
                out.print("var monthlyDistances = " + new com.google.gson.Gson().toJson(monthlyDistances) + ";");
                out.print("var monthlyCounts = " + new com.google.gson.Gson().toJson(monthlyCounts) + ";");
                out.print("</script>");
            } else {
                out.print("<script>");

                out.print("var monthlyDistances = {};");
                out.print("var monthlyCounts = {};");
                out.print("</script>");
                processed = null;
            }
        }
    %>

    <!-- 添加用于展示组合图表的canvas元素 -->
    <canvas id="combinedChart" width="400" height="200"></canvas>
    <script>
        window.onload = function() {
            // 数据准备
            var monthlyDistanceLabels = Object.keys(monthlyDistances);
            var monthlyDistanceData = Object.values(monthlyDistances);
            var monthlyCountLabels = Object.keys(monthlyCounts);
            var monthlyCountData = Object.values(monthlyCounts);

            // 检查两个数据集的标签是否一致
            if (monthlyDistanceLabels.toString() !== monthlyCountLabels.toString()) {
                console.error('月度距离数据和月度次数数据的标签不一致');
            }

            // 获取绘图上下文
            var ctx = document.getElementById('combinedChart').getContext('2d');

            // 创建组合图表
            var combinedChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: monthlyDistanceLabels, // 使用月度距离数据的标签
                    datasets: [
                        {
                            label: 'Monthly Distance',
                            data: monthlyDistanceData,
                            borderColor: 'rgba(75, 192, 192, 1)',
                            backgroundColor: 'rgba(75, 192, 192, 0.2)',
                            fill: true,
                            yAxisID: 'y1' // 使用左侧Y轴
                        },
                        {
                            label: 'Monthly Count',
                            data: monthlyCountData,
                            borderColor: 'rgba(153, 102, 255, 1)',
                            backgroundColor: 'rgba(153, 102, 255, 0.2)',
                            fill: true,
                            yAxisID: 'y2' // 使用右侧Y轴
                        }
                    ]
                },
                options: {
                    scales: {
                        y1: {
                            type: 'linear',
                            display: true,
                            position: 'left',
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Monthly Distance'
                            }
                        },
                        y2: {
                            type: 'linear',
                            display: true,
                            position: 'right',
                            beginAtZero: true,
                            grid: {
                                drawOnChartArea: false // 仅显示在右侧Y轴的网格线
                            },
                            title: {
                                display: true,
                                text: 'Monthly Count'
                            }
                        }
                    }
                }
            });
        };
    </script>

    <!-- 在HTML中添加一个用于展示组合图表的canvas元素 -->
    <canvas id="combinedChart" width="400" height="200"></canvas>

</div>
</body>
</html>
