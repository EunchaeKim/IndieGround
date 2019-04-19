<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="model.Bbs" %>
<%@ page import="model.BbsDAO" %>
<%@ page import="model.UserDAO" %>
<%@ page import="model.Profile" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset="UTF-8">
<meta name="viewport" content="width-device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/coding.css">
<title>IndieGround</title>
</head>
<body>
	<%
	String userID = null;
	UserDAO userDAO = new UserDAO();
	
	if (session.getAttribute("uid") != null) {
		userID = (String) session.getAttribute("uid");
	}

		int bbsID=0;
		if(request.getParameter("bbsID")!=null){
			bbsID=Integer.parseInt(request.getParameter("bbsID"));
		}
		if(bbsID==0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다')");
			script.println("location.href='bbs.jsp'");
			script.println("</script>");
		}
		
		session.setAttribute("bbsID", bbsID);
		
		BbsDAO bbsDAO=new BbsDAO();
		Bbs bbs=new BbsDAO().getBbs(bbsID);
		
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
		<form method="post" action="fundingAction.jsp">
		<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
				<th colspan="4" style="background-color:#eeeeee; text-align:center;">공연 기획 양식</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td colspan="4">
					<label for="sc">출연 아티스트</label>
					
						<%
						ArrayList<Profile> artist_list=new ArrayList<Profile>();
	  						if(bbsDAO.getlineup(bbsID)!=null){
	  							artist_list=bbsDAO.getlineup(bbsID);
	  							for(int i=0 ; i<artist_list.size() ; i++){
	  								%>
	  								<div class="col-sm">
									<img src="images/<%=artist_list.get(i).getFilename()%>"
									style="width: 100px; height: 100px;">
									<h4><%=artist_list.get(i).getName()%></h4>
									<p>
									<a class="btn btn-default" data-target="#<%= i%>"
										data-toggle="modal">프로필 보기</a>
									</p>
									<a>섭외현황 : <%= bbsDAO.artistParticipate(artist_list.get(i).getName(),bbsID) %></a><br>
									<a>펀딩 금액 : <input type="number" name="fund"/></a><br><br>
									</div>
	  							<%
	  							}
	  						}
	  						// 모금하기 버튼(섭외중일때 펀딩X) 및 아티스트별 섭외상황
	  						%>
						</td>
				</tr>
			</tbody>
		</table>
		
		<%
			if(userID==null){
		%>
			<input type="submit" class="btn btn-primary pull-left" value="펀딩하기" disabled>
		<%
			}else if(bbsDAO.progress(bbsID).equals("펀딩진행중")){
		%>
			<input type="submit" class="btn btn-primary pull-left" value="펀딩하기">
		<%
			}else{
		%>
			<input type="submit" class="btn btn-primary pull-left" value="펀딩하기" disabled>
		<%
			}
		%>
		</form>
		
	</div>
	<hr>
	</div>
	<div class="container">
		<div class="row">
		<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
				<th colspan="4" style="background-color:#eeeeee; text-align:center;">게시판 글 보기</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="width: 20%;">글제목</td>
					<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></td>
				</tr>
				<tr>
					<td>작성자</td>
					<td colspan="2"><%= bbs.getUserID() %></td>
				</tr>
				<tr>
					<td>작성일자</td>
					<td colspan="2"><%= bbs.getBbsDate().substring(0,11)+bbs.getBbsDate().substring(11,13)+"시 "+bbs.getBbsDate().substring(14,16)+"분"%></td>
				</tr>
				<tr>
					<td>장르</td>
					<td colspan="2"><%= bbs.getBbsGenre() %></td>
				</tr>
				<tr>
					<td>펀딩 진행상황</td>
					<td colspan="2"><%= bbsDAO.progress(bbsID)%></td>
				</tr>
				<tr>
					<td>장소</td>
					<td colspan="2"><%= bbs.getBbsLocation()%></td>
				</tr>
				<tr>
					<td>현재금액</td>
					<td colspan="2" id="c"><%= bbs.getBbsCurrfund()%></td>
				</tr>
				<tr>
					<td>목표금액</td>
					<td><%= bbs.getBbsTargetfund()%></td>
				</tr>
				<tr>
					<td>펀딩 마감일</td>
					<td><%= bbs.getBbsDeadline()%></td>
				</tr>
				<tr>
					<td>공연 예정일</td>
					<td><%= bbs.getBbsConcertday()%></td>
				</tr>
				<tr>
					<td>내용</td>
					<td colspan="2" style="min-height: 200px; text-align: left;"><%= bbs.getBbsContent().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>")%></td>
				</tr>
				
			</tbody>
			</table>
			<a href="bbs.jsp" class="btn btn-primary">목록</a>
		<%
			if(userID!=null&&userID.equals(bbs.getUserID())){
				%>
			<a href="update.jsp?bbsID=<%=bbsID %>"class="btn btn-primary">수정</a>
			<a onclick="retrun confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%=bbsID %>"class="btn btn-primary">삭제</a>
		
		<% 
			}
		%>
	</div>
	</div>
	
	<% 
				
	        for(int i=0 ; i<artist_list.size(); i++){
	    					
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
						<img src="images/<%= artist_list.get(i).getFilename()%>"
							id="imagepreview" style="width: 150px; height: 150px;"><br>아티스트명
						: <%= artist_list.get(i).getName()%><br> 장르 :
						<%= artist_list.get(i).getGenre()%><br> 음원사이트 URL :
						<%= artist_list.get(i).getUrl_music()%><br> SNS URL :
						<%= artist_list.get(i).getUrl_sns()%><br> 자기소개 :
						<%= artist_list.get(i).getSelf_introduction()%><br>
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