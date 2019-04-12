<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.UserDAO" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="evaluation.EvaluationDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width-device-width, initial-scale = 1, shrink-to-fit-no">
	<title>Course Evaluation Site </title>
	
	<!--부트스트랩 CSS  -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- 커스텀 CSS -->
	<link rel="stylesheet" href="./css/custom.css">
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
	String lectureDivide = "All";
	String searchType = "Newest";
	String search = "";
	int pageNumber = 0;
	
	if(request.getParameter("lectureDivide") != null){
		lectureDivide = request.getParameter("lectureDivide");
	}
	if(request.getParameter("searchType") != null){
		searchType = request.getParameter("searchType");
	}
	if(request.getParameter("search") != null){
		search = request.getParameter("search");
	}
	if(request.getParameter("pageNumber") != null){
		try{
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
		catch(Exception e){
			System.out.println("pageNumber error");
		}
	}
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String)session.getAttribute("userID");
	}
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('Please sign in')");
		script.println("location.href = 'userLogin.jsp' ");
		script.println("</script>");
		script.close();
	}
	boolean emailChecked = new UserDAO().getUserEmailChecked(userID);
	if(emailChecked == false){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'emailSendConfirm.jsp' ");
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
	<div class="container">
		<form method="get" action="./index.jsp" class="form-inline mt-3">
			<select name="lectureDivide" class="form-control mx-1 mt-2">
				<option value="All">All</option>
				<option value="Major" <% if(lectureDivide.equals("Major")) out.println("selected"); %>>Major</option>
				<option value="Elective" <% if(lectureDivide.equals("Elective")) out.println("selected"); %>>Elective</option>
				<option value="etc" <% if(lectureDivide.equals("etc")) out.println("selected"); %>>etc</option>
			</select>
			<select name="searchType" class="form-control mx-1 mt-2">
				<option value="Newest">Newest</option>
				<option value="Most liked" <% if(searchType.equals("Most liked")) out.println("selected"); %>>Most liked</option>
			</select>
			<input type="text" name="search" class="form-control mx-1 mt-2" placeholder="type here">
			<button type="submit" class="btn btn-primary mx-1 mt-2">Search</button>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#registerModal">Register</a>
			<a class="btn btn-danger mx-1 mt-2" data-toggle="modal" href="#reportModal">Report</a>
		</form>
<%
	ArrayList<EvaluationDTO> evaluationList = new ArrayList<EvaluationDTO>();
	evaluationList = new EvaluationDAO().getList(lectureDivide, searchType, search, pageNumber);
	if(evaluationList != null){
		for(int i=0; i<evaluationList.size(); i++){
			if(i==5) break;
			EvaluationDTO evaluation = evaluationList.get(i);
%>
	     <div class="card bg-light mt-3">
	        <div class="card-header bg-light">
	          <div class="row">
	            <div class="col-8 text-left"><%=evaluation.getLectureName()%>&nbsp;<small><%=evaluation.getProfessorName()%></small></div>
	            <div class="col-4 text-right">
	              Total <span style="color: red;"><%=evaluation.getTotalScore()%></span>
	            </div>
	          </div>
	        </div>
	        <div class="card-body">
	          <h5 class="card-title">
	            <%=evaluation.getEvaluationTitle()%>&nbsp;<small>(<%=evaluation.getSemesterDivide()%> <%=evaluation.getLectureYear()%>)</small>
	          </h5>
	          <p class="card-text"><%=evaluation.getEvaluationContent()%></p>
	          <div class="row">
	            <div class="col-9 text-left">
	              Credit <span style="color: red;"><%=evaluation.getCreditScore()%></span>
	              Comfortable <span style="color: red;"><%=evaluation.getComfortableScore()%></span>
	              Course <span style="color: red;"><%=evaluation.getLectureScore()%></span>
	              <span style="color: green;">(Like: <%=evaluation.getLikeCount()%>)</span>
	            </div>
	            <div class="col-3 text-right">
	              <a onclick="return confirm('Do you want to press like?')" href="./likeAction.jsp?evaluationID=<%=evaluation.getEvaluationID()%>">Like</a>
	              <a onclick="return confirm('Do you really want to delete it?')" href="./deleteAction.jsp?evaluationID=<%=evaluation.getEvaluationID()%>">Delete</a>
	            </div>
	          </div>
	        </div>
	      </div>
<%
		}
	}
%>
	</div>
	
	<ul class="pagination justify-content-center mt-3">
		<li class="page-item">
	<%
	if(pageNumber <= 0) {
	%>     
        <a class="page-link disabled">Previous</a>
	<%
	} else {
	%>
		<a class="page-link" href="./index.jsp?lectureDivide=<%=URLEncoder.encode(lectureDivide, "UTF-8")%>
		&searchType=<%=URLEncoder.encode(searchType, "UTF-8")%>
		&search=<%=URLEncoder.encode(search, "UTF-8")%>
		&pageNumber=<%=pageNumber - 1%>">Previous</a>
	<%
	}
	%>
      </li>
      <li class="page-item">
	<%
	if(evaluationList.size() < 6) {
	%>     
        <a class="page-link disabled">Next</a>
	<%
	} else {
	%>
		<a class="page-link" href="./index.jsp?lectureDivide=<%=URLEncoder.encode(lectureDivide, "UTF-8")%>
		&searchType=<%=URLEncoder.encode(searchType, "UTF-8")%>
		&search=<%=URLEncoder.encode(search, "UTF-8")%>
		&pageNumber=<%=pageNumber + 1%>">Next</a>
	<%
	}
	%>
		</li>
	</ul>
	
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">Course Evaluation</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="./evaluationRegisterAction.jsp" method="post">
						<div class="form-row">
							<div class="form-group col-sm-6">
								<label>Course</label>
								<input type="text" name="lectureName" class="form-control" maxlength="20">
							</div>
							<div class="form-group col-sm-6">
								<label>Professor</label>
								<input type="text" name="professorName" class="form-control" maxlength="20">
							</div>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-4">
								<label>Course Year</label>
								<select name="lectureYear" class="form-control">
									<option value="2011">2011</option>
									<option value="2012">2012</option>
									<option value="2013">2013</option>
									<option value="2014">2014</option>
									<option value="2015">2015</option>
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018" selected>2018</option>
									<option value="2019">2019</option>
									<option value="2020">2020</option>
									<option value="2021">2021</option>
									<option value="2022">2022</option>
									<option value="2023">2023</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>Course Semester</label>
								<select name="semesterDivide" class="form-control">
									<option value="fall" selected>Fall</option>
									<option value="winter">Winter</option>
									<option value="spring">Spring</option>
									<option value="summer">Summer</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>Course Division</label>
								<select name="lectureDivide" class="form-control">
									<option value="major" selected>Major</option>
									<option value="elective">Elective</option>
									<option value="etc">etc</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label>Title</label>
							<input type="text" name="evaluationTitle" class="form-control" maxlength="30">
						</div>
						<div class="form-group">
							<label>Content</label>
							<textarea name="evaluationContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-3">
								<label>Total</label>
								<select name="totalScore" class="form-control">
									<option value="A">A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>Credit</label>
								<select name="creditScore" class="form-control">
									<option value="A">A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>Comfortable</label>
								<select name="comfortableScore" class="form-control">
									<option value="A">A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>Course</label>
								<select name="lectureScore" class="form-control">
									<option value="A">A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
							<button type="submit" class="btn btn-primary">Evaluate</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div> 
	<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">Report</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="./reportAction.jsp" method="post">
						<div class="form-group">
							<label>Report Title</label>
							<input type="text" name="reportTitle" class="form-control" maxlength="30">
						</div>
						<div class="form-group">
							<label>Report Content</label>
							<textarea name="reportContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
							<button type="submit" class="btn btn-danger">Report</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div> 
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