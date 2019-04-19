<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="model.DBUtil"%>
<%@ page import="web.DBConnectionManage"%>
<%@ page import="web.DoLogIn"%>
<%@ page import="model.Bbs"%>
<%@ page import="model.BbsDAO"%>
<%@ page import="model.UserDAO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%
    request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset="UTF-8">
<meta name="viewport" content="width-device-width" , initial-scale="1">
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
	int pageNumber=1;
	if(request.getParameter("pageNumber")!=null){
		pageNumber=Integer.parseInt(request.getParameter("pageNumber"));
	}
	
	UserDAO userDAO = new UserDAO();
	
	String userID = null;

	if (session.getAttribute("uid") != null) {
		userID = (String) session.getAttribute("uid");
	}
	ArrayList<Bbs> list=new ArrayList<Bbs>();
	if (session.getAttribute("searchBbslist") != null) {
		list = (ArrayList<Bbs>)session.getAttribute("searchBbslist");
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
		<div class="row">
			<div class="col-sm-2">
				<a href="write.jsp" class="btn btn-primary">공연 기획하기</a>
			</div>
			<div class="col-sm-2">
					<a href="searchArtistInfo.jsp" class="btn btn-primary">아티스트 검색하기</a>
			</div>
			<div class="col-sm-2">
				<a href="bbs.jsp" class="btn btn-primary">전체 글 목록</a><br>
				<br>
			</div>
		</div>
		<hr>
	</div>

	<div class="container">

		<form action="searchConcertAction.jsp" accept-charset="utf-8" name="search" method="POST">
			<div class="col-md-2">
				<fieldset style="width: 350">
					<br>지역<br> <select name="bbsLocation"
						style="width: 100px;">
						<optgroup label="지역">
							<option value="allLoc">전체</option>
							<option value="seoul">서울</option>
							<option value="gyunggi">경기</option>
							<option value="daegu">대구</option>
							<option value="busan">부산</option>
						</optgroup>
					</select>
				</fieldset>
			</div>
			<div class="col-md-2">
				<fieldset style="width: 350">

					<br>장르<br> <select name="bbsGenre" style="width: 100px;">
						<optgroup label="장르">
							<option value="allGen">전체</option>
							<option value="HipHop">힙합</option>
							<option value="Rock">락</option>
							<option value="RnB">알앤비</option>
						</optgroup>
					</select>
				</fieldset>
			</div>
			<div class="row">
				<fieldset style="width: 350">
					<h5>글 제목</h5>
					<input type="text" name="bbsTitle" size="50" style="height: 30px;">

					<input type="submit" value="검색" class="btn btn-default" /><br>
					<br>
				</fieldset>
			</div>
		</form>
	</div>

	<div class="container">
		<table class="table table-striped"
			style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th style="background-color: #eeeeee; text-align: center;">번호</th>
					<th style="background-color: #eeeeee; text-align: center;">제목</th>
					<th style="background-color: #eeeeee; text-align: center;">작성자</th>
					<th style="background-color: #eeeeee; text-align: center;">장소</th>
					<th style="background-color: #eeeeee; text-align: center;">장르</th>
					<th style="background-color: #eeeeee; text-align: center;">현재
						모금액</th>
					<th style="background-color: #eeeeee; text-align: center;">목표
						모금액</th>
					<th style="background-color: #eeeeee; text-align: center;">펀딩
						마감일</th>
					<th style="background-color: #eeeeee; text-align: center;">공연
						예정일</th>
					<th style="background-color: #eeeeee; text-align: center;">작성일</th>
				</tr>
			</thead>
			<tbody>

				<%
				//ArrayList<Bbs> list=bbsDAO.getList(pageNumber);
				for(int i=0 ; i<list.size() ; i++){
					%>
				<tr>
					<td><%= list.get(i).getBbsID()%></td>
					<td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></a></td>
					<td><%= list.get(i).getUserID() %></td>
					<td><%= list.get(i).getBbsLocation()%></td>
					<td><%= list.get(i).getBbsGenre()%></td>
					<td><%= list.get(i).getBbsCurrfund()%></td>
					<td><%= list.get(i).getBbsTargetfund()%></td>
					<td><%= list.get(i).getBbsDeadline()%></td>
					<td><%= list.get(i).getBbsConcertday()%></td>
					<td><%= list.get(i).getBbsDate().substring(0,11)+list.get(i).getBbsDate().substring(11,13)+"시 "+list.get(i).getBbsDate().substring(14,16)+"분"%></td>
				</tr>
				<%
				}
			
			%>

			</tbody>
		</table>
	</div>


	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>