<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Address"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Session"%>
<%@page import="javax.mail.Authenticator"%>
<%@ page import="java.util.Properties " %>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="util.Gmail" %>
<%@ page import="java.io.PrintWriter"%>

<%
	UserDAO userDAO = new UserDAO();
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String)session.getAttribute("userID");
	}
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('Please sign in.');");
		script.println("location.href = 'userLogin.jsp' ");
		script.println("</script>");
		script.close();
		return;
	}
	
	request.setCharacterEncoding("UTF-8");
	String reportTitle = null;
	String reportContent = null;
	if(request.getParameter("reportTitle") != null){
		reportTitle = request.getParameter("reportTitle");
	}
	if(request.getParameter("reportContent") != null){
		reportContent = request.getParameter("reportContent");
	}
	if(reportTitle == null || reportContent == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('Please fill in the blank.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	String host = "http://localhost:8080/Lecture_Evaluation/";
	String from = "chanjini0801@gmail.com";
	String to = "chanjini0801@naver.com";
	String subject = "Report mail is arrived from the Course Evaluation site. ";
	String content = "Reporter: " + userID +
						"<br>Title: " + reportTitle +
						"<br>Content: " + reportContent;
	
		
	//SMTP 접속하기 위한 정보 기입. 
	Properties p = new Properties();
	p.put("mail.smtp.user", from);
	p.put("mail.smtp.host", "smtp.googlemail.com");
	p.put("mail.smtp.port", "465");
	p.put("mail.smtp.starttls.enable", "true");
	p.put("mail.smtp.auth", "true");
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");
	
	try{
		Authenticator auth = new Gmail();
		Session ses = Session.getInstance(p, auth);
		ses.setDebug(true);
		MimeMessage msg = new MimeMessage(ses);
		msg.setSubject(subject);
		Address fromAddr = new InternetAddress(from);
		msg.setFrom(fromAddr);
		Address toAddr = new InternetAddress(to);
		msg.addRecipient(Message.RecipientType.TO, toAddr);
		msg.setContent(content, "text/html;charset=UTF-8");
		Transport.send(msg);
	}
	catch(Exception e){
	 	e.printStackTrace();
	 	PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('Error');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
	}
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('It is reported successfully.');");
	script.println("history.back();");
	script.println("</script>");
	script.close();


%>
