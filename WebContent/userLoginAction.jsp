<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%>

<%
	request.setCharacterEncoding("UTF-8");
	String userID = null;
	String userPassword = null;
	if(request.getParameter("userID") != null) {
		userID = (String) request.getParameter("userID");
	}
	if(request.getParameter("userPassword") != null) {
		userPassword = (String) request.getParameter("userPassword");
	}
	if(userID == null || userPassword == null || userID.equals("") || userPassword.equals("")) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('Please fill in the blank.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
	}
	else{
		UserDAO userDAO = new UserDAO();
		int result = userDAO.login(userID, userPassword);
		if (result == 1) {
			session.setAttribute("userID", userID);
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'index.jsp' ");
			script.println("</script>");
			script.close();
		} 
		else if(result == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('Wrong password')");
			script.println("history.back();");
			script.println("</script>");
			script.close();
		}
		else if(result == -1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('Invalid userID')");
			script.println("history.back();");
			script.println("</script>");
			script.close();
		}
		else if(result == -2) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('Database error')");
			script.println("history.back();");
			script.println("</script>");
			script.close();
		}
	}
		
%>








