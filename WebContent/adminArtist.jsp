<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="model.DBUtil"%>
<%@ page import="web.DBConnectionManage"%>
<%@ page import="web.DoLogIn"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="model.UserDAO" %>
<%@ page import="model.Profile" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
<meta name="viewport" content="width-device-width" ,initial-scale="1">
<title>IndieGround</title>
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/coding.css">
<style type="text/css">
.jumbotron {
	background-image: url('images/evil.jpg');
	background-size: cover;
	text-shadow: black 0.2em 0.2em 0.2em;
	color: white;
}

.maintxt {
	color: black;
	text-align: center;
	font-weight: bold;
}
</style>
</head>
<body>
	<% 
UserDAO userDAO = new UserDAO();

String userID = null;

if (session.getAttribute("uid") != null) {
	userID = (String) session.getAttribute("uid");
}

%>
<nav class="navbar navbar-default">
<div class="container-fluid">
	<div class="navbar-header">
		<button type="button" class="navbar-toggle collapsed"
			data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
			aria-expanded="false">
			<span class="sr-only"></span> <span class="icon-bar"></span> <span
				class="icon-bar"></span> <span class="icon-bar"></span>
		</button>
		<a href="main.jsp" class="navbar-brand" 
				style="background-color: black">IndieGround</a>
	</div>
	<div class="collapse navbar-collapse"
		id="bs-example-navbar-collapse-1">
		<form class="navbar-form navbar-left">
			<div class="form-group">
				<input type="text" class="form-control" placeholder="내용을 입력하세요">
			</div>
			<a href="search.jsp" class="btn btn-default">검색</a>
		</form>

		<%
			if (userID == null) {
		%>
		<ul class="nav navbar-nav navbar-right">
			<li class="dropdown"><a href="#" class="dropdown-toggle"
				data-toggle="dropdown" role="button" aria-haspopup="true"
				aria-expanded="false">접속하기<span class="carrot"></span></a>
				<ul class="dropdown-menu">
					<li><a href="login.jsp">로그인</a></li>
					<li><a href="join.jsp">회원가입</a></li>
				</ul>
			</li>
		</ul>
		<%
			} else {
		%>
		<ul class="nav navbar-nav navbar-right">
			<%
				if (userDAO.isAdmin(userID) == 1) {
			%>
			<li><a>홈페이지 관리자 모드</a></li>
			<li><a href="adminArtist.jsp">아티스트 관리</a></li>
			<li><a href="logout.jsp">로그아웃</a></li>
			<%
				} else {
					
					out.println("<script>");
					out.println("alert('invalid access!!')");
					out.println("location.href='logout.jsp'");
					out.println("</script>");
					}
				}
		%>
		</ul>
	</div>
</div>
</nav>
	<div class="container">
	<div class="row">
		<h3 class="maintxt">아티스트 목록</h3>
		<% 
		ArrayList<Profile> artist_list=userDAO.getArtistList();
		for(int i=0 ; i<artist_list.size() ; i++){
			
			%>
			
		<div class="col-md-3">
			<img src="images/<%=artist_list.get(i).getFilename()%>"
				style="width: 150px; height: 150px;">
			<h4><%=artist_list.get(i).getName()%></h4>
			<p>
				장르 :
				<%=artist_list.get(i).getGenre()%></p>
			<p>
				<a class="btn btn-default" data-target="#artist<%=i%>"
					data-toggle="modal">프로필 보기</a>
			</p>
		</div>


		<%
			}
		%>
	</div>
	<hr>
	<div class="row">
		<h3 class="maintxt">아티스트 신청자</h3>
		<% 
		ArrayList<Profile> apply_list=userDAO.getApplyList();
		for(int i=0 ; i<apply_list.size() ; i++){
	    					
	    					%><div class="col-md-3">
			<img src="images/<%= apply_list.get(i).getFilename()%>" style="width: 150px; height: 150px;">
			<h4><%= apply_list.get(i).getName()%></h4>
			<p>
				장르 :
				<%= apply_list.get(i).getGenre()%></p>
			<p>
				<a class="btn btn-default" data-target="#<%= i%>"
					data-toggle="modal">프로필 자세히 보기</a>
			</p>
		</div>

		<%
	        }
	        %>
	</div>
	</div>
	<% 
	for(int i=0 ; i<apply_list.size() ; i++){
	        	%>
	<div class="row">
		<div class="modal" id="<%= i%>" tabindex="-1">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						신청자 프로필
						<button class="close" data-dismiss="modal">&times;</button>
					</div>
					<div class="modal-body" style="text-align: center;">
						<form method="post" action="AdmitAction.jsp">
							<img src="images/<%= apply_list.get(i).getFilename()%>" id="imagepreview"
								style="width: 150px; height: 150px;"><br><h4><%=apply_list.get(i).getName()%>
								</h4> 장르 :
							<%= apply_list.get(i).getGenre()%><br> 음원사이트 URL :
							<%= apply_list.get(i).getUrl_music()%><br> SNS URL :
							<%= apply_list.get(i).getUrl_sns()%><br> 자기소개 :
							<%= apply_list.get(i).getSelf_introduction()%><br> <button type="submit"
								name="admit" value=<%=apply_list.get(i).getName().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;")%>>admit</button> <button type="submit"
								name="decline" value=<%=apply_list.get(i).getName().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;")%>>decline</button><br>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
	        }
	    %>

	<%
		for (int i = 0; i < artist_list.size(); i++) {
	%>
	<div class="row">
		<div class="modal" id="artist<%=i%>" tabindex="-1">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						아티스트 프로필
						<button class="close" data-dismiss="modal">&times;</button>
					</div>
					<div class="modal-body" style="text-align: center;">
							<img src="images/<%=artist_list.get(i).getFilename()%>" id="imagepreview"
								style="width: 150px; height: 150px;"><br><h4><%=artist_list.get(i).getName()%>
								</h4> 장르 :
							<%=artist_list.get(i).getGenre()%><br> 음원사이트 URL :
							<%=artist_list.get(i).getUrl_music()%><br> SNS URL :
							<%=artist_list.get(i).getUrl_sns()%><br> 자기소개 :
							<%=artist_list.get(i).getSelf_introduction()%><br>
					</div>
				</div>
			</div>
		</div>

	</div>
	<%
		}
	%>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>

</body>
</html>