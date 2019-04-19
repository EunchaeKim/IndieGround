<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.BbsDAO"%>
<%@ page import="model.UserDAO"%>
<%@ page import="model.Bbs"%>
<%@ page import="model.DBUtil"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="artist" class="model.Profile" scope="page"/>
<jsp:setProperty name="artist" property="name"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset="UTF-8">
<title>indieGround</title>
</head>
<body>
	<%
	
	String userID = null;
	if (session.getAttribute("uid") != null) {
		userID = (String) session.getAttribute("uid");
	}

	if(userID==null){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요')");
		script.println("location.href='login.jsp'");
		script.println("</script>");
	}
	
	UserDAO userDAO=new UserDAO();
	
	int result=userDAO.findExistArtist(userID);
	
	if(result==2){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('retry success!')");
		script.println("location.href='myinfo.jsp'");
		script.println("</script>");
	}else if(result==1){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('apply success!')");
		script.println("location.href='myinfo.jsp'");
		script.println("</script>");
	}else if(result==-2){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('already applied!')");
		script.println("location.href='myinfo.jsp'");
		script.println("</script>");
	}else if(result==-1){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('DB Error!')");
		script.println("location.href='myinfo.jsp'");
		script.println("</script>");
	}
	
	
	%>

</body>
</html>