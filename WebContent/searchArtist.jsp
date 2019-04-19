<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%@ page import="model.BbsDAO" %>
<%@ page import="model.UserDAO" %>
<%@ page import="model.Bbs" %>
<%@ page import="model.Profile"%>
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
<style>
.maintxt {
	color: black;
	text-align: center;
	font-weight: bold;
}
</style>
</head>
<body>
	<%
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

		UserDAO userDAO = new UserDAO();
		String genreSearch = "allGen";
		String nameSearch = "";

		ArrayList<Profile> artist_selectlist = new ArrayList<Profile>();
		
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
			<form method="post">
				<h5>장르별로 검색하기</h5>
				<select name="genreSearch" style="width: 100px;">
					<optgroup label="장르">
						<option value="allGen">전체</option>
						<option value="HipHop">힙합</option>
						<option value="Rock">락</option>
						<option value="RnB">알앤비</option>
					</optgroup>
				</select>
				<fieldset style="width: 100">
					<h5>아티스트 이름으로 검색하기</h5>
					<input type="text" name="nameSearch" size="50"
						style="height: 30px;"> <input type="submit" value="검색"
						class="btn btn-default" />
				</fieldset>
			</form>
		</div>
		<hr>
		<div class="row">
		<%
		if((int)session.getAttribute("pageNow")==0){
		%>
			<form method="post" action="write.jsp">
			<%
		}else if((int)session.getAttribute("pageNow")==1){
			%>
			<form method="post" action="update.jsp">
			<%
		}
			%>
				<fieldset style="width: 250">
					<h5>아티스트 선택하기</h5>

					<input type="submit" value="선택완료" class="btn btn-primary">
					<br> <br>
				</fieldset>
				<%
					if ((String) request.getParameter("genreSearch") != null) {
						genreSearch = (String) request.getParameter("genreSearch");
					}
					if ((String) request.getParameter("nameSearch") != null) {
						nameSearch = (String) request.getParameter("nameSearch");
					}
					ArrayList<Profile> artist_searchlist = userDAO.getArtistSearchList(nameSearch, genreSearch);
					session.setAttribute("artistSearchList", artist_searchlist);
					for (int i = 0; i < artist_searchlist.size(); i++) {
				%>

				<div class="col-sm-2">
					<img src="images/<%=artist_searchlist.get(i).getFilename()%>"
						style="width: 150px; height: 150px;">
					<h4><%=artist_searchlist.get(i).getName()%></h4>
					<p>
						장르 :
						<%=artist_searchlist.get(i).getGenre()%></p>
					<p>
						<a class="btn btn-default" data-target="#artist<%=i%>"
							data-toggle="modal">프로필 보기</a>
					</p>
					선택하기 <input type="checkbox" name="selected" value="<%=i%>"><br>
					</div>
					<%
						}
					%>
			</form>
			</form>
		</div>
	</div>

	<%
		for (int i = 0; i < artist_searchlist.size(); i++) {
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
						<img src="images/<%=artist_searchlist.get(i).getFilename()%>"
							id="imagepreview" style="width: 150px; height: 150px;"><br>아티스트명
						:
						<%=artist_searchlist.get(i).getName()%><br> 장르 :
						<%=artist_searchlist.get(i).getGenre()%><br> 음원사이트 URL :
						<%=artist_searchlist.get(i).getUrl_music()%><br> SNS URL :
						<%=artist_searchlist.get(i).getUrl_sns()%><br> 자기소개 :
						<%=artist_searchlist.get(i).getSelf_introduction()%><br>
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