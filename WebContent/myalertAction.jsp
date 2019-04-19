<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.BbsDAO"%>
<%@ page import="model.Bbs"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="model.UserDAO"%>
<%@ page import="model.Profile"%>
<%@ page import="java.util.ArrayList"%>

<%
	request.setCharacterEncoding("UTF-8");
%>
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

		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요')");
			script.println("location.href='login.jsp'");
			script.println("</script>");
		} else {
			PrintWriter script = response.getWriter();
			String[] chknum;
			BbsDAO bbsDAO = new BbsDAO();
			UserDAO userDAO = new UserDAO();
			ArrayList<Bbs> list = new ArrayList<Bbs>();
			//bbsDAO.acceptParticipate(userDAO.getNickname(userID));
			if (session.getAttribute("alertlist") != null) {
				list = (ArrayList<Bbs>) session.getAttribute("alertlist");

				if (request.getParameterValues("chked") != null) {
					chknum = request.getParameterValues("chked");
					for (int i = 0; i < chknum.length; i++) {
						int num = Integer.parseInt(chknum[i]);

						if (request.getParameter("admit") != null) {
							if (bbsDAO.acceptParticipate(userDAO.getNickname(userID),
									list.get(num).getBbsID()) == -1) {
								script.println("<script>");
								script.println("alert('DB Error!!')");
								script.println("location.href='myalertinfo.jsp'");
								script.println("</script>");
							}
						} else {
							if (bbsDAO.declineParticipate(userDAO.getNickname(userID),
									list.get(num).getBbsID()) == -1) {
								script.println("<script>");
								script.println("alert('DB Error!!')");
								script.println("location.href='myalertinfo.jsp'");
								script.println("</script>");
							}
						}
					}
					script.println("<script>");
					script.println("location.href='myalertinfo.jsp'");
					script.println("</script>");
				} else if (request.getParameterValues("chked") == null) {
					script.println("<script>");
					script.println("alert('아무것도 체크하지 않았습니다!')");
					script.println("location.href='myalertinfo.jsp'");
					script.println("</script>");
				}
			} else if (session.getAttribute("alertlist") == null) {
				script.println("<script>");
				script.println("alert('목록에 아무것도 없습니다!')");
				script.println("location.href='myalertinfo.jsp'");
				script.println("</script>");
			}
		}
	%>

</body>
</html>