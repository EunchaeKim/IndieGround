<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="model.DBUtil"%>
<%@ page import="web.DBConnectionManage"%>
<%@ page import="web.DoLogIn"%>
<%@ page import="model.BbsDAO" %>
<%@ page import="model.Bbs" %>
<%@ page import="model.UserDAO" %>
<%@ page import="model.Profile" %>
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
		String applydate="신청안함";
		String applyresult="신청안함";
		PrintWriter script=response.getWriter();
		
		if (session.getAttribute("uid") != null) {
			userID = (String) session.getAttribute("uid");
			
			if(!userDAO.getApplyDate(userID).equals("")&&!userDAO.getApplyResult(userID).equals("")){
				applydate=userDAO.getApplyDate(userID);
				applyresult=userDAO.getApplyResult(userID);
			}
		}else {
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
	<div class="row">
	<fieldset>
		<legend>프로필 사진 업로드</legend>
		<form action="uploadAction.jsp" method="post" enctype="multipart/form-data">
		<table>
				<tr>
					<td><input type="file" value="파일 선택" name="file" /></td>
					<td colspan="2"><input type="submit" value="업로드" /></td>
				</tr>
		</table>
		</form>
	</fieldset>
	<form action="introductAction.jsp" method="post">
		<fieldset style="width: 250">
		<br>아티스트명<br>
			<input type="text" name="name">
			<br>자기 소개<br>
			<textarea name="self_introduction" cols="50" rows="5"></textarea>
			<br>
			<textarea name="url_music" cols="50" rows="1"
				placeholder=<%=userDAO.getMusicurl(userID)%>></textarea>
			<br>
			<textarea name="url_sns" cols="50" rows="1" placeholder=<%=userDAO.getSnsurl(userID)%>></textarea>
			<br>관심 장르 :
			<%=userDAO.getGenre(userID)%><br> <select name="genre">
				<option value="HipHop">힙합</option>
				<option value="Rock">락</option>
				<option value="RnB">알앤비</option>
			</select> <input type="submit" value="수정" /><br>
			<br>

		</fieldset>
	</form>
	</div>
	<div class="row">
	<form action="ApplyAction.jsp" method="post">
		<fieldset style="width: 250">
			<legend>아티스트 등록 신청/결과</legend>
			<table border="1" width="500" height="100">
				<tr align="center" bgcolor="skybule">
					<td>신청일</td>
					<td>신청 결과</td>
				</tr>
				<tr>
					<td align="center"><%= applydate%></td>
					<td align="center"><%= applyresult%></td>
				</tr>
			</table>
			<br>
			<input type="submit" value="신청하기" /><br><Br><br>
		</fieldset>
	</form>
	</div>
	</div>
		<div class="row">
		<div class="modal" id="modal" tabindex="-1">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						Profile
						<button class="close" data-dismiss="modal">&times;</button>
					</div>
					<div class="modal-body" style="text-align: center;">
						<img src="images/<%= userDAO.getFilename(userID)%>" id="imagepreview"
							style="width: 150px; height: 150px;"><br><h4> <%= userDAO.getNickname(userID)%></h4>
						장르 : <%= userDAO.getGenre(userID)%><br> 음원사이트 URL : <%= userDAO.getMusicurl(userID)%><br> SNS URL : <%= userDAO.getSnsurl(userID)%><br> 자기소개 : <br><%= userDAO.getSelfIntroduction(userID)%>

					</div>
				</div>
			</div>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>