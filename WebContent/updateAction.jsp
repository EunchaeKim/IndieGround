<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.BbsDAO"%>
<%@ page import="model.Bbs"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="model.Profile" %>
<%@ page import="java.util.ArrayList"%>
<% request.setCharacterEncoding("UTF-8"); %>
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
	}
	
	int bbsID=0;
	if(request.getParameter("bbsID")!=null){
		bbsID=Integer.parseInt(request.getParameter("bbsID"));
		session.setAttribute("bbsIDForEdit", bbsID);
	}else if(session.getAttribute("bbsIDForEdit")!=null){
		bbsID=(int)session.getAttribute("bbsIDForEdit");
	}
	if(bbsID==0){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글입니다')");
		script.println("location.href='bbs.jsp'");
		script.println("</script>");
	}
	
	Bbs bbs=new BbsDAO().getBbs(bbsID);
	if(!userID.equals(bbs.getUserID())){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('권한이 없습니다')");
		script.println("location.href='bbs.jsp'");
		script.println("</script>");
	}else{
		if(request.getParameter("bbsTitle")==null||request.getParameter("bbsContent")==null||
				request.getParameter("bbsTitle").equals("")||request.getParameter("bbsContent").equals("")){ // 여기서 넘어온 값을 아래에서 체크
					PrintWriter script=response.getWriter();
					script.println("<script>");
					script.println("alert('입력 누락')");
					script.println("history.back()");
					script.println("</script>");
		}else{
			BbsDAO bbsDAO = new BbsDAO();
			ArrayList<Profile> artist = new ArrayList<Profile>();
			if((ArrayList<Profile>)session.getAttribute("lineupEdit")==null){
				PrintWriter script=response.getWriter();
				script.println("<script>");
				script.println("alert('아티스트 입력 누락')");
				script.println("history.back()");
				script.println("</script>");
			}
			artist=(ArrayList<Profile>)session.getAttribute("lineupEdit");
			bbsDAO.deletelineup(bbsID);
			for(int i=0;i<artist.size();i++){
				int result=bbsDAO.updateLineup(bbsID,artist.get(i).getName());
				if(result==-1){
					PrintWriter script=response.getWriter();
					script.println("<script>");
					script.println("alert('글수정에 실패했습니다')");
					script.println("history.back()");
					script.println("</script>");
				}
			}
			int targetFund= Integer.parseInt(request.getParameter("bbsTargetfund"));
			int result=bbsDAO.update(bbsID,request.getParameter("bbsTitle"),request.getParameter("bbsContent"),request.getParameter("bbsLocation"),
					request.getParameter("bbsGenre"),targetFund,request.getParameter("bbsDeadline"),request.getParameter("bbsConcertday"));
			if(result==-1){
				PrintWriter script=response.getWriter();
				script.println("<script>");
				script.println("alert('글 수정이 실패했습니다')");
				script.println("history.back()");
				script.println("</script>");
			}
			else {
				PrintWriter script=response.getWriter();
				script.println("<script>");
				script.println("alert('글수정 성공')");
				script.println("location.href='bbs.jsp'");
				script.println("</script>");
			}
					
		}
		
	}
	%>

</body>
</html>