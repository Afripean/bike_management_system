<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>公告管理</title>
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
                <jsp:param value="active" name="Notice_active"/>
            </jsp:include>
        </div>
        <br>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="row">
                <div class="col-sm-7">
                    <div class="input-group">
                        <input class="form-control" type="hidden" id="searchColumn" name="searchColumn" value="notice_name"/>
                        <input class="form-control" type="text" id="search_keyword" name="search_keyword" placeholder="标题"/>
                        <span class="input-group-btn">
                            <button class="btn btn-line btn-rect btn-warning" type="button" onclick="searchList()">搜索</button>
                        </span>
                    </div>
                </div>
                <div class="col-sm-5">
                    <button type="button" <c:if test="${loginUser.userType != '管理员'}">disabled="disabled" title="没有权限！！！"</c:if> class="btn btn-line btn-rect btn-success" data-toggle="modal" data-target="#modal-add">添加公告
                    </button>
                </div>
            </div>
            <br>
            <br>
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                    <tr>
                        <th>标题</th>
                        <th>内容</th>
                        <th>类型</th>
                        <th>创建时间</th>
                        <th style="text-align: center;">操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${list}" var="vo">
                        <tr>
                            <td>${vo.noticeName}</td>
                            <td title="${vo.noticeText}">
                                <c:choose>
                                    <c:when test="${fn:length(vo.noticeText) > 19}">
                                        <a href="${vo.noticeText}" target="_blank">${fn:substring(vo.noticeText, 0, 19)}...</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${vo.noticeText}" target="_blank">${vo.noticeText}</a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="notice-type">${vo.noticeType}</td>
                            <td>${vo.createDate}</td>
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
            <form action="NoticeServlet" onsubmit="return addCheck()">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"
                            aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">增加公告</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group hidden">
                        <label class="control-label">(hidden)</label>
                        <input type="text" class="form-control" name="action" value="add">
                    </div>
                    <div class="form-group">
                        <label for="add-noticeName" class="control-label">标题:</label>
                        <input type="text" class="form-control" name="noticeName" id="add-noticeName">
                    </div>
                    <div class="form-group">
                        <label for="add-noticeText" class="control-label">内容(链接):</label>
                        <textarea style="height: 100px;" class="form-control" name="noticeText" id="add-noticeText"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="add-noticeType" class="control-label">类型:</label>
                        <select class="form-control" name="noticeType" id="add-noticeType">
                            <option value="1">新闻推送</option>
                            <option value="2">系统公告</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="add-createDate" class="control-label">创建时间:</label>
                        <input type="text" class="form-control" name="createDate" id="add-createDate" readonly>
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
                    <h4 class="modal-title">公告</h4>
                </div>
                <div class="modal-body">
                    <table class="table table-striped table-hover" style="font-size: 15px;">
                        <tr>
                            <td style="width: 15%;">标题:</td>
                            <td><b id="info-noticeName"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">内容(链接):</td>
                            <td><b id="info-noticeText"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">类型:</td>
                            <td><b id="info-noticeType"></b></td>
                        </tr>
                        <tr>
                            <td style="width: 15%;">创建时间:</td>
                            <td><b id="info-createDate"></b></td>
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
            <form action="NoticeServlet" onsubmit="return editCheck()">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">更新公告</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group hidden">
                        <label class="control-label">(hidden)</label>
                        <input type="text" class="form-control" name="action" value="edit">
                        <input type="text" readonly class="form-control" name="id" id="edit-id">
                    </div>
                    <div class="form-group">
                        <label for="edit-noticeName" class="control-label">标题:</label>
                        <input type="text" class="form-control" name="noticeName" id="edit-noticeName">
                    </div>
                    <div class="form-group">
                        <label for="edit-noticeText" class="control-label">内容(链接):</label>
                        <textarea style="height: 100px;" class="form-control" name="noticeText" id="edit-noticeText"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="edit-noticeType" class="control-label">类型:</label>
                        <select class="form-control" name="noticeType" id="edit-noticeType">
                            <option value="1">新闻推送</option>
                            <option value="2">系统公告</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="edit-createDate" class="control-label">创建时间:</label>
                        <input type="text" class="form-control" name="createDate" id="edit-createDate" readonly>
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
            <form action="NoticeServlet">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">删除公告</h4>
                </div>
                <div class="modal-body">
                    确认要删除该公告记录吗？
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
            url: 'NoticeServlet?action=get&id=' + id,
            type: "get",
            success: function (voString) {
                let vo = JSON.parse(voString);
                modal.find('#edit-id').val(vo.id);
                modal.find('#edit-noticeName').val(vo.noticeName);
                modal.find('#edit-noticeText').val(vo.noticeText);
                modal.find('#edit-noticeType').val(vo.noticeType);
                modal.find('#edit-createDate').val(vo.createDate);
            }
        })
    })
    $('#modal-info').on('show.bs.modal', function (event) {
        let button = $(event.relatedTarget);
        let id = button.data('id');
        let modal = $(this);
        $.ajax({
            url: 'NoticeServlet?action=get&id=' + id,
            type: "get",
            success: function (voString) {
                let vo = JSON.parse(voString);
                modal.find('#info-noticeName').text(vo.noticeName);
                modal.find('#info-noticeText').html('<a href="' + vo.noticeText + '" target="_blank">' + vo.noticeText + '</a>');
                modal.find('#info-noticeType').text(vo.noticeType);
                modal.find('#info-createDate').text(vo.createDate);
                convertInfoNoticeType();
            }
        })
    })

    function searchList() {
        window.location.href = "NoticeServlet?action=list&searchColumn="+document.getElementById("searchColumn").value+"&keyword=" + document.getElementById("search_keyword").value;
    }

    //增加表单提交之前进行检查，如果return false，则不允许提交
    function addCheck() {
        //根据ID获取值
        if (document.getElementById("add-noticeName").value.trim().length == 0) {
            alert("标题不能为空");
            return false;
        }
        if (document.getElementById("add-noticeType").value.trim().length == 0) {
            alert("类型不能为空");
            return false;
        }
        if (document.getElementById("add-createDate").value.trim().length == 0) {
            alert("创建时间不能为空");
            return false;
        }
        return true;
    }

    //编辑表单提交之前进行检查，如果return false，则不允许提交
    function editCheck() {
        //根据ID获取值
        if (document.getElementById("edit-noticeName").value.trim().length == 0) {
            alert("标题不能为空");
            return false;
        }
        if (document.getElementById("edit-noticeType").value.trim().length == 0) {
            alert("类型不能为空");
            return false;
        }
        if (document.getElementById("edit-createDate").value.trim().length == 0) {
            alert("创建时间不能为空");
            return false;
        }
        return true;
    }

    function getCurrentTimeInCST() {
        let date = new Date();
        let utc = date.getTime() + (date.getTimezoneOffset() * 6000);
        let offset = 8 * 60 * 60 * 1000; // 东八区时间偏移量
        let cst = new Date(utc + offset);
        return cst.toISOString().slice(0, 19).replace('T', ' ');
    }

    function convertNoticeType(noticeType) {
        if (noticeType == "1") {
            return "新闻推送";
        } else if (noticeType == "2") {
            return "系统公告";
        } else {
            return "未知类型";
        }
    }

    function convertInfoNoticeType() {
        var noticeTypeElement = document.getElementById('info-noticeType');
        var noticeTypeValue = noticeTypeElement.textContent.trim();
        console.log("Original info-noticeType value:", noticeTypeValue); // 输出到控制台
        noticeTypeElement.textContent = convertNoticeType(noticeTypeValue);
    }

    function renderNoticeList() {
        var noticeList = document.querySelectorAll('.notice-type');
        noticeList.forEach(function(item) {
            var originalValue = item.textContent.trim();
            console.log("Original noticeType value:", originalValue); // 输出到控制台
            item.textContent = convertNoticeType(originalValue); // 转换并显示
        });
    }

    $(document).ready(function() {
        $('#add-createDate').val(getCurrentTimeInCST());
        $('#edit-createDate').val(getCurrentTimeInCST());
        renderNoticeList(); // 调用转换函数
    });
</script>
</body>
</html>

