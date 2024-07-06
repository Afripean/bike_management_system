<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户管理</title>
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
            <jsp:include page="admin_menu.jsp">
                <jsp:param value="active" name="User_active"/>
            </jsp:include>
        </div>
        <br>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="row">
                <div class="col-sm-7">
                    <div class="input-group">
                        <input class="form-control" type="hidden" id="searchColumn" name="searchColumn" value="real_name"/>
                        <input class="form-control" type="text" id="search_keyword" name="search_keyword" placeholder="姓名"/> <span class="input-group-btn"><button class="btn btn-line btn-rect btn-warning" type="button" onclick="searchList()">搜索</button></span>
                    </div>
                </div>
                <div class="col-sm-5">
                    <button type="button" <c:if test="${loginUser.userType != '管理员'}">disabled="disabled" title="没有权限！！！"</c:if> class="btn btn-line btn-rect btn-success" data-toggle="modal" data-target="#modal-add">添加用户
                    </button>
                </div>
            </div>
            <br>
            <br>
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                    <tr>
                            <th>用户名</th>
                            <th>姓名</th>
                            <th>性别</th>
                            <th>手机</th>
                            <th>备注</th>
                            <th>类型</th>
                        <th style="text-align: center;">操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${list}" var="vo">
                        <tr>
                <td>${vo.username}</td>
                <td>${vo.realName}</td>
                <td>${vo.userSex}</td>
                <td>${vo.userPhone}</td>
                <td title="${vo.userText}">
                <c:choose>
                    <c:when test="${fn:length(vo.userText) > 19}">
                        <c:out value="${fn:substring(vo.userText, 0, 19)}..."/>
                    </c:when>
                    <c:otherwise>
                        <c:out value="${vo.userText}"/>
                    </c:otherwise>
                </c:choose>
                </td>
                <td>${vo.userType}</td>
                            <th style="text-align: center;">
                                <button class="btn btn-line btn-rect btn-success btn-sm" data-id="${vo.id}"
                                        data-toggle="modal" data-target="#modal-info">详情
                                </button>
                                <button class="btn btn-line btn-rect btn-danger btn-sm"
                                                <c:if test="${loginUser.userType != '管理员' && vo.id != loginUser.id}">disabled="disabled" title="没有权限！！！"</c:if>
                                        data-id="${vo.id}"
                                        data-toggle="modal" data-target="#modal-edit">编辑
                                </button>
                                <button class="btn btn-line btn-rect btn-default btn-sm" <c:if test="${loginUser.userType != '管理员'}">disabled="disabled" title="没有权限！！！"</c:if> data-id="${vo.id}"
                                        data-toggle="modal" data-target="#modal-delete">删除
                                </button>
                            </th>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
            <div style="float: right;padding-right: 10px;color: #515151;"><jsp:include page="split.jsp"/></div>
        </div>
    </div>
</div>

