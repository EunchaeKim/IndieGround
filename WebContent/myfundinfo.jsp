<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="model.DBUtil"%>
<%@ page import="web.DBConnectionManage"%>
<%@ page import="web.DoLogIn"%>
<%@ page import="model.BbsDAO" %>
<%@ page import="model.UserDAO" %>
<%@ page import="model.Bbs" %>
<%@ page import="java.util.ArrayList" %>
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
		PrintWriter script=response.getWriter();
		
		if (session.getAttribute("uid") != null) {
			userID = (String) session.getAttribute("uid");
		}else {
			script.println("<script>");
			script.println("alert('로그인을 하세요')");
			script.println("location.href='login.jsp'");
			script.println("</script>");
		}
		
		BbsDAO bbsDAO = new BbsDAO();
		ArrayList<Bbs> list=bbsDAO.getrequestlist(userDAO.getNickname(userID));
		int alert=0;
		if(list!=null){
			for(int i=0;i<list.size();i++){
				if(bbsDAO.artistParticipate(userDAO.getNickname(userID),list.get(i).getBbsID()).equals("섭외중")){
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
	<div class="col-md-2">
		<p class="text-center">
			<img src="images/<%=userDAO.getFilename(userID)%>" style="width: 150px; height: 150px;">
		</p>
		<h4 class="text-center"><%=userDAO.getNickname(userID)%></h4>
		<p class="text-center">
			<a class="btn btn-default" data-target="#modal" data-toggle="modal">프로필 보기</a>
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
	<div class="col-md-8">
	<div class="container">
	<h4>내가 펀딩한 공연</h4>
		<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
				<th style="background-color:#eeeeee; text-align:center;">제목</th>
				<th style="background-color:#eeeeee; text-align:center;">작성자</th>
				<th style="background-color:#eeeeee; text-align:center;">장소</th>
				<th style="background-color:#eeeeee; text-align:center;">펀딩 마감일</th>
				<th style="background-color:#eeeeee; text-align:center;">공연 예정일</th>
				<th style="background-color:#eeeeee; text-align:center;">내 펀딩금액</th>
				</tr>
			</thead>
			<tbody>
			
			<%
				ArrayList<Bbs> myfundList=new ArrayList<Bbs>();
				myfundList=bbsDAO.getfundedlist(userID);
				if(myfundList!=null){
					
				for(int i=0 ; i<myfundList.size() ; i++){
					
					%>
				<tr>
					<td><a href="view.jsp?bbsID=<%= myfundList.get(i).getBbsID() %>"><%= myfundList.get(i).getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></a></td>
					<td><%= myfundList.get(i).getUserID() %></td>
					<td><%= myfundList.get(i).getBbsLocation()%></td>
					<td><%= myfundList.get(i).getBbsDeadline()%></td>
					<td><%= myfundList.get(i).getBbsConcertday()%></td>
					<td><%= bbsDAO.getfundedmoney(userID,myfundList.get(i).getBbsID())%></td>
				</tr>
			<%
				}

			}
			%>
				
			</tbody>
		</table>
	</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>