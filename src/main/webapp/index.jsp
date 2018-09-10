<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<meta charset="UTF-8">
<title>JSON版员工信息</title>
<link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script type="text/javascript" src="${APP_PATH}/static/jQuery/jquery-3.3.1.js"></script>
<script type="text/javascript" src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<script type="text/javascript">
	var totalNum = 0;
	var currentPage = 0;
	//切换页码
	function toPage(num){
		$.post("${APP_PATH}/emps?pageNum="+num,function(data){
			//构建employee_table
			build_employee_table(data);
			//构建PageInfo
			build_page_info(data);
			//构建PageNav
			build_page_nav(data);
		},"JSON")
	}
	
	//构建employee_table
	function build_employee_table(data){
		//每次切换页码时都要清空元素
		$("#employee_table > tbody").empty();
		var employees = data.extend.pageInfo.list;
		$.each(employees,function(index,item){
			var checkBox_td = $("<td><input type='checkbox' class='checkItem'></td>");
			var emp_id_td = $("<td></td>").append(item.id);
			var emp_lastName_td = $("<td></td>").append(item.lastName);
			var emp_gender_td = $("<td></td>").append(item.gender=="1"?"男":"女");
			var emp_email_td = $("<td></td>").append(item.email);
			var emp_deptName_td = $("<td></td>").append(item.department.name);
			/**
				<button class="btn btn-primary btn-sm">
					<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
					编辑
				</button>
				<button class="btn btn-danger btn-sm">
					<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
					删除
				</button>
			*/
			var edit_btn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
		 	.attr("aria-hidden","true")
		 	.attr("edit_id",item.id)
			.append(
				$("<span></span>")
				.addClass("glyphicon glyphicon-pencil")
			).append("编辑");
			var delete_btn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
			.attr("aria-hidden","true")
			.attr("delete_id",item.id)
		   	.append(
			   $("<span></span>")
			   .addClass("glyphicon glyphicon-trash")
		   	).append("删除");
			var emp_btn_td = $("<td></td>").append(edit_btn).append(" ").append(delete_btn);
			$("<tr></tr>").append(checkBox_td)
			.append(emp_id_td)
			.append(emp_lastName_td)
			.append(emp_gender_td)
			.append(emp_email_td)
			.append(emp_deptName_td)
			.append(emp_btn_td)
			.appendTo($("#employee_table > tbody"));
		})
	}
	
	/**
		当前页码为
		<span class="label label-info">${pageInfo.pageNum}</span>
		总页数为
		<span class="label label-info">${pageInfo.pages}</span>
		总条目数为
		<span class="label label-info">${pageInfo.total}</span>
	*/
	//构建PageInfo
	function build_page_info(data){
		//每次切换页码，需要清空页码信息
		$("#page_info_area").empty();
		var pageNum = $("<span></span>").addClass("label label-info").append(data.extend.pageInfo.pageNum);
		var pages = $("<span></span>").addClass("label label-info").append(data.extend.pageInfo.pages);
		var total = $("<span></span>").addClass("label label-info").append(data.extend.pageInfo.total);
		totalNum = data.extend.pageInfo.total;
		currentPage = data.extend.pageInfo.pageNum;
		$("#page_info_area").append("当前页码为")
		.append(pageNum)
		.append("总页数为")
		.append(pages)
		.append("总条目数为")
		.append(total);
	}
	
	/**
		<nav aria-label="Page navigation">
		  <ul class="pagination">
		  	<li><a href="${APP_PATH}/emps?pageNum=1">首页</a></li>
	    	<c:if test="${pageInfo.hasPreviousPage}">
		  	  <li>
			      <a href="${APP_PATH}/emps?pageNum=${pageInfo.prePage}" aria-label="Previous">
			      	<span aria-hidden="true">&laquo;</span>
			      </a>
		   	  </li>
	    	</c:if>
		    <c:forEach items="${pageInfo.navigatepageNums}" var="navPageNum">
		    	<c:if test="${navPageNum==pageInfo.pageNum}">
		    		<li class="active"><a href="#">${navPageNum}</a></li>
		    	</c:if>
		    	<c:if test="${navPageNum!=pageInfo.pageNum}">
		    		<li><a href="${APP_PATH}/emps?pageNum=${navPageNum}">${navPageNum}</a></li>
		    	</c:if>
		    </c:forEach>
	    	<c:if test="${pageInfo.hasNextPage}">
		  	  <li>
			      <a href="${APP_PATH}/emps?pageNum=${pageInfo.nextPage}" aria-label="Next">
			      	<span aria-hidden="true">&raquo;</span>
			      </a>
		   	  </li>
	    	</c:if>
		    <li><a href="${APP_PATH}/emps?pageNum=${pageInfo.pages}">末页</a></li>
		  </ul>
		</nav>
	*/
	//构建PageNav
	function build_page_nav(data) {
		//每次切换页面，需要清空页码条
		$("#page_nav-area").empty();
		var nav = $("<nav></nav>").attr("aria-label","Page navigation");
		var nav_ul = $("<ul></ul>").addClass("pagination");
		var first_page = $("<li></li>").append($("<a></a>").attr("href","#").append("首页"));
		var pre_page = $("<li></li>").append($("<a></a>").attr("href","#").append("&laquo;"));
		//如果是第一页，就设置按钮为不可点击，否则,绑定切换页码点击事件（启用此按钮）
		if(data.extend.pageInfo.hasPreviousPage == false){
			$(first_page).addClass("disabled");
			$(pre_page).addClass("disabled");
		}else{
			$(first_page).click(function(){
				toPage(1);
			});
			$(pre_page).click(function(){
				toPage(data.extend.pageInfo.prePage);
			});
		}
		var next_page = $("<li></li>").append($("<a></a>").attr("href","#").append("&raquo;"));
		var last_page = $("<li></li>").append($("<a></a>").attr("href","#").append("末页"));
		//如果是最后一页，设置按钮为不可点击，否则绑定切换页码事件（启用此按钮）
		if(data.extend.pageInfo.hasNextPage == false){
			$(last_page).addClass("disabled");
			$(next_page).addClass("disabled");
		}else{
			$(last_page).click(function(){
				toPage(data.extend.pageInfo.pages);
			});
			$(next_page).click(function(){
				toPage(data.extend.pageInfo.nextPage);
			});
		}
		$(nav_ul).append(first_page).append(pre_page);
		var navigateNum = data.extend.pageInfo.navigatepageNums;
		$.each(navigateNum,function(index,item){
			var nav_num = $("<li></li>").append($("<a></a>").attr("href","#").append(item));
			if(item == data.extend.pageInfo.pageNum){
				$(nav_num).addClass("active");
			}
			//绑定数字切换页码的点击事件
			$(nav_num).click(function(){
				toPage(item);
			});
			$(nav_ul).append(nav_num);
		})
		$(nav_ul).append(next_page).append(last_page);
		$(nav).append(nav_ul).appendTo("#page_nav-area");
	}
	
	//通过Ajax请求获取Deptment的数据
	function getDepartment(ele,selectedId){
		$(ele).empty();
		$.get("${APP_PATH}/depts",function(data){
			dept_info = data.extend.departments;
			$.each(dept_info,function(){
				$("<option></option>").attr("value",this.id)
				.append(this.name)
				.appendTo(ele);
			})
			if(selectedId != undefined){
				$(ele).val(selectedId);
			}
		});
	}
	
	//通过Ajax发送数据到服务器，保存Employee
	function saveEmp(){
		var sendData = $("#addEmployeeModal form").serialize();
		var flag = false;
		/**
		$.post("${APP_PATH}/emp",sendData,function(data){
			alert(data.message);
		})
		*/
		$.ajax({
			type:"POST",
			url:"${APP_PATH}/emp",
			data:sendData,
			async: false,
			success: function(data){
				//添加Employee时，成功通过校验会成功插入，否则后台会返回包含错误信息的Map
				//alert(data.extend.errorMap.lastName);
				//alert(data.extend.errorMap.email);
				//当后端不报错（没有返回errorMap）时，直接访问errorMap的元素会报错，应该先做判断
				if(data.extend.errorMap != undefined){
					if(data.extend.errorMap.lastName != undefined){
						show_validate_msg("#add_lastName","false",data.extend.errorMap.lastName);
					}
					if(data.extend.errorMap.email != undefined){
						show_validate_msg("#add_email","false",data.extend.errorMap.email);
					}
					if(data.extend.errorMap.lastNameExist != undefined){
						show_validate_msg("#add_lastName","false",data.extend.errorMap.lastNameExist);
					}
				}else{
					alert(data.message);
					flag = true;
				}
			}
		})
		return flag;
	}
	
	//JQuery校验表单格式
	function validate_email(ele){
		//var lastName_val = $("#add_lastName").val();
		var email_val = $(ele).val();
		//var lastName_reg = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
		var email_reg = /^([a-zA-Z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
		//if(!lastName_reg.test(lastName_val)){
			//alert("用户名格式有误");
		//	show_validate_msg("#add_lastName","false","用户名应该为2-5个汉字或6-16个字母（横杠，下划线）");
		//	return false;
		//}else{
		//	show_validate_msg("#add_lastName","true");
		//}
		if(!email_reg.test(email_val)){
			//alert("邮箱格式有误");
			show_validate_msg(ele,"false","邮箱格式有误");
			return false;
		}else{
			show_validate_msg(ele,"true");
		}
		return true;
	}
	
	//用户名唯一性校验
	function lastName_unique_valid(){
		var lastName_val = $("#add_lastName").val();
		var json = { "lastName" : lastName_val };
		$.get("${APP_PATH}/nameUnique",json,function(data){
			if(data.code == 100){
				show_validate_msg("#add_lastName","true");
				$("#add_lastName").attr("ajax_valid","yes");
			}else if(data.code == 200){
				show_validate_msg("#add_lastName","false",data.extend.valid_result);
				$("#add_lastName").attr("ajax_valid","no");
			}
		},"JSON")
	}
	
	//显示校验状态
	function show_validate_msg(ele,status,msg){
		reset_validate_msg($(ele));
		if(status == "false"){
			$(ele).parent().addClass("has-error");
			$(ele).next("span").addClass("glyphicon glyphicon-remove").text(msg);
		}else if(status == "true"){
			$(ele).parent().addClass("has-success");
			$(ele).next("span").addClass("glyphicon glyphicon-ok").text("OK");
		}
	}
	
	//重置表单校验状态
	function reset_validate_msg(ele){
		ele.parent().removeClass("has-error has-success");
		ele.next("span").removeClass("glyphicon glyphicon-remove glyphicon glyphicon-ok").text("");
	}
	
	//重置表单及表单校验状态
	function reset_form(ele){
		$(ele)[0].reset();
		//去除表单校验状态
		reset_validate_msg($(ele).find(":text"));
	}
	
	//根据id发送Ajax请求获取员工数据
	function getEmpById(id){
		var result;
		$.ajax({
			type:"GET",
			url:"${APP_PATH}/emp/"+id,
			async:false,
			success:function(data){
				result = data;
			}
		})
		return result;
	}
	
	//构建编辑的模态框
	function buildEditEmployeeModal(result){
		$("#edit_lastName_static").text(result.extend.emp.lastName);
		$("#edit_email").val(result.extend.emp.email);
		$("#editEmployeeModal input[type='radio']").val([result.extend.emp.gender]);
		getDepartment("#editEmployeeModal select",result.extend.emp.deptId);
	}
	
	//更新员工
	function updateEmployee(sendData,id){
		$.ajax({
			url:"${APP_PATH}/emp/"+id,
			type:"PUT",
			data:sendData,
			success:function(){
				//关闭模态框
				$("#editEmployeeModal").modal('hide');
				//跳转到条目所在页
				toPage(currentPage);
			}
		})
	}
	
	//删除员工
	function deleteEmployee(idString){
		$.ajax({
			url:"${APP_PATH}/emp/"+idString,
			type:"DELETE",
			success:function(){
				toPage(currentPage);
			}
		});
	}
	
	//首次进入，进入第一页
	$(function() {
		toPage(1);
		
		//添加新增按钮的点击事件：打开模态框
		$("#addEmployee").click(function(){
			reset_form("#addEmployeeModal form");
			getDepartment("#addEmployeeModal select");
			$("#addEmployeeModal").modal({
				backdrop:true
			})
		})
		
		//模态框提交按钮的点击事件
		$("#save_emp").click(function() {
			//提交前进行数据格式校验
			//现在已改为动态校验
			/**if(!validate_email()){
				return false;
			}*/
			//用户名唯一校验结果
			if($("#add_lastName").attr("ajax_valid") == "no"){
				return false;
			}
			//邮箱格式校验结果
			if($("#add_email").attr("ajax_valid") == "no"){
				return false;
			}
			//保存Employee
			var flag = saveEmp();
			if(flag){
				//关闭模态框
				$("#addEmployeeModal").modal('hide');
				//跳转到最后一页(设置为总条目数，由于设置了PageHelper的Resonable属性，所以会查最后一页)
				toPage(totalNum);			
			}
		})
		
		$("#add_lastName").change(function(){
			//调用用户名唯一性校验方法
			lastName_unique_valid();
		})
		
		$("input[name=email]").change(function(){
			if(validate_email(this)){
				$(this).attr("ajax_valid","yes");
			}else{
				$(this).attr("ajax_valid","no");
			}
		})
		
		//编辑按钮点击事件
		$("#employee_table").on("click",".edit_btn",function(){
			//重置表单
			reset_form("#editEmployeeModal form");
			//构建编辑模态框
			var id = $(this).attr("edit_id");
			var result = getEmpById(id);
			buildEditEmployeeModal(result);
			//显示模态框
			$("#editEmployeeModal").modal();
			$("#update_emp").attr("edit_id",$(this).attr("edit_id"));
		});
		
		//更新按钮点击事件
		$("#update_emp").click(function() {
			var empId =	$(this).attr("edit_id");
			//序列化表单
			var sendData = $("#editEmployeeModal form").serialize();
			//校验邮箱格式
			if($("#edit_email").attr("ajax_valid") == "no"){
				return false;
			}
			//更新员工数据
			updateEmployee(sendData,empId);	
		})
		
		//单个删除按钮点击事件
		$("#employee_table").on("click",".delete_btn",function(){
			var cur_lastName = $(this).parents("tr").find("td:eq(2)").text();
			if(confirm("你确定要删除"+ cur_lastName +"员工的信息吗？")){
				var empId =	$(this).attr("delete_id");
				deleteEmployee(empId);
			}
		})
		
		//全选、全不选
		$(".checkAll").click(function(){
			//获取DOM原生的属性，建议使用prop
			var flag = $(this).prop("checked");
			$.each($(".checkItem"),function(){
				$(this).prop("checked",flag);
			})
		})
		
		$("#employee_table").on("click",".checkItem",function(){
			var flag = $(".checkItem:checked").length==$(".checkItem").length;
			//alert($(".checkItem:checked").length);
			//alert($(".checkItem").length);
			$(".checkAll").prop("checked",flag);
		})
		
		//批量删除的点击事件
		$("#deleteEmployee").click(function() {
			if(confirm("你确定要删除这些员工信息吗？")){
				var idString = "";
				//构建idString
				$.each($(".checkItem:checked"),function(){
					idString += $(this).parents("tr").find("td:eq(1)").text() + "-";
				})
				idString = idString.split(0,idString.length-1);
				deleteEmployee(idString);
			}
		})
	})
</script>
</head>
<body>
	<!-- 新增Employee的Modal -->
	<div class="modal fade" id="addEmployeeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="modal_title_label">新增员工</h4>
	      </div>
	      <div class="modal-body">
			<form class="form-horizontal">
			  <!-- lastName -->
			  <div class="form-group">
			    <label for="lastName" class="col-sm-2 control-label">LastName</label>
			    <div class="col-sm-10">
			      <input type="text" class="form-control" id="add_lastName" name="lastName" placeholder="Tom">
			      <span	class="help-block"></span>
			    </div>
			  </div>
			  <!-- Email -->
			  <div class="form-group">
			    <label for="email" class="col-sm-2 control-label">Email</label>
			    <div class="col-sm-10">
			      <input type="text" class="form-control" id="add_email" name="email" placeholder="email@beater.com">
			      <span	class="help-block"></span>
			    </div>
			  </div>
			  <!-- Gender -->
			  <div class="form-group">
			    <label for="gender" class="col-sm-2 control-label">Gender</label>
			    <div class="col-sm-10">
			    	<label class="radio-inline">
					  <input type="radio" name="gender" id="add_male" value="1" checked="checked"> 男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="add_female" value="0"> 女
					</label>
			    </div>
			  </div>
			  <!-- Department -->			  
			  <div class="form-group">
			    <label for="department" class="col-sm-2 control-label">Department</label>
			    <div class="col-sm-4">
			    	<select class="form-control" name="deptId">
					</select>
			    </div>
			  </div>			  
			</form>	        
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="save_emp">提交</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<!-- 编辑Employee的Modal -->
	<div class="modal fade" id="editEmployeeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="modal_title_label">编辑员工</h4>
	      </div>
	      <div class="modal-body">
			<form class="form-horizontal">
			  <!-- lastName -->
			  <div class="form-group">
			    <label for="lastName" class="col-sm-2 control-label">LastName</label>
			    <div class="col-sm-10">
					<p class="form-control-static" id="edit_lastName_static"></p>
			    </div>
			  </div>
			  <!-- Email -->
			  <div class="form-group">
			    <label for="email" class="col-sm-2 control-label">Email</label>
			    <div class="col-sm-10">
			      <input type="text" class="form-control" id="edit_email" name="email" placeholder="email@beater.com">
			      <span	class="help-block"></span>
			    </div>
			  </div>
			  <!-- Gender -->
			  <div class="form-group">
			    <label for="gender" class="col-sm-2 control-label">Gender</label>
			    <div class="col-sm-10">
			    	<label class="radio-inline">
					  <input type="radio" name="gender" id="edit_male" value="1"> 男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="edit_female" value="0"> 女
					</label>
			    </div>
			  </div>
			  <!-- Department -->			  
			  <div class="form-group">
			    <label for="department" class="col-sm-2 control-label">Department</label>
			    <div class="col-sm-4">
			    	<select class="form-control" name="deptId" id="select">
					</select>
			    </div>
			  </div>
			</form>	        
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="update_emp">更新</button>
	      </div>
	    </div>
	  </div>
	</div>	
		
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-12">
				<nav class="navbar navbar-default navbar-inverse">
					<div class="container-fluid">
						<div class="navbar-header">
							<a class="navbar-brand" href="#">SSM-CRUD</a>
						</div>
					</div>
				</nav>
			</div>
		</div>
		<div class="row">
			<div class="col-md-1 col-md-offset-11">
				<button id="addEmployee" class="btn btn-primary">新增</button>
				<button id="deleteEmployee" class="btn btn-danger">删除</button>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<table id="employee_table" class="table table-hover">
					<thead>
						<tr>
							<th><input type="checkbox" class="checkAll"></th>
							<th>#</th>
							<th>LastName</th>
							<th>Gender</th>
							<th>Email</th>
							<th>DeptName</th>
							<th>Operation</th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
		<div class="row">
			<div class="col-md-6">
				<div class="well" id="page_info_area">
				</div>
			</div>
			<div class="col-md-4 col-md-offset-2" id="page_nav-area">
			</div>
		</div>
	</div>
</body>
</html>