<!-- add -->
<div class="modal fade" id="modal-add" tabindex="-1" role="dialog"
     aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form action="AdminServlet" onsubmit="return addCheck()">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"
                            aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">增加用户</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group hidden">
                        <label class="control-label">(hidden)</label>
                        <input type="text" class="form-control" name="action" value="add">
                    </div>
                    <div class="form-group">
                        <label for="add-username" class="control-label">用户名:</label>
                        <input type="text" class="form-control" name="username" id="add-username">
                    </div>
                    <div class="form-group">
                        <label for="add-password" class="control-label">密码:</label>
                        <input type="text" class="form-control" name="password" id="add-password">
                    </div>
                    <div class="form-group">
                        <label for="add-realName" class="control-label">姓名:</label>
                        <input type="text" class="form-control" name="realName" id="add-realName">
                    </div>
                    <div class="form-group">
                        <label class="control-label">性别:</label>
                        <input name="userSex" id="add-userSex_男" type="radio" value="男" checked="checked"/>男
                        <input name="userSex" id="add-userSex_女" type="radio" value="女"/>女
                    </div>
                    <div class="form-group">
                        <label for="add-userPhone" class="control-label">手机:</label>
                        <input type="text" class="form-control" name="userPhone" id="add-userPhone">
                    </div>
                    <div class="form-group">
                        <label for="add-userText" class="control-label">备注:</label>
                        <textarea style="height: 100px;" class="form-control" name="userText" id="add-userText"></textarea>
                    </div>
                    <div class="form-group">
                        <label class="control-label">类型:</label>
                        <input name="userType" id="add-userType_管理员" type="radio" value="管理员" checked="checked"/>管理员
                        <input name="userType" id="add-userType_普通用户" type="radio" value="普通用户"/>普通用户
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-line btn-rect btn-default" data-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-line btn-rect btn-success">提交</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- info -->
<div class="modal fade" id="modal-info" tabindex="-1" role="dialog"
     aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form>
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">用户</h4>
                </div>
                <div class="modal-body">
                    <table class="table table-striped table-hover" style="font-size: 15px;">
                        <tr>
                            <td style="width: 15%;">用户名:</td>
                            <td><b id="info-username"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">姓名:</td>
                            <td><b id="info-realName"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">性别:</td>
                            <td><b id="info-userSex"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">手机:</td>
                            <td><b id="info-userPhone"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">备注:</td>
                            <td><b id="info-userText"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">类型:</td>
                            <td><b id="info-userType"></b></td>
                        </tr>
                    </table>
                    <br>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-line btn-rect btn-default" data-dismiss="modal">关闭</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- edit -->
<div class="modal fade" id="modal-edit" tabindex="-1" role="dialog"
     aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form action="AdminServlet" onsubmit="return editCheck()">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">更新用户</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group hidden">
                        <label class="control-label">(hidden)</label>
                        <input type="text" class="form-control" name="action" value="edit">
                        <input type="text" readonly class="form-control" name="id" id="edit-id">
                    </div>
                    <div class="form-group">
                        <label for="edit-username" class="control-label">用户名:</label>
                        <input type="text" class="form-control" name="username" id="edit-username">
                    </div>
                    <div class="form-group">
                        <label for="edit-password" class="control-label">密码:</label>
                        <input type="text" class="form-control" name="password" id="edit-password">
                    </div>
                    <div class="form-group">
                        <label for="edit-realName" class="control-label">姓名:</label>
                        <input type="text" class="form-control" name="realName" id="edit-realName">
                    </div>
                    <div class="form-group">
                        <label class="control-label">性别:</label>
                               <input name="userSex" id="edit-userSex_男" type="radio" value="男"/>男
                               <input name="userSex" id="edit-userSex_女" type="radio" value="女"/>女
                    </div>
                    <div class="form-group">
                        <label for="edit-userPhone" class="control-label">手机:</label>
                        <input type="text" class="form-control" name="userPhone" id="edit-userPhone">
                    </div>
                    <div class="form-group">
                        <label for="edit-userText" class="control-label">备注:</label>
                        <textarea style="height: 100px;" class="form-control" name="userText" id="edit-userText"></textarea>
                    </div>
                    <div class="form-group">
                        <label class="control-label">类型:</label>
                               <input <c:if test="${loginUser.userType != '管理员'}">disabled="disabled" title="没有权限！！！"</c:if> name="userType" id="edit-userType_管理员" type="radio" value="管理员"/>管理员
                               <input name="userType" id="edit-userType_普通用户" type="radio" value="普通用户"/>普通用户
                    </div>
                    <div class="form-group hidden">
                        <label for="edit-createTime" class="control-label">创建时间:</label>
                        <input type="text" class="form-control" name="createTime" id="edit-createTime">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-line btn-rect btn-default" data-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-line btn-rect btn-success">提交</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- delete -->
