<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<>
<head>
    <meta charset="UTF-8">
    <title>说明</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/main.css">
    <script src="js/jquery-3.5.1.js"></script>
    <script src="js/bootstrap.js"></script>
</head>
<style>
    body{padding: 0;margin: 0;background: url("img/2.jpg") no-repeat;background-size: 100%;}
</style>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed"
                    data-toggle="collapse" data-target="#navbar" aria-expanded="false"
                    aria-controls="navbar">
                <span class="sr-only">共享单车管理系统</span> <span class="icon-bar"></span>
                <span class="icon-bar"></span> <span class="icon-bar"></span>
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
            <h1 class="page-header">关于我们</h1>
            <div>
                <div class="jumbotron">
                    <p>
                        作者：wy zsm cyr<br/>
                        whu2022<br/>
                        饭醉团伙<br/>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
