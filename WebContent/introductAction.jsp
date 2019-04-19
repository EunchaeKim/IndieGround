<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.BbsDAO"%>
<%@ page import="model.UserDAO"%>
<%@ page import="model.Bbs"%>
<%@ page import="java.io.PrintWriter"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="profile" class="model.Profile" scope="page"/>
<jsp:setProperty name="profile" property="name"/>
<jsp:setProperty name="profile" property="self_introduction"/>
<jsp:setProperty name="profile" property="genre"/>
<jsp:setProperty name="profile" property="url_music"/>
<jsp:setProperty name="profile" property="url_sns"/>
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
	
	UserDAO userDAO = new UserDAO();
	if(userDAO.avoidDupName(profile.getName())!=null){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('exist name!')");
		script.println("location.href='myinfo.jsp'");
		script.println("</script>");
	}else if(userDAO.uploadIntroduction(userID,profile.getName(),profile.getSelf_introduction()
			,profile.getUrl_music(),profile.getUrl_sns(),profile.getGenre())!=-1){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('프로필 수정 완료')");
		script.println("location.href='myinfo.jsp'");
		script.println("</script>");
	}
	%>

</body>
</html>