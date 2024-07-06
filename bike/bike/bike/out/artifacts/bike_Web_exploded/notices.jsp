<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>公告内容</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/main.css">
    <script src="js/jquery-3.5.1.js"></script>
    <script src="js/bootstrap.js"></script>
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
            <h1>公告内容</h1>
            <h2>新闻推送</h2>
            <div id="news-container" class="list-group"></div>
            <h2>系统公告</h2>
            <div id="system-container" class="list-group"></div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        console.log('Document ready');
        var data;
        try {
            data = JSON.parse('<%= request.getAttribute("data").toString().replaceAll("\n", "\\\\n").replaceAll("\r", "\\\\r").replaceAll("\'", "\\\\\'").replaceAll("\"", "\\\\\"") %>');
            console.log('Data parsed successfully:', data);
        } catch (e) {
            console.error('Failed to parse data:', e);
            return;
        }

        var newsContainer = $('#news-container');
        var systemContainer = $('#system-container');

        data.forEach(function (notice) {
            var noticeItem = $('<div class="list-group-item"></div>');
            var noticeTitle = $('<h4 class="list-group-item-heading"></h4>').text(notice.notice_name);
            var noticeText;
            if (notice.notice_type === "1") {
                noticeText = $('<a class="list-group-item-text" target="_blank"></a>').attr('href', notice.notice_text).text('点击查看详情');
            } else if (notice.notice_type === "2") {
                noticeText = $('<p class="list-group-item-text"></p>').text(notice.notice_text);
            }
            noticeItem.append(noticeTitle).append(noticeText);
            if (notice.notice_type === "1") {
                newsContainer.append(noticeItem);
            } else if (notice.notice_type === "2") {
                systemContainer.append(noticeItem);
            }
        });
    });
</script>
</body>
</html>