<div class="modal fade" id="modal-delete" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form action="AdminServlet">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">删除用户</h4>
                </div>
                <div class="modal-body">
                    确认要删除该用户记录吗？
                    <div class="form-group hidden">
                        <label class="control-label">(hidden)</label>
                        <input type="hidden" class="form-control" name="action" value="delete">
                        <input type="text" class="form-control" name="id" id="delete-id">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-line btn-rect btn-default" data-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-line btn-rect btn-default">删除</button>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
<script>
    $('#modal-delete').on('show.bs.modal', function (event) {
        let button = $(event.relatedTarget);
        let id = button.data('id');
        let modal = $(this);
        modal.find('#delete-id').val(id);
    })

    $('#modal-edit').on('show.bs.modal', function (event) {
        let button = $(event.relatedTarget);
        let id = button.data('id');
        let modal = $(this);
        $.ajax({
            url: 'AdminServlet?action=get&id=' + id,
            type: "get",
            success: function (voString) {
                let vo = eval('(' + voString + ')');
                        modal.find('#edit-id').val(vo.id);
                        modal.find('#edit-username').val(vo.username);
                        modal.find('#edit-password').val(vo.password);
                        modal.find('#edit-realName').val(vo.realName);
                        for (let val of "男/女".split('/')) {
                            if (val == vo.userSex) {
                                modal.find('#edit-userSex_' + vo.userSex).prop("checked", true);
                            } else {
                                modal.find('#edit-userSex_' + vo.userSex).removeAttr("checked");
                            }
                        };
                        modal.find('#edit-userPhone').val(vo.userPhone);
                        modal.find('#edit-userText').val(vo.userText);
                        for (let val of "管理员/普通用户".split('/')) {
                            if (val == vo.userType) {
                                modal.find('#edit-userType_' + vo.userType).prop("checked", true);
                            } else {
                                modal.find('#edit-userType_' + vo.userType).removeAttr("checked");
                            }
                        };
            }
        })
    })
    $('#modal-info').on('show.bs.modal', function (event) {
        let button = $(event.relatedTarget);
        let id = button.data('id');
        let modal = $(this);
        $.ajax({
            url: 'AdminServlet?action=get&id=' + id,
            type: "get",
            success: function (voString) {
                let vo = eval('(' + voString + ')');
                modal.find('#info-username').text(vo.username);
                modal.find('#info-password').text(vo.password);
                modal.find('#info-realName').text(vo.realName);
                modal.find('#info-userSex').text(vo.userSex);
                modal.find('#info-userPhone').text(vo.userPhone);
                modal.find('#info-userText').text(vo.userText);
                modal.find('#info-userType').text(vo.userType);
            }
        })
    })
    function searchList() {
        window.location.href = "AdminServlet?action=list&searchColumn="+document.getElementById("searchColumn").value+"&keyword=" + document.getElementById("search_keyword").value;
    }
    //增加表单提交之前进行检查，如果return false，则不允许提交
    function addCheck() {
        //根据ID获取值
        if (document.getElementById("add-username").value.trim().length == 0) {
            alert("用户名不能为空");
            return false;
        }
        if (document.getElementById("add-password").value.trim().length == 0) {
            alert("密码不能为空");
            return false;
        }
        if (document.getElementById("add-realName").value.trim().length == 0) {
            alert("姓名不能为空");
            return false;
        }
        if (document.getElementById("add-userPhone").value.trim().length == 0) {
            alert("手机不能为空");
            return false;
        }
        return true;
    }
    //编辑表单提交之前进行检查，如果return false，则不允许提交
    function editCheck() {
        //根据ID获取值
        if (document.getElementById("edit-username").value.trim().length == 0) {
            alert("用户名不能为空");
            return false;
        }
        if (document.getElementById("edit-password").value.trim().length == 0) {
            alert("密码不能为空");
            return false;
        }
        if (document.getElementById("edit-realName").value.trim().length == 0) {
            alert("姓名不能为空");
            return false;
        }
        if (document.getElementById("edit-userPhone").value.trim().length == 0) {
            alert("手机不能为空");
            return false;
        }
        return true;
    }
</script>
</html>
