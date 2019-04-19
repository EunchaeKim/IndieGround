<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Bbs"%>
<%@ page import="model.BbsDAO"%>
<%@ page import="model.Profile"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<jsp:useBean id="bbs" class="model.Bbs" scope="page" />
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsLocation" />
<jsp:setProperty name="bbs" property="bbsGenre" />
<%
    request.setCharacterEncoding("utf-8");
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
			ArrayList<Bbs> bbslist=bbsDAO.getSearchList(bbs.getBbsLocation(),bbs.getBbsGenre(),bbs.getBbsTitle());
			if(bbslist!=null){
				
				session.setAttribute("searchBbslist",bbslist);
				
				script.println("<script>");
				script.println("location.href='search.jsp'");
				script.println("</script>");
			}else{
				script.println("<script>");
				script.println("alert('검색 실패!')");
				script.println("history.back()");
				script.println("</script>");
			}
		}
		%>
</body>
</html>