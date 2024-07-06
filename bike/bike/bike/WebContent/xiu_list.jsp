<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>报修管理</title>
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
                <jsp:param value="active" name="Xiu_active"/>
            </jsp:include>
        </div>
        <br>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="row">
                <div class="col-sm-7">
                    <div class="input-group">
                        <input class="form-control" type="hidden" id="searchColumn" name="searchColumn" value="xiu_name"/>
                        <input class="form-control" type="text" id="search_keyword" name="search_keyword" placeholder="单车编号"/> <span class="input-group-btn"><button class="btn btn-line btn-rect btn-warning" type="button" onclick="searchList()">搜索</button></span>
                    </div>
                </div>
                <div class="col-sm-5">
                    <button type="button" <c:if test="${loginUser.userType != '管理员'}">disabled="disabled" title="没有权限！！！"</c:if> class="btn btn-line btn-rect btn-success" data-toggle="modal" data-target="#modal-add">添加报修
                    </button>
                </div>
            </div>
            <br>
            <br>
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                    <tr>
                            <th>单车编号</th>
                            <th>报修内容</th>
                            <th>报修时间</th>
                            <th>处理时间</th>
                            <th>维修人员</th>
                            <th>联系方式</th>
                            <th>状态</th>
                            <th>备注</th>
                        <th style="text-align: center;">操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${list}" var="vo">
                        <tr>
                <td>${vo.xiuName}</td>
                <td>${vo.xiuReason}</td>
                <td>${vo.xiuDate}</td>
                <td>${vo.xiuHandledate}</td>
                <td>${vo.xiuRen}</td>
                <td>${vo.xiuPhone}</td>
                <td>${vo.xiuStatus}</td>
                <td title="${vo.xiuText}">
                <c:choose>
                    <c:when test="${fn:length(vo.xiuText) > 19}">
                        <c:out value="${fn:substring(vo.xiuText, 0, 19)}..."/>
                    </c:when>
                    <c:otherwise>
                        <c:out value="${vo.xiuText}"/>
                    </c:otherwise>
                </c:choose>
                </td>
                            <th style="text-align: center;">
                                <button class="btn btn-line btn-rect btn-success btn-sm" data-id="${vo.id}"
                                        data-toggle="modal" data-target="#modal-info">详情
                                </button>
                                <button class="btn btn-line btn-rect btn-danger btn-sm"
                                                <c:if test="${loginUser.userType != '管理员'}">disabled="disabled" title="没有权限！！！"</c:if>
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
            <form action="XiuServlet" onsubmit="return addCheck()">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"
                            aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">增加报修</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group hidden">
                        <label class="control-label">(hidden)</label>
                        <input type="text" class="form-control" name="action" value="add">
                    </div>
                    <div class="form-group">
                        <label for="add-xiuName" class="control-label">单车编号:</label>
                        <input type="text" class="form-control" name="xiuName" id="add-xiuName">
                    </div>
                    <div class="form-group">
                        <label for="add-xiuReason" class="control-label">报修内容:</label>
                        <input type="text" class="form-control" name="xiuReason" id="add-xiuReason">
                    </div>
                    <div class="form-group">
                        <label for="add-xiuDate" class="control-label">报修时间:</label>
                        <input type="text" class="form-control" name="xiuDate" id="add-xiuDate">
                    </div>
                    <div class="form-group">
                        <label for="add-xiuHandledate" class="control-label">处理时间:</label>
                        <input type="text" class="form-control" name="xiuHandledate" id="add-xiuHandledate">
                    </div>
                    <div class="form-group">
                        <label for="add-xiuRen" class="control-label">维修人员:</label>
                        <input type="text" class="form-control" name="xiuRen" id="add-xiuRen">
                    </div>
                    <div class="form-group">
                        <label for="add-xiuPhone" class="control-label">联系方式:</label>
                        <input type="text" class="form-control" name="xiuPhone" id="add-xiuPhone">
                    </div>
                    <div class="form-group">
                        <label class="control-label">状态:</label>
                        <input name="xiuStatus" id="add-xiuStatus_已处理" type="radio" value="已处理" checked="checked"/>已处理
                        <input name="xiuStatus" id="add-xiuStatus_待处理" type="radio" value="待处理"/>待处理
                    </div>
                    <div class="form-group">
                        <label for="add-xiuText" class="control-label">备注:</label>
                        <textarea style="height: 100px;" class="form-control" name="xiuText" id="add-xiuText"></textarea>
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
                    <h4 class="modal-title">报修</h4>
                </div>
                <div class="modal-body">
                    <table class="table table-striped table-hover" style="font-size: 15px;">
                        <tr>
                            <td style="width: 15%;">单车编号:</td>
                            <td><b id="info-xiuName"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">报修内容:</td>
                            <td><b id="info-xiuReason"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">报修时间:</td>
                            <td><b id="info-xiuDate"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">处理时间:</td>
                            <td><b id="info-xiuHandledate"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">维修人员:</td>
                            <td><b id="info-xiuRen"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">联系方式:</td>
                            <td><b id="info-xiuPhone"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">状态:</td>
                            <td><b id="info-xiuStatus"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">备注:</td>
                            <td><b id="info-xiuText"></b></td>
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
            <form action="XiuServlet" onsubmit="return editCheck()">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">更新报修</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group hidden">
                        <label class="control-label">(hidden)</label>
                        <input type="text" class="form-control" name="action" value="edit">
                        <input type="text" readonly class="form-control" name="id" id="edit-id">
                    </div>
                    <div class="form-group">
                        <label for="edit-xiuName" class="control-label">单车编号:</label>
                        <input type="text" class="form-control" name="xiuName" id="edit-xiuName">
                    </div>
                    <div class="form-group">
                        <label for="edit-xiuReason" class="control-label">报修内容:</label>
                        <input type="text" class="form-control" name="xiuReason" id="edit-xiuReason">
                    </div>
                    <div class="form-group">
                        <label for="edit-xiuDate" class="control-label">报修时间:</label>
                        <input type="text" class="form-control" name="xiuDate" id="edit-xiuDate">
                    </div>
                    <div class="form-group">
                        <label for="edit-xiuHandledate" class="control-label">处理时间:</label>
                        <input type="text" class="form-control" name="xiuHandledate" id="edit-xiuHandledate">
                    </div>
                    <div class="form-group">
                        <label for="edit-xiuRen" class="control-label">维修人员:</label>
                        <input type="text" class="form-control" name="xiuRen" id="edit-xiuRen">
                    </div>
                    <div class="form-group">
                        <label for="edit-xiuPhone" class="control-label">联系方式:</label>
                        <input type="text" class="form-control" name="xiuPhone" id="edit-xiuPhone">
                    </div>
                    <div class="form-group">
                        <label class="control-label">状态:</label>
                               <input name="xiuStatus" id="edit-xiuStatus_已处理" type="radio" value="已处理"/>已处理
                               <input name="xiuStatus" id="edit-xiuStatus_待处理" type="radio" value="待处理"/>待处理
                    </div>
                    <div class="form-group">
                        <label for="edit-xiuText" class="control-label">备注:</label>
                        <textarea style="height: 100px;" class="form-control" name="xiuText" id="edit-xiuText"></textarea>
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
            <form action="XiuServlet">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">删除报修</h4>
                </div>
                <div class="modal-body">
                    确认要删除该报修记录吗？
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
            url: 'XiuServlet?action=get&id=' + id,
            type: "get",
            success: function (voString) {
                let vo = eval('(' + voString + ')');
                        modal.find('#edit-id').val(vo.id);
                        modal.find('#edit-xiuName').val(vo.xiuName);
                        modal.find('#edit-xiuReason').val(vo.xiuReason);
                        modal.find('#edit-xiuDate').val(vo.xiuDate);
                        modal.find('#edit-xiuHandledate').val(vo.xiuHandledate);
                        modal.find('#edit-xiuRen').val(vo.xiuRen);
                        modal.find('#edit-xiuPhone').val(vo.xiuPhone);
                        for (let val of "已处理/待处理".split('/')) {
                            if (val == vo.xiuStatus) {
                                modal.find('#edit-xiuStatus_' + vo.xiuStatus).prop("checked", true);
                            } else {
                                modal.find('#edit-xiuStatus_' + vo.xiuStatus).removeAttr("checked");
                            }
                        };
                        modal.find('#edit-xiuText').val(vo.xiuText);
            }
        })
    })
    $('#modal-info').on('show.bs.modal', function (event) {
        let button = $(event.relatedTarget);
        let id = button.data('id');
        let modal = $(this);
        $.ajax({
            url: 'XiuServlet?action=get&id=' + id,
            type: "get",
            success: function (voString) {
                let vo = eval('(' + voString + ')');
                modal.find('#info-xiuName').text(vo.xiuName);
                modal.find('#info-xiuReason').text(vo.xiuReason);
                modal.find('#info-xiuDate').text(vo.xiuDate);
                modal.find('#info-xiuHandledate').text(vo.xiuHandledate);
                modal.find('#info-xiuRen').text(vo.xiuRen);
                modal.find('#info-xiuPhone').text(vo.xiuPhone);
                modal.find('#info-xiuStatus').text(vo.xiuStatus);
                modal.find('#info-xiuText').text(vo.xiuText);
            }
        })
    })
    function searchList() {
        window.location.href = "XiuServlet?action=list&searchColumn="+document.getElementById("searchColumn").value+"&keyword=" + document.getElementById("search_keyword").value;
    }
    //增加表单提交之前进行检查，如果return false，则不允许提交
    function addCheck() {
        //根据ID获取值
        if (document.getElementById("add-xiuName").value.trim().length == 0) {
            alert("单车编号不能为空");
            return false;
        }
        if (document.getElementById("add-xiuReason").value.trim().length == 0) {
            alert("报修内容不能为空");
            return false;
        }
        if (document.getElementById("add-xiuDate").value.trim().length == 0) {
            alert("报修时间不能为空");
            return false;
        }
        if (document.getElementById("add-xiuHandledate").value.trim().length == 0) {
            alert("处理时间不能为空");
            return false;
        }
        if (document.getElementById("add-xiuRen").value.trim().length == 0) {
            alert("维修人员不能为空");
            return false;
        }
        if (document.getElementById("add-xiuPhone").value.trim().length == 0) {
            alert("联系方式不能为空");
            return false;
        }
        return true;
    }
    //编辑表单提交之前进行检查，如果return false，则不允许提交
    function editCheck() {
        //根据ID获取值
        if (document.getElementById("edit-xiuName").value.trim().length == 0) {
            alert("单车编号不能为空");
            return false;
        }
        if (document.getElementById("edit-xiuReason").value.trim().length == 0) {
            alert("报修内容不能为空");
            return false;
        }
        if (document.getElementById("edit-xiuDate").value.trim().length == 0) {
            alert("报修时间不能为空");
            return false;
        }
        if (document.getElementById("edit-xiuHandledate").value.trim().length == 0) {
            alert("处理时间不能为空");
            return false;
        }
        if (document.getElementById("edit-xiuRen").value.trim().length == 0) {
            alert("维修人员不能为空");
            return false;
        }
        if (document.getElementById("edit-xiuPhone").value.trim().length == 0) {
            alert("联系方式不能为空");
            return false;
        }
        return true;
    }
</script>
</html>
