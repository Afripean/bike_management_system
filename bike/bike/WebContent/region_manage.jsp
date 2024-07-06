<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>区域管理</title>
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/main.css">
    <script src="js/jquery-3.5.1.js"></script>
    <script src="js/bootstrap.js"></script>
    <script src="https://webapi.amap.com/maps?v=2.0&key=351d4b83ec0b5eb3d225f1ad47c01300"></script>
    <style>
        #map-container {
            width: 100%;
            height: 800px;
        }
    </style>
    <script>
        var addVehicleMode = false;
        var selectedLocation = null;
        var drawing = false;
        var path = [];
        var map;
        var polygon;

        function initMap() {
            map = new AMap.Map('map-container', {
                center: [114.363285, 30.533731],
                zoom: 16 // 缩放级别
            });

            // 调整大小
            var vehicleIcon = new AMap.Icon({
                size: new AMap.Size(30, 30), // 设置标记点图标大小
                image: 'https://a.amap.com/jsapi_demos/static/demo-center/icons/poi-marker-default.png', // 默认图标路径
                imageSize: new AMap.Size(30, 30) // 图标显示大小
            });

            map.on('click', function(e) {
                if (addVehicleMode) {
                    selectedLocation = e.lnglat;
                    openAddVehicleModal();
                } else if (drawing) {
                    var lnglat = [e.lnglat.getLng(), e.lnglat.getLat()];
                    path.push(lnglat);
                    drawPolygon();
                }
            });

            $.ajax({
                url: 'RegionServlet?action=getParkingAreas',
                method: 'GET',
                success: function(data) {
                    var parkingAreas = data; // 确保直接使用 data，无需 JSON.parse

                    parkingAreas.forEach(function(area) {
                        var coordinates = JSON.parse(area.areaGeoJson).coordinates[0];
                        var path = coordinates.map(function(coord) {
                            return [coord[0], coord[1]];
                        });

                        var polygon = new AMap.Polygon({
                            path: path,
                            fillColor: '#00FF00',
                            borderColor: '#0000FF'
                        });

                        polygon.setMap(map);
                        polygon.on('click', function() {
                            var infoWindowContent =
                                '<h4>区域信息</h4>' +
                                '<p>区域名称: ' + area.areaName + '</p>' +
                                '<p>创建时间: ' + area.createdAt + '</p>' +
                                '<button onclick="editArea(' + area.areaId + ', \'' + area.areaName + '\', \'' + area.createdAt + '\')">修改</button>' +
                                '<button onclick="deleteArea(' + area.areaId + ')">删除</button>';
                            var infoWindow = new AMap.InfoWindow({
                                content: infoWindowContent
                            });
                            infoWindow.open(map, polygon.getBounds().getCenter());
                        });
                    });
                },
                error: function(xhr, status, error) {
                    console.error("Error fetching parking areas:", error);
                }
            });

            $.ajax({
                url: 'RegionServlet?action=getVehicles',
                method: 'GET',
                success: function(data) {
                    var vehicles = data; // 确保直接使用 data，无需 JSON.parse

                    vehicles.forEach(function(vehicle) {
                        var coordinates = JSON.parse(vehicle.location).coordinates;
                        var marker = new AMap.Marker({
                            position: [coordinates[0], coordinates[1]],
                            title: vehicle.licensePlate,
                            icon: vehicleIcon
                        });

                        marker.setMap(map);
                        marker.on('click', function() {
                            var infoWindowContent =
                                '<h4>车辆信息</h4>' +
                                '<p>车牌号: ' + vehicle.licensePlate + '</p>' +
                                '<p>类型: ' + vehicle.type + '</p>' +
                                '<p>状态: ' + vehicle.status + '</p>' +
                                '<p>区域: ' + vehicle.cheArea + '</p>' +
                                '<p>投放时间: ' + vehicle.cheDate + '</p>' +
                                '<p>负责人: ' + vehicle.cheRen + '</p>' +
                                '<p>联系方式: ' + vehicle.chePhone + '</p>' +
                                '<p>创建时间: ' + vehicle.createdAt + '</p>' +
                                '<button onclick="editVehicle(' + vehicle.vehicleId + ', \'' + vehicle.licensePlate + '\', \'' + vehicle.type + '\', \'' + vehicle.status + '\', \'' + vehicle.cheArea + '\', \'' + vehicle.cheDate + '\', \'' + vehicle.cheRen + '\', \'' + vehicle.chePhone + '\', \'' + vehicle.createdAt + '\')">修改</button>' +
                                '<button onclick="deleteVehicle(' + vehicle.vehicleId + ')">删除</button>';
                            var infoWindow = new AMap.InfoWindow({
                                content: infoWindowContent
                            });
                            infoWindow.open(map, marker.getPosition());
                        });
                    });
                },
                error: function(xhr, status, error) {
                    console.error("Error fetching vehicles:", error);
                }
            });
        }

        function deleteArea(areaId) {
            if (confirm("确定要删除这个区域吗？")) {
                $.ajax({
                    url: 'RegionServlet?action=deleteParkingArea',
                    method: 'POST',
                    data: { areaId: areaId },
                    success: function(response) {
                        alert("区域已删除");
                        location.reload();
                    },
                    error: function(xhr, status, error) {
                        console.error("Error deleting parking area:", xhr.responseText);
                    }
                });
            }
        }

        function deleteVehicle(vehicleId) {
            if (confirm("确定要删除这个车辆吗？")) {
                $.ajax({
                    url: 'RegionServlet?action=deleteVehicle',
                    method: 'POST',
                    data: { vehicleId: vehicleId },
                    success: function(response) {
                        alert("车辆已删除");
                        location.reload();
                    },
                    error: function(xhr, status, error) {
                        console.error("Error deleting vehicle:", xhr.responseText);
                    }
                });
            }
        }

        function editVehicle(vehicleId, licensePlate, type, status, cheArea, cheDate, cheRen, chePhone, createdAt) {
            var modalContent =
                '<div class="modal" id="editModal" tabindex="-1" role="dialog">' +
                '<div class="modal-dialog" role="document">' +
                '<div class="modal-content">' +
                '<div class="modal-header">' +
                '<h5 class="modal-title">修改车辆信息</h5>' +
                '<button type="button" class="close" data-dismiss="modal" aria-label="Close">' +
                '<span aria-hidden="true">&times;</span>' +
                '</button>' +
                '</div>' +
                '<div class="modal-body">' +
                '<form id="editForm">' +
                '<div class="form-group">' +
                '<label for="newLicensePlate">车牌号</label>' +
                '<input type="text" class="form-control" id="newLicensePlate" value="' + licensePlate + '">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="newType">类型</label>' +
                '<input type="text" class="form-control" id="newType" value="' + type + '">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="newStatus">状态</label>' +
                '<input type="text" class="form-control" id="newStatus" value="' + status + '">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="newCheArea">区域</label>' +
                '<input type="text" class="form-control" id="newCheArea" value="' + cheArea + '">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="newCheDate">投放时间</label>' +
                '<input type="text" class="form-control" id="newCheDate" value="' + cheDate + '">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="newCheRen">负责人</label>' +
                '<input type="text" class="form-control" id="newCheRen" value="' + cheRen + '">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="newChePhone">联系方式</label>' +
                '<input type="text" class="form-control" id="newChePhone" value="' + chePhone + '">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="newCreatedAt">创建时间</label>' +
                '<input type="text" class="form-control" id="newCreatedAt" value="' + createdAt + '">' +
                '</div>' +
                '</form>' +
                '</div>' +
                '<div class="modal-footer">' +
                '<button type="button" class="btn btn-primary" onclick="saveVehicleChanges(' + vehicleId + ')">保存</button>' +
                '<button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>' +
                '</div>' +
                '</div>' +
                '</div>' +
                '</div>';

            $('body').append(modalContent);
            $('#editModal').modal('show');
        }

        function saveVehicleChanges(vehicleId) {
            var newLicensePlate = $('#newLicensePlate').val();
            var newType = $('#newType').val();
            var newStatus = $('#newStatus').val();
            var newCheArea = $('#newCheArea').val();
            var newCheDate = $('#newCheDate').val();
            var newCheRen = $('#newCheRen').val();
            var newChePhone = $('#newChePhone').val();
            var newCreatedAt = $('#newCreatedAt').val();

            $.ajax({
                url: 'RegionServlet?action=updateVehicle',
                method: 'POST',
                data: {
                    vehicleId: vehicleId,
                    licensePlate: newLicensePlate,
                    type: newType,
                    status: newStatus,
                    cheArea: newCheArea,
                    cheDate: newCheDate,
                    cheRen: newCheRen,
                    chePhone: newChePhone,
                    createdAt: newCreatedAt
                },
                success: function(response) {
                    alert("车辆信息已更新");
                    location.reload();
                },
                error: function(xhr, status, error) {
                    console.error("Error updating vehicle:", xhr.responseText);
                }
            });
            $('#editModal').modal('hide').remove();
        }

        function editArea(areaId, areaName, createdAt) {
            var modalContent =
                '<div class="modal" id="editAreaModal" tabindex="-1" role="dialog">' +
                '<div class="modal-dialog" role="document">' +
                '<div class="modal-content">' +
                '<div class="modal-header">' +
                '<h5 class="modal-title">修改区域信息</h5>' +
                '<button type="button" class="close" data-dismiss="modal" aria-label="Close">' +
                '<span aria-hidden="true">&times;</span>' +
                '</button>' +
                '</div>' +
                '<div class="modal-body">' +
                '<form id="editAreaForm">' +
                '<div class="form-group">' +
                '<label for="newAreaName">区域名称</label>' +
                '<input type="text" class="form-control" id="newAreaName" value="' + areaName + '">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="newAreaCreatedAt">创建时间</label>' +
                '<input type="text" class="form-control" id="newAreaCreatedAt" value="' + createdAt + '">' +
                '</div>' +
                '</form>' +
                '</div>' +
                '<div class="modal-footer">' +
                '<button type="button" class="btn btn-primary" onclick="saveAreaChanges(' + areaId + ')">保存</button>' +
                '<button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>' +
                '</div>' +
                '</div>' +
                '</div>' +
                '</div>';

            $('body').append(modalContent);
            $('#editAreaModal').modal('show');
        }

        function saveAreaChanges(areaId) {
            var newAreaName = $('#newAreaName').val();
            var newAreaCreatedAt = $('#newAreaCreatedAt').val();

            $.ajax({
                url: 'RegionServlet?action=updateParkingArea',
                method: 'POST',
                data: {
                    areaId: areaId,
                    areaName: newAreaName,
                    createdAt: newAreaCreatedAt
                },
                success: function(response) {
                    alert("区域信息已更新");
                    location.reload();
                },
                error: function(xhr, status, error) {
                    console.error("Error updating area:", xhr.responseText);
                }
            });
            $('#editAreaModal').modal('hide').remove();
        }

        function openAddVehicleModal() {
            var modalContent =
                '<div class="modal" id="addVehicleModal" tabindex="-1" role="dialog">' +
                '<div class="modal-dialog" role="document">' +
                '<div class="modal-content">' +
                '<div class="modal-header">' +
                '<h5 class="modal-title">添加车辆</h5>' +
                '<button type="button" class="close" data-dismiss="modal" aria-label="Close">' +
                '<span aria-hidden="true">&times;</span>' +
                '</button>' +
                '</div>' +
                '<div class="modal-body">' +
                '<form id="addVehicleForm">' +
                '<div class="form-group">' +
                '<label for="newLicensePlate">车牌号</label>' +
                '<input type="text" class="form-control" id="newLicensePlate">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="newType">类型</label>' +
                '<input type="text" class="form-control" id="newType" value="电动车">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="newStatus">状态</label>' +
                '<input type="text" class="form-control" id="newStatus" value="available">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="newCheDate">投放时间</label>' +
                '<input type="text" class="form-control" id="newCheDate">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="newCheRen">负责人</label>' +
                '<input type="text" class="form-control" id="newCheRen">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="newChePhone">联系方式</label>' +
                '<input type="text" class="form-control" id="newChePhone">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="newCreatedAt">创建时间</label>' +
                '<input type="text" class="form-control" id="newCreatedAt" value="2024-07-01">' +
                '</div>' +
                '</form>' +
                '</div>' +
                '<div class="modal-footer">' +
                '<button type="button" class="btn btn-primary" onclick="saveNewVehicle()">保存</button>' +
                '<button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>' +
                '</div>' +
                '</div>' +
                '</div>' +
                '</div>';

            $('body').append(modalContent);
            $('#addVehicleModal').modal('show');
        }

        function saveNewVehicle() {
            var newLicensePlate = $('#newLicensePlate').val();
            var newType = $('#newType').val() || '电动车'; // 默认值为电动车
            var newStatus = $('#newStatus').val() || 'available'; // 默认值为available
            var newCheDate = $('#newCheDate').val();
            var newCheRen = $('#newCheRen').val();
            var newChePhone = $('#newChePhone').val();
            var newCreatedAt = $('#newCreatedAt').val() || '2024-07-01'; // 默认值为2024-07-01

            $.ajax({
                url: 'RegionServlet?action=addVehicle',
                method: 'POST',
                data: {
                    licensePlate: newLicensePlate,
                    type: newType,
                    status: newStatus,
                    cheDate: newCheDate,
                    cheRen: newCheRen,
                    chePhone: newChePhone,
                    createdAt: newCreatedAt,
                    location: selectedLocation ? selectedLocation.toString() : null, // 将经纬度作为字符串传递
                    che_area: 11 // 设置 che_area 为 11
                },
                success: function(response) {
                    alert("车辆已添加");
                    location.reload();
                },
                error: function(xhr, status, error) {
                    console.error("Error adding vehicle:", xhr.responseText);
                }
            });
            $('#addVehicleModal').modal('hide').remove();
        }

        function toggleDrawing() {
            if (!drawing) {
                startDrawing();
                $('#toggleDrawing').text('保存区域');
            } else {
                saveArea();
                $('#toggleDrawing').text('添加区域');
            }
        }

        function drawPolygon() {
            if (polygon) {
                polygon.setMap(null);
            }
            polygon = new AMap.Polygon({
                path: path,
                fillColor: '#00FF00',
                borderColor: '#0000FF'
            });
            polygon.setMap(map);
        }

        function startDrawing() {
            drawing = true;
            path = [];
            if (polygon) {
                polygon.setMap(null);
            }
        }

        function saveArea() {
            if (path.length > 2) {
                var areaName = prompt("请输入区域名称：");
                if (areaName) {
                    var areaGeoJson = JSON.stringify({
                        type: "Polygon",
                        coordinates: [path]
                    });

                    $.ajax({
                        url: 'RegionServlet?action=addParkingArea',
                        method: 'POST',
                        data: {
                            areaName: areaName,
                            areaGeoJson: areaGeoJson
                        },
                        success: function(response) {
                            alert("区域已添加");
                            location.reload();
                        },
                        error: function(xhr, status, error) {
                            console.error("Error adding area:", xhr.responseText);
                        }
                    });
                }
            } else {
                alert("请绘制一个至少包含三个点的区域");
            }
            drawing = false;
        }

        function enableAddVehicleMode() {
            addVehicleMode = true;
        }


        $(document).ready(function() {
            initMap();
            $('#toggleDrawing').on('click', toggleDrawing);
        });
    </script>
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
            <jsp:include page="admin_menu.jsp">
                <jsp:param value="Region_active" name="Region_active"/>
            </jsp:include>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div id="map-container"></div>
            <button type="button" class="btn btn-primary" onclick="enableAddVehicleMode()">添加车辆</button>
            <button id="toggleDrawing" class="btn btn-primary">添加区域</button>
        </div>
    </div>
</div>
</body>
</html>
