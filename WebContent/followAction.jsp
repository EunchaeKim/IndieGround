<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.BbsDAO"%>
<%@ page import="model.UserDAO"%>
<%@ page import="model.Bbs"%>
<%@ page import="java.io.PrintWriter"%>
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
	
	UserDAO userDAO = new UserDAO();
	
	String artistname=null;
	String artistid=null;
	
	if(request.getParameter("follow")!=null){
		artistname=(String)request.getParameter("follow").replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;");
		artistid=userDAO.findUserID(artistname);
	}else{
		out.println("<script>");
		out.println("location.href='main.jsp'");
		out.println("</script>");
	}
	if(userID.equals(artistid)) {
		out.println("<script>");
		out.println("alert('same user!')");
		out.println("location.href='main.jsp'");
		out.println("</script>");
	}else {
		if(userDAO.dofollow(userID,artistid)!=-1) {
			out.println("<script>");
			out.println("alert('follow complete')");
			out.println("location.href='main.jsp'");
			out.println("</script>");
		}else{
			out.println("<script>");
			out.println("alert('DB Problem!')");
			out.println("location.href='main.jsp'");
			out.println("</script>");
		}
	}
	%>

</body>
</html>