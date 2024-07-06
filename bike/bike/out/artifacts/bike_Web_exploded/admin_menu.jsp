<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<ul class="nav nav-sidebar">
    <li class="<%=request.getParameter("User_active")%>"><a class="btn btn-line btn-rect btn-default" href="AdminServlet?action=list">用户管理</a></li>
    <li class="<%=request.getParameter("Region_active")%>"><a class="btn btn-line btn-rect btn-default" href="RegionServlet?action=manager">区域管理</a></li>
    <!--<li class="<%=request.getParameter("Che_active")%>"><a class="btn btn-line btn-rect btn-default" href="CheServlet?action=list">单车管理</a></li>
    <li class="<%=request.getParameter("Xiu_active")%>"><a class="btn btn-line btn-rect btn-default" href="XiuServlet?action=list">报修管理</a></li>-->
    <li class="<%=request.getParameter("Notice_active")%>"><a class="btn btn-line btn-rect btn-default" href="NoticeServlet?action=list">公告管理</a></li>

    <!--<li class="<%=request.getParameter("introduce_active")%>"><a class="btn btn-line btn-rect btn-default" href="introduce.jsp">关于</a></li>-->
</ul>
