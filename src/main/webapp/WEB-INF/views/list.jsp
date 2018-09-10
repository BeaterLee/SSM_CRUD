<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<meta charset="UTF-8">
<title>员工信息</title>
<link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script type="text/javascript" src="${APP_PATH}/static/jQuery/jquery-3.3.1.js"></script>
<script type="text/javascript" src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
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
			<div class="col-md-2 col-md-offset-10">
				<button class="btn btn-primary">新增</button>
				<button class="btn btn-danger">删除</button>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover">
					<thead>
						<tr>
							<td></td>
							<td>#</td>
							<td>LastName</td>
							<td>Gender</td>
							<td>Email</td>
							<td>DeptName</td>
							<td>Operation</td>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${pageInfo.list}" var="employee">
							<tr>
								<td></td>
								<td>${employee.id}</td>
								<td>${employee.lastName}</td>
								<td>${employee.gender}</td>
								<td>${employee.email}</td>
								<td>${employee.department.name}</td>
								<td>
									<button class="btn btn-primary btn-sm">
										<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
										编辑
									</button>
									<button class="btn btn-danger btn-sm">
										<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
										删除
									</button>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
		<div class="row">
			<div class="col-md-6">
				<div class="well">
					当前页码为
					<span class="label label-info">${pageInfo.pageNum}</span>
					总页数为
					<span class="label label-info">${pageInfo.pages}</span>
					总条目数为
					<span class="label label-info">${pageInfo.total}</span>
				</div>
			</div>
			<div class="col-md-4 col-md-offset-2">
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
			</div>
		</div>
	</div>
</body>
</html>