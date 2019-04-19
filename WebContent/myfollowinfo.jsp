<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="model.DBUtil"%>
<%@ page import="web.DBConnectionManage"%>
<%@ page import="web.DoLogIn"%>
<%@ page import="model.UserDAO"%>
<%@ page import="model.BbsDAO"%>
<%@ page import="model.Bbs"%>
<%@ page import="model.Profile"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/coding.css">
<title>IndieGround</title>
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
	}else {
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요')");
		script.println("location.href='login.jsp'");
		script.println("</script>");
	}
	
	BbsDAO bbsDAO = new BbsDAO();
	ArrayList<Bbs> alist=bbsDAO.getrequestlist(userDAO.getNickname(userID));
	int alert=0;
	if(alist!=null){
		for(int i=0;i<alist.size();i++){
			if(bbsDAO.artistParticipate(userDAO.getNickname(userID),alist.get(i).getBbsID()).equals("섭외중")){
				alert++;
			};
		}
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
						</ul></li>
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
						} else if(userDAO.isAdmin(userID)==0){
					%>
					<li><a><%=userDAO.getNickname(userID)%>님 로그인됨</a></li>
					<li><a href="myinfo.jsp">내 정보</a></li>
					<li><a href="bbs.jsp">글목록</a></li>
					<%
						if(alert<1){
					%>
					<li><a href="myalertinfo.jsp">알림</a></li>
					<%
						}else{
					%>
					<li><a href="myalertinfo.jsp">알림<span class="badge badge-primary"><%= alert%></span></a></li>
					<%
						}
					%>
					<li class="dropdown"><a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="carrot"></span></a>
						<ul class="dropdown-menu">
							<li><a href="logout.jsp">로그아웃</a></li>
						</ul></li>
				</ul>
				<%
					}
				}
				%>
			</div>
		</div>
	</nav>
	<div class="container">
		<div class="col-md-2">
				<p class="text-center">
					<img src="images/<%=userDAO.getFilename(userID)%>"
						style="width: 150px; height: 150px;">
				</p>
				<h4 class="text-center"><%=userDAO.getNickname(userID)%></h4>
				<p class="text-center">
					<a class="btn btn-default" href="myinfo.jsp">프로필
						보기</a>
				</p>
				<p class="text-center">
					<a class="btn btn-default" href="myfollowinfo.jsp">Follow 목록</a>
				</p>
				<p class="text-center">
					<a class="btn btn-default" href="myfundinfo.jsp">펀딩한 공연</a>
				</p>
				<p class="text-center">
					<a class="btn btn-default" href="myconcertinfo.jsp">기획한 공연</a>
				</p>
			</div>
			<div class="col-md-10">
				<div class="row">
				<h3 class="maintxt">팔로잉 목록</h3>
				<% 
			ArrayList<Profile> following_list=userDAO.getFollowingList(userID);
			for(int i=0 ; i<following_list.size(); i++){
				
				if (following_list.get(i).getGenre() == null) {
					following_list.get(i).setGenre("");
				}
	    					%>
				<div class="col-md-2">
					<img src="images/<%= following_list.get(i).getFilename()%>"
						style="width: 150px; height: 150px;">
					<h4><%=following_list.get(i).getName()%></h4>
					<p>
						장르 :
						<%= following_list.get(i).getGenre()%></p>
					<p>
						<a class="btn btn-default" data-target="#artist<%= i%>"
							data-toggle="modal">프로필 보기</a>
					</p>
				</div>
				<%
	        }
	        %>
	        </div>
				<hr>
				<div class="row">
				<h3 class="maintxt">팔로워 목록</h3>
				<%
			ArrayList<Profile> follower_list=userDAO.getFollowerList(userID);
			for(int i=0 ; i<follower_list.size(); i++){
				
	    					
	    					%><div class="col-md-2">
					<img src="images/<%= follower_list.get(i).getFilename()%>"
						style="width: 150px; height: 150px;">
					<h4><%= follower_list.get(i).getName()%></h4>
					<p>
						장르 :
						<%= follower_list.get(i).getGenre()%></p>
					<p>
						<a class="btn btn-default" data-target="#<%= i%>"
							data-toggle="modal">프로필 보기</a>
					</p>
				</div>

				<%
	        }
	        %>
			</div>
		</div>
		</div>
	<% 
			for(int i=0 ; i<follower_list.size(); i++){
	
	    			%>
	<div class="row">
		<div class="modal" id="<%= i%>" tabindex="-1">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						아티스트 프로필
						<button class="close" data-dismiss="modal">&times;</button>
					</div>
					<div class="modal-body" style="text-align: center;">
						<form method="post" action="DoUpdateArtist">
							<img src="images/<%= follower_list.get(i).getFilename()%>"
								id="imagepreview" style="width: 150px; height: 150px;"><br><h4><%= follower_list.get(i).getName()%></h4>
							장르 :
							<%= follower_list.get(i).getGenre()%><br> 음원사이트 URL :
							<%= follower_list.get(i).getUrl_music()%><br> SNS URL :
							<%= follower_list.get(i).getUrl_sns()%><br> 자기소개 : <br>
							<%= follower_list.get(i).getSelf_introduction()%><br>
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
				
	        for(int i=0 ; i<following_list.size(); i++){
	    					
	    					%>
	<div class="row">
		<div class="modal" id="artist<%= i%>" tabindex="-1">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						아티스트 프로필
						<button class="close" data-dismiss="modal">&times;</button>
					</div>
					<div class="modal-body" style="text-align: center;">
						<form method="post" action="unfollowAction.jsp">
						<img src="images/<%= following_list.get(i).getFilename()%>"
							id="imagepreview" style="width: 150px; height: 150px;"><br><h4><%= following_list.get(i).getName()%></h4> 장르 :
						<%= following_list.get(i).getGenre()%><br> 음원사이트 URL :
						<%= following_list.get(i).getUrl_music()%><br> SNS URL :
						<%= following_list.get(i).getUrl_sns()%><br> 자기소개 : <br>
						<%= following_list.get(i).getSelf_introduction()%><br><br>
						
						<button type="submit" name="unfollow" value=<%=following_list.get(i).getName().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;")%>>unfollow</button>
						</form>
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