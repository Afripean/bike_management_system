<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>登录</title>
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/main.css">
    <script src="js/jquery-3.5.1.js"></script>
    <script src="js/bootstrap.js"></script>
    <style>
        body{padding: 0;margin: 0;background: url("img/pic.jpg") no-repeat;background-size: 100%;}
    </style>
    <script type="text/javascript">
        let alert_msg = '${alert_msg}';
        if (alert_msg != null && alert_msg.trim() != '') {
            window.alert(alert_msg);
        }
    </script>
</head>

<body>
<div class="container">
    <div class="loginBox">
        <form class="form-horizontal" action="AuthServlet?action=login" method="post" onsubmit="return check()" style="background-color: #ffffffe0;border-radius: 20px;">
            <div class="loginLabel"><label style="text-align: center;font-size: 40px;padding-top:40px;font-weight: 700;color:#000000;text-shadow: 2px 3px #FFFFFF;">共享单车管理系统</label></div>
            <br>
            <a href="#" style="font-size: 24px;color: #269abc;text-decoration: none;padding-left: 140px;">登录</a>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<a href="register.jsp" style="font-size: 24px;color:black ;text-decoration: none;">注册</a>
            <br>
            <br>
            <div class="form-group" style="margin-top: 20px;">
                <label for="username" class="col-sm-3 control-label">账号</label>
                <div class="col-sm-7">
                    <input type="text" class="form-control" id="username" name="username" placeholder="请输入您的账号" >
                </div>
            </div>
            <div class="form-group">
                <label for="password" class="col-sm-3 control-label">密码</label>
                <div class="col-sm-7">
                    <input type="password" class="form-control" id="password" name="password" placeholder="请输入您的密码" >
                </div>
            </div>
			
            <div class="form-group">
                <label for="password" class="col-sm-3 control-label">验证码</label>
                <div class="col-sm-7 form-inline">
                    <input type="text" id="validationCode" name="validationCode"
                           style="width: 81px;height: 34px;padding: 6px 12px;font-size: 14px;border-radius: 4px;color: black;"
                           placeholder="验证码">
                    <img id="img_validation_code" src="AuthServlet?action=validationCode" onclick="refresh()" style="height: 30px;width: 135px;"/>
                </div>
            </div>
			
            <div class="loginBtn">
                <button type="submit" class=" btn btn-line btn-rect btn-danger loginBtn">登录</button>
            </div>
            <br>
            <br>
        </form>
    </div>
</div>
</body>
<script type="text/javascript">
    //提交之前进行检查，如果return false，则不允许提交
    function check() {
        //根据ID获取值
        var username = document.getElementById("username").value;
        var password = document.getElementById("password").value;
        if (username == "") {
            alert("用户名不能为空!");
            return false;
        }
        if (password == "") {
            alert("密码不能为空!");
            return false;
        }
        return true;
    }
    function refresh() {
        let img = document.getElementById("img_validation_code")
        img.src = "AuthServlet?action=validationCode&r=" + Math.random();
    }
</script>
</html>
