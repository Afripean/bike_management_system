<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>单车管理</title>
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
                <jsp:param value="active" name="Che_active"/>
            </jsp:include>
        </div>
        <br>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="row">
                <div class="col-sm-7">
                    <div class="input-group">
                        <input class="form-control" type="hidden" id="searchColumn" name="searchColumn" value="che_name"/>
                        <input class="form-control" type="text" id="search_keyword" name="search_keyword" placeholder="编号"/> <span class="input-group-btn"><button class="btn btn-line btn-rect btn-warning" type="button" onclick="searchList()">搜索</button></span>
                    </div>
                </div>
                <div class="col-sm-5">
                    <button type="button" <c:if test="${loginUser.userType != '管理员'}">disabled="disabled" title="没有权限！！！"</c:if> class="btn btn-line btn-rect btn-success" data-toggle="modal" data-target="#modal-add">添加单车
                    </button>
                </div>
            </div>
            <br>
            <br>
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                    <tr>
                            <th>编号</th>
                            <th>投放区域</th>
                            <th>投放时间</th>
                            <th>区域负责人</th>
                            <th>联系方式</th>
                            <th>类型</th>
                            <th>维修点</th>
                            <th>状态</th>
                            <th>备注</th>
                        <th style="text-align: center;">操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${list}" var="vo">
                        <tr>
                <td>${vo.cheName}</td>
                <td>${vo.cheArea}</td>
                <td>${vo.cheDate}</td>
                <td>${vo.cheRen}</td>
                <td>${vo.chePhone}</td>
                <td>${vo.cheType}</td>
                <td>${vo.cheWei}</td>
                <td>${vo.cheStatus}</td>
                <td title="${vo.cheText}">
                <c:choose>
                    <c:when test="${fn:length(vo.cheText) > 19}">
                        <c:out value="${fn:substring(vo.cheText, 0, 19)}..."/>
                    </c:when>
                    <c:otherwise>
                        <c:out value="${vo.cheText}"/>
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
            <form action="CheServlet" onsubmit="return addCheck()">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"
                            aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">增加单车</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group hidden">
                        <label class="control-label">(hidden)</label>
                        <input type="text" class="form-control" name="action" value="add">
                    </div>
                    <div class="form-group">
                        <label for="add-cheName" class="control-label">编号:</label>
                        <input type="text" class="form-control" name="cheName" id="add-cheName">
                    </div>
                    <div class="form-group">
                        <label for="add-cheArea" class="control-label">投放区域:</label>
                        <input type="text" class="form-control" name="cheArea" id="add-cheArea">
                    </div>
                    <div class="form-group">
                        <label for="add-cheDate" class="control-label">投放时间:</label>
                        <input type="text" class="form-control" name="cheDate" id="add-cheDate">
                    </div>
                    <div class="form-group">
                        <label for="add-cheRen" class="control-label">区域负责人:</label>
                        <input type="text" class="form-control" name="cheRen" id="add-cheRen">
                    </div>
                    <div class="form-group">
                        <label for="add-chePhone" class="control-label">联系方式:</label>
                        <input type="text" class="form-control" name="chePhone" id="add-chePhone">
                    </div>
                    <div class="form-group">
                        <label class="control-label">类型:</label>
                        <input name="cheType" id="add-cheType_助力" type="radio" value="助力" checked="checked"/>助力
                        <input name="cheType" id="add-cheType_电动" type="radio" value="电动"/>电动
                    </div>
                    <div class="form-group">
                        <label for="add-cheWei" class="control-label">维修点:</label>
                        <input type="text" class="form-control" name="cheWei" id="add-cheWei">
                    </div>
                    <div class="form-group">
                        <label class="control-label">状态:</label>
                        <input name="cheStatus" id="add-cheStatus_正常" type="radio" value="正常" checked="checked"/>正常
                        <input name="cheStatus" id="add-cheStatus_损坏" type="radio" value="损坏"/>损坏
                        <input name="cheStatus" id="add-cheStatus_报废" type="radio" value="报废"/>报废
                    </div>
                    <div class="form-group">
                        <label for="add-cheText" class="control-label">备注:</label>
                        <textarea style="height: 100px;" class="form-control" name="cheText" id="add-cheText"></textarea>
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
                    <h4 class="modal-title">单车</h4>
                </div>
                <div class="modal-body">
                    <table class="table table-striped table-hover" style="font-size: 15px;">
                        <tr>
                            <td style="width: 15%;">编号:</td>
                            <td><b id="info-cheName"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">投放区域:</td>
                            <td><b id="info-cheArea"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">投放时间:</td>
                            <td><b id="info-cheDate"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">区域负责人:</td>
                            <td><b id="info-cheRen"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">联系方式:</td>
                            <td><b id="info-chePhone"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">类型:</td>
                            <td><b id="info-cheType"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">维修点:</td>
                            <td><b id="info-cheWei"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">状态:</td>
                            <td><b id="info-cheStatus"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">备注:</td>
                            <td><b id="info-cheText"></b></td>
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
            <form action="CheServlet" onsubmit="return editCheck()">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">更新单车</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group hidden">
                        <label class="control-label">(hidden)</label>
                        <input type="text" class="form-control" name="action" value="edit">
                        <input type="text" readonly class="form-control" name="id" id="edit-id">
                    </div>
                    <div class="form-group">
                        <label for="edit-cheName" class="control-label">编号:</label>
                        <input type="text" class="form-control" name="cheName" id="edit-cheName">
                    </div>
                    <div class="form-group">
                        <label for="edit-cheArea" class="control-label">投放区域:</label>
                        <input type="text" class="form-control" name="cheArea" id="edit-cheArea">
                    </div>
                    <div class="form-group">
                        <label for="edit-cheDate" class="control-label">投放时间:</label>
                        <input type="text" class="form-control" name="cheDate" id="edit-cheDate">
                    </div>
                    <div class="form-group">
                        <label for="edit-cheRen" class="control-label">区域负责人:</label>
                        <input type="text" class="form-control" name="cheRen" id="edit-cheRen">
                    </div>
                    <div class="form-group">
                        <label for="edit-chePhone" class="control-label">联系方式:</label>
                        <input type="text" class="form-control" name="chePhone" id="edit-chePhone">
                    </div>
                    <div class="form-group">
                        <label class="control-label">类型:</label>
                               <input name="cheType" id="edit-cheType_助力" type="radio" value="助力"/>助力
                               <input name="cheType" id="edit-cheType_电动" type="radio" value="电动"/>电动
                    </div>
                    <div class="form-group">
                        <label for="edit-cheWei" class="control-label">维修点:</label>
                        <input type="text" class="form-control" name="cheWei" id="edit-cheWei">
                    </div>
                    <div class="form-group">
                        <label class="control-label">状态:</label>
                               <input name="cheStatus" id="edit-cheStatus_正常" type="radio" value="正常"/>正常
                               <input name="cheStatus" id="edit-cheStatus_损坏" type="radio" value="损坏"/>损坏
                               <input name="cheStatus" id="edit-cheStatus_报废" type="radio" value="报废"/>报废
                    </div>
                    <div class="form-group">
                        <label for="edit-cheText" class="control-label">备注:</label>
                        <textarea style="height: 100px;" class="form-control" name="cheText" id="edit-cheText"></textarea>
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
            <form action="CheServlet">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">删除单车</h4>
                </div>
                <div class="modal-body">
                    确认要删除该单车记录吗？
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
            url: 'CheServlet?action=get&id=' + id,
            type: "get",
            success: function (voString) {
                let vo = eval('(' + voString + ')');
                        modal.find('#edit-id').val(vo.id);
                        modal.find('#edit-cheName').val(vo.cheName);
                        modal.find('#edit-cheArea').val(vo.cheArea);
                        modal.find('#edit-cheDate').val(vo.cheDate);
                        modal.find('#edit-cheRen').val(vo.cheRen);
                        modal.find('#edit-chePhone').val(vo.chePhone);
                        for (let val of "助力/电动".split('/')) {
                            if (val == vo.cheType) {
                                modal.find('#edit-cheType_' + vo.cheType).prop("checked", true);
                            } else {
                                modal.find('#edit-cheType_' + vo.cheType).removeAttr("checked");
                            }
                        };
                        modal.find('#edit-cheWei').val(vo.cheWei);
                        for (let val of "正常/损坏/报废".split('/')) {
                            if (val == vo.cheStatus) {
                                modal.find('#edit-cheStatus_' + vo.cheStatus).prop("checked", true);
                            } else {
                                modal.find('#edit-cheStatus_' + vo.cheStatus).removeAttr("checked");
                            }
                        };
                        modal.find('#edit-cheText').val(vo.cheText);
            }
        })
    })
    $('#modal-info').on('show.bs.modal', function (event) {
        let button = $(event.relatedTarget);
        let id = button.data('id');
        let modal = $(this);
        $.ajax({
            url: 'CheServlet?action=get&id=' + id,
            type: "get",
            success: function (voString) {
                let vo = eval('(' + voString + ')');
                modal.find('#info-cheName').text(vo.cheName);
                modal.find('#info-cheArea').text(vo.cheArea);
                modal.find('#info-cheDate').text(vo.cheDate);
                modal.find('#info-cheRen').text(vo.cheRen);
                modal.find('#info-chePhone').text(vo.chePhone);
                modal.find('#info-cheType').text(vo.cheType);
                modal.find('#info-cheWei').text(vo.cheWei);
                modal.find('#info-cheStatus').text(vo.cheStatus);
                modal.find('#info-cheText').text(vo.cheText);
            }
        })
    })
    function searchList() {
        window.location.href = "CheServlet?action=list&searchColumn="+document.getElementById("searchColumn").value+"&keyword=" + document.getElementById("search_keyword").value;
    }
    //增加表单提交之前进行检查，如果return false，则不允许提交
    function addCheck() {
        //根据ID获取值
        if (document.getElementById("add-cheName").value.trim().length == 0) {
            alert("编号不能为空");
            return false;
        }
        if (document.getElementById("add-cheArea").value.trim().length == 0) {
            alert("投放区域不能为空");
            return false;
        }
        if (document.getElementById("add-cheDate").value.trim().length == 0) {
            alert("投放时间不能为空");
            return false;
        }
        if (document.getElementById("add-cheRen").value.trim().length == 0) {
            alert("区域负责人不能为空");
            return false;
        }
        if (document.getElementById("add-chePhone").value.trim().length == 0) {
            alert("联系方式不能为空");
            return false;
        }
        if (document.getElementById("add-cheWei").value.trim().length == 0) {
            alert("维修点不能为空");
            return false;
        }
        return true;
    }
    //编辑表单提交之前进行检查，如果return false，则不允许提交
    function editCheck() {
        //根据ID获取值
        if (document.getElementById("edit-cheName").value.trim().length == 0) {
            alert("编号不能为空");
            return false;
        }
        if (document.getElementById("edit-cheArea").value.trim().length == 0) {
            alert("投放区域不能为空");
            return false;
        }
        if (document.getElementById("edit-cheDate").value.trim().length == 0) {
            alert("投放时间不能为空");
            return false;
        }
        if (document.getElementById("edit-cheRen").value.trim().length == 0) {
            alert("区域负责人不能为空");
            return false;
        }
        if (document.getElementById("edit-chePhone").value.trim().length == 0) {
            alert("联系方式不能为空");
            return false;
        }
        if (document.getElementById("edit-cheWei").value.trim().length == 0) {
            alert("维修点不能为空");
            return false;
        }
        return true;
    }
</script>
</html>
