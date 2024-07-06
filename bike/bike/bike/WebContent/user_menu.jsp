<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<ul class="nav nav-sidebar">
    <%--    <li class="<c:if test="${param.active == 'User_active'}">active</c:if>">--%>
    <%--        <a href="UserServlet?action=list"><i class="glyphicon glyphicon-user"></i> 用户管理</a>--%>
    <%--    </li>--%>
    <%--    <li class="<c:if test="${param.active == 'Bicycle_active'}">active</c:if>">--%>
    <%--        <a href="BicycleServlet?action=list"><i class="glyphicon glyphicon-wrench"></i> 单车管理</a>--%>
    <%--    </li>--%>
    <%--    <li class="<c:if test="${param.active == 'Mend_active'}">active</c:if>">--%>
    <%--        <a href="MendServlet?action=list"><i class="glyphicon glyphicon-wrench"></i> 报修管理</a>--%>
    <%--    </li>--%>
    <%--    <li class="<c:if test="${param.active == 'Notice_active'}">active</c:if>">--%>
    <%--        <a href="NoticeServlet?action=list"><i class="glyphicon glyphicon-bullhorn"></i> 公告管理</a>--%>
    <%--    </li>--%>

    <li class="<%= "Map_active".equals(request.getParameter("active")) ? "active" : "" %>">
        <a class="btn btn-line btn-rect btn-default" href="UserServlet?action=map">地图显示</a>
    </li>
    <li class="<%= "Notices_active".equals(request.getParameter("active")) ? "active" : "" %>">
        <a class="btn btn-line btn-rect btn-default" href="UserServlet?action=notices">公告内容</a>
    </li>
    <!--<li class="<%=request.getParameter("introduce_active")%>"><a class="btn btn-line btn-rect btn-default" href="introduce.jsp">关于</a></li>-->
</ul>
