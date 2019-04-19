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
	
	
	if(request.getParameter("admit")!=null) {
		String applyname=request.getParameter("admit");
		String applyid=userDAO.findUserID(applyname);
		
		if(applyid!=null) {
			if(userDAO.apply_admit(applyid)!=-1){
				PrintWriter script=response.getWriter();
				script.println("<script>");
				script.println("alert('admit complete')");
				script.println("location.href='main.jsp'");
				script.println("</script>");
			}
		}
	}else if(request.getParameter("decline")!=null) {
		String applyname=request.getParameter("decline");
		String applyid=userDAO.findUserID(applyname);
		
		
		if(applyid!=null) {
			if(userDAO.apply_decline(applyid)!=-1) {
				PrintWriter script=response.getWriter();
				script.println("<script>");
				script.println("alert('decline complete')");
				script.println("location.href='main.jsp'");
				script.println("</script>");
			}
		}
		
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('something wrong!')");
		script.println("location.href='main.jsp'");
		script.println("</script>");
	}
	
	
	%>

</body>
</html>