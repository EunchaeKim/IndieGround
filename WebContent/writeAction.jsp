<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.BbsDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="model.UserDAO" %>
<%@ page import="model.Profile" %>
<%@ page import="java.util.ArrayList"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="model.Bbs" scope="page" />
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsContent" />
<jsp:setProperty name="bbs" property="bbsLocation" />
<jsp:setProperty name="bbs" property="bbsGenre" />
<jsp:setProperty name="bbs" property="bbsTargetfund" />
<jsp:setProperty name="bbs" property="bbsDeadline" />
<jsp:setProperty name="bbs" property="bbsConcertday" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset="UTF-8">
<title>IndieGround</title>
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
	}else{
		
		if(bbs.getBbsTitle()==null||bbs.getBbsContent()==null){
					PrintWriter script=response.getWriter();
					script.println("<script>");
					script.println("alert('입력 누락')");
					script.println("history.back()");
					script.println("</script>");
		}else{
			
			BbsDAO bbsDAO = new BbsDAO();
			ArrayList<Profile> artist = new ArrayList<Profile>();
			if((ArrayList<Profile>)session.getAttribute("lineup")==null){
				PrintWriter script=response.getWriter();
				script.println("<script>");
				script.println("alert('아티스트 입력 누락')");
				script.println("history.back()");
				script.println("</script>");
			}
			artist=(ArrayList<Profile>)session.getAttribute("lineup");
			for(int i=0;i<artist.size();i++){
				int result=bbsDAO.lineup(artist.get(i).getName());
				if(result==-1){
					PrintWriter script=response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다')");
					script.println("history.back()");
					script.println("</script>");
				}
			}
			int result=bbsDAO.write(bbs.getBbsTitle(),userID,bbs.getBbsContent(),bbs.getBbsLocation(),bbs.getBbsGenre(),bbs.getBbsTargetfund(),bbs.getBbsDeadline(),bbs.getBbsConcertday());
			if(result==-1){
				PrintWriter script=response.getWriter();
				script.println("<script>");
				script.println("alert('글쓰기에 실패했습니다')");
				script.println("history.back()");
				script.println("</script>");
			}
			else {
				PrintWriter script=response.getWriter();
				script.println("<script>");
				script.println("location.href='bbs.jsp'");
				script.println("</script>");
			}
					
		}
		
	}
	%>

</body>
</html>