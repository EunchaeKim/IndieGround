<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="model.DBUtil"%>
<%@ page import="web.DBConnectionManage"%>
<%@ page import="web.DoLogIn"%>
<%@ page import="model.BbsDAO"%>
<%@ page import="model.UserDAO"%>
<%@ page import="model.Bbs"%>
<%@ page import="model.Profile"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset="UTF-8">
<meta name="viewport" content="width-device-width" , initial-scale="1">
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

		BbsDAO bbsDAO = new BbsDAO();
		ArrayList<Bbs> alist = bbsDAO.getrequestlist(userDAO.getNickname(userID));
		int alert = 0;
		if (alist != null) {
			for (int i = 0; i < alist.size(); i++) {
				if (bbsDAO.artistParticipate(userDAO.getNickname(userID), alist.get(i).getBbsID()).equals("섭외중")) {
					alert++;
				}
				;
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
				<a href="realmain.jsp" class="navbar-brand"
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
						} else if (userDAO.isAdmin(userID) == 0) {
					%>
					<li><a><%=userDAO.getNickname(userID)%>님 로그인됨</a></li>
					<li><a href="myinfo.jsp">내 정보</a></li>
					<li><a href="bbs.jsp">글목록</a></li>
					<%
						if (alert < 1) {
					%>
					<li><a href="myalertinfo.jsp">알림</a></li>
					<%
						} else {
					%>
					<li><a href="myalertinfo.jsp">알림<span
							class="badge badge-primary"><%=alert%></span></a></li>
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
		<div id="myCarousel" class="carousel slide" data-ride="carousel">

			<h3 class="maintxt">펀딩 진행중인 공연</h3>
			<div class="carousel-inner">
				<div class="item active">
					<%
						ArrayList<Bbs> list = bbsDAO.getList(1);
						int index = 0;
						if (list.size() > 0) {
							if (list.size() < 3) {
								index = list.size();
							} else {
								index = 3;
							}
							for (int i = 0; i < index; i++) {
					%>
					<div class="col-md-4">
						<h2 class="text-center"><%=list.get(i).getBbsTitle()%></h2>
						<p class="text-center">
							장소 :
							<%=list.get(i).getBbsLocation()%></p>
						<p class="text-center">
							펀딩마감일자 :<%=list.get(i).getBbsDeadline()%></p>
						<p class="text-center">
							공연예정일 :
							<%=list.get(i).getBbsConcertday()%></p>
						<p class="text-center">
							<a class="btn btn-primary btn-default"
								href="view.jsp?bbsID=<%=list.get(i).getBbsID()%>" role="button">바로가기</a>
						</p>
						<hr>
					</div>
					<%
						}
						}
					%>
				</div>
				<div class="item">
					<%
						if (list.size() > 3) {
							if (list.size() < 6) {
								index = list.size();
							} else {
								index = 6;
							}
							for (int i = 3; i < index; i++) {
					%>

					<div class="col-md-4">
						<h2 class="text-center"><%=list.get(i).getBbsTitle()%></h2>
						<p class="text-center">
							장소 :
							<%=list.get(i).getBbsLocation()%></p>
						<p class="text-center">
							펀딩마감일자 :<%=list.get(i).getBbsDeadline()%></p>
						<p class="text-center">
							공연예정일 :
							<%=list.get(i).getBbsConcertday()%></p>
						<p class="text-center">
							<a class="btn btn-primary btn-default"
								href="view.jsp?bbsID=<%=list.get(i).getBbsID()%>" role="button">바로가기</a>
						</p>
						<hr>
					</div>
					<%
						}
						}
					%>
				</div>
				<div class="item">
					<%
						if (list.size() > 6) {
							if (list.size() < 9) {
								index = list.size();
							} else {
								index = 9;
							}
							for (int i = 6; i < index; i++) {
					%>
					<div class="col-md-4">
						<h2 class="text-center"><%=list.get(i).getBbsTitle()%></h2>
						<p class="text-center">
							장소 :
							<%=list.get(i).getBbsLocation()%></p>
						<p class="text-center">
							펀딩마감일자 :<%=list.get(i).getBbsDeadline()%></p>
						<p class="text-center">
							공연예정일 :
							<%=list.get(i).getBbsConcertday()%></p>
						<p class="text-center">
							<a class="btn btn-primary btn-default"
								href="view.jsp?bbsID=<%=list.get(i).getBbsID()%>" role="button">바로가기</a>
						</p>
						<hr>
					</div>
					<%
						}
						}
					%>
				</div>
			</div>
			<a class="left carousel-control" href="#myCarousel" data-slide="prev">
				<span class="glyphicon glyphicon-chevron-left"></span>
			</a> <a class="right carousel-control" href="#myCarousel"
				data-slide="next"> <span
				class="glyphicon glyphicon-chevron-right"></span>
			</a>
		</div>
	</div>
	<div class="container">
		<div id="myArtistCarousel" class="carousel slide" data-ride="carousel">
			<div class="row">
				<h3 class="maintxt">아티스트 목록</h3>
				<div class="carousel-inner">
					<div class="item active">
						<br>
						
						<%
							ArrayList<Profile> artist_list = userDAO.getArtistList();
							if (artist_list.size() > 0) {
								if (artist_list.size() < 8) {
									index = artist_list.size();
								} else {
									index = 8;
								}

								for (int i = 0; i < index; i++) {
						%>
						
						<div class="col-md-3">
							<img class="img-responsive center-block" src="images/<%=artist_list.get(i).getFilename()%>"
								style="width: 150px; height: 150px;">
							<h4 class="text-center"><%=artist_list.get(i).getName()%></h4>
							<p class="text-center">
								장르 :
								<%=artist_list.get(i).getGenre()%></p>
							<p class="text-center">
								<a class="btn btn-default" data-target="#artist<%=i%>"
									data-toggle="modal">프로필 보기</a>
							</p>
						</div>

						<%
							}
							}
						%>
					</div>
					<div class="item">
						<%
							if (artist_list.size() > 8) {
								if (artist_list.size() < 16) {
									index = artist_list.size();
								} else {
									index = 16;
								}

								for (int i = 0; i < index; i++) {
						%>
						<div class="col-md-3">
							<img class="img-responsive center-block" src="images/<%=artist_list.get(i).getFilename()%>"
								style="width: 150px; height: 150px;">
							<h4 class="text-center"><%=artist_list.get(i).getName()%></h4>
							<p class="text-center">
								장르 :
								<%=artist_list.get(i).getGenre()%></p>
							<p class="text-center">
								<a class="btn btn-default" data-target="#artist<%=i%>"
									data-toggle="modal">프로필 보기</a>
							</p>
						</div>
						<%
							}
							}
						%>
					</div>
				</div>
				<a class="left carousel-control" href="#myArtistCarousel"
					data-slide="prev"> <span
					class="glyphicon glyphicon-chevron-left"></span>
				</a> <a class="right carousel-control" href="#myArtistCarousel"
					data-slide="next"> <span
					class="glyphicon glyphicon-chevron-right"></span>
				</a>
			</div>
			<hr>
		</div>
	</div>
	<footer style="background-color: #000000; color: #ffffff">
		<div class="container">
			<br>
			<div class="row">
				<div class="col-sm-2" style="text-align: center;">
					<h5>Copyright &copy; 2018</h5>
					<h5>김은채</h5>
				</div>
				<div class="col-sm-4">
					<h4>대표자 소개</h4>
					<p>언더그라운드 문화를 사랑하는 개발자</p>
				</div>
			</div>
		</div>
	</footer>
	<%
			for (int i = 0; i < artist_list.size(); i++) {
				//int index=numarr[i];
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
						<form method="post" action="followAction.jsp">
							<img src="images/<%=artist_list.get(i).getFilename()%>"
								id="imagepreview" style="width: 150px; height: 150px;"><br>
							<h4><%=artist_list.get(i).getName()%></h4>
							장르 :
							<%=artist_list.get(i).getGenre()%><br> 음원사이트 URL :
							<%=artist_list.get(i).getUrl_music()%><br> SNS URL :
							<%=artist_list.get(i).getUrl_sns()%><br> 자기소개 :
							<%=artist_list.get(i).getSelf_introduction()%><br>
							<%
									if (userID != null) {
								%>
							<button type="submit" name="follow"
								value=<%=artist_list.get(i).getName().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
							.replaceAll(">", "&gt;")%>>follow</button>
							<%
									} //
								%>
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