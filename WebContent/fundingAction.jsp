<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.BbsDAO"%>
<%@ page import="model.Profile"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
<title>IndieGround</title>
<meta http-equiv="Content-Type" content="text/html; charset="UTF-8">
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("uid") != null) {
			userID = (String) session.getAttribute("uid");
		}

		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요')");
			script.println("location.href='login.jsp'");
			script.println("</script>");
		} else {
			PrintWriter script = response.getWriter();
			BbsDAO bbsDAO=new BbsDAO();
			int bbsID=(int)session.getAttribute("bbsID");
			if(request.getParameterValues("fund")!=null){
				for(int i=0;i<request.getParameterValues("fund").length;i++){
					int num=0;
					if(!request.getParameterValues("fund")[i].equals("")){
						num=Integer.parseInt(request.getParameterValues("fund")[i]);
					}
					if(bbsDAO.setFund(bbsID,num)!=-1&&bbsDAO.fundingConcert(userID, bbsID, num)!=-1){
						script.println("<script>");
						script.println("alert('펀딩 완료!')");
						script.println("location.href='bbs.jsp'");
						script.println("</script>");
					}else{
						script.println("<script>");
						script.println("alert('DB Error!')");
						script.println("location.href='bbs.jsp'");
						script.println("</script>");
					}
				}
			}else{
				script.println("<script>");
				script.println("alert('fund input is empty!!')");
				script.println("history.back()");
				script.println("</script>");
			}
			
		}
		%>
</body>
</html>