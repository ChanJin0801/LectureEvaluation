<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width-device-width, initial-scale = 1, shrink-to-fit-no">
	<title>강의평가 웹 사이트 </title>
	
	<!--부트스트랩 CSS  -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- 커스텀 CSS -->
	<link rel="stylesheet" href="./css/custom.css">
</head>
<body>
<%
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String)session.getAttribute("userID");
	}
	if(userID != null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('Already signed in.')");
		script.println("location.href = 'index.jsp' ");
		script.println("</script>");
		script.close();
	}
%>
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="index.jsp">Course Evaluation Site</a>
			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div id="navbar" class="collapse navbar-collapse">
				<ul class="navbar-nav mr-auto">
					<li class="nav-item active">
						<a class="nav-link" href="index.jsp">Main</a>
					</li>
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown" >
							Account
						</a>
						<div class="dropdown-menu" aria-labelledby="dropdown">
<%
		if(userID == null){
%>
							<a class="dropdown-item" href="userLogin.jsp">Sign in</a>
							<a class="dropdown-item" href="userJoin.jsp">Sign up</a>
<%
		} else{	
%>
							<a class="dropdown-item" href="userLogout.jsp">Sign out</a>
<%
		}
%>
						</div>
					</li>
				</ul>
				<form action="./index.jsp" method="get" class="form-inline my-2 my-lg-0">
					<input type="text" name="search" class="form-control mr-sm-2" type="search" placeholder="type here" aria-label="search">
					<button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
				</form>
			</div>
	</nav>
	<section class="container mt-3" style="max-width: 560px;">
		<form method="post" action="./userLoginAction.jsp">
			<div class="form-group">
				<label>UserID</label>
				<input type="text" name="userID" class="form-control">
			</div>
			<div class="form-group">
				<label>UserPassword</label>
				<input type="password" name="userPassword" class="form-control">
			</div>
			<button type="submit" class="btn btn-primary">Sign in</button>
		</form>
	</section>
	<footer class="bg-dark mt-4 p-5 text-center" style="color:#FFFFFF;">
		Copyright &copy; 2018 나동빈 All Rights Reserved. 
	</footer>

	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!-- 파퍼 자바스크립트 추가하기 -->
	<script src="./js/popper.js"></script>
	<!-- 부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
</body>
</html>