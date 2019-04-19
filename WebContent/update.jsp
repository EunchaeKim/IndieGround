<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="model.Bbs" %>
<%@ page import="model.BbsDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Profile" %>
<%@ page import="model.UserDAO" %>
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
	if (session.getAttribute("uid") != null) {
		userID = (String) session.getAttribute("uid");
	}
	
	
	String nickname = null;
	
		if(userID==null){
			PrintWriter script = response.getWriter();
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
		}

		UserDAO userDAO = new UserDAO();
		
		ArrayList<Profile> search_list=new ArrayList<Profile>();
		ArrayList<Profile> artist_list=new ArrayList<Profile>();
		
		String[] chknum;
		
		if(session.getAttribute("artistSearchList")!=null){
			search_list=(ArrayList<Profile>)session.getAttribute("artistSearchList");
		}
		if(request.getParameterValues("selected")!=null){
			chknum=request.getParameterValues("selected");
			for(int i=0;i<chknum.length;i++){
				int num=Integer.parseInt(chknum[i]);
				
				Profile artist=new Profile();
				artist.setName(search_list.get(num).getName());
				artist.setFilename(search_list.get(num).getFilename());
				artist.setSelf_introduction(search_list.get(num).getSelf_introduction());
				artist.setUrl_music(search_list.get(num).getUrl_music());
				artist.setUrl_sns(search_list.get(num).getUrl_sns());
				artist.setGenre(search_list.get(num).getGenre());
				
				artist_list.add(artist);
			}
			
			session.setAttribute("lineupEdit",artist_list);
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
		session.setAttribute("pageNow", 1); //0 글쓰기 1글수정
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
	<div class="row justify-content-center">
		<form>
		<a class="btn btn-default" href="searchArtist.jsp">아티스트 선택</a><br><br>
		</form>
	</div>
	</div>
	<div class="container">
		<div class="row">
		<form method="post" action="updateAction.jsp">
		<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
				<th colspan="4" style="background-color:#eeeeee; text-align:center;">공연 기획 양식</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td colspan="4"><label for="tt">글 제목</label><input type="text" id="tt" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50"></td>
				</tr>
				<tr>
         			<td colspan="3"><label for="lct">지역 및 장소</label><input type="text" id="lct" class="form-control" placeholder="지역 및 장소" name="bbsLocation" maxlength="50"></td>
         			
				</tr>
				<tr>
					<td colspan="1"><label for="gr">장르 선택</label>
					<select id="gr" class="form-control" name="bbsGenre">
						<option value="HipHop">힙합</option>
						<option value="Rock">락</option>
						<option value="RnB">알앤비</option>
					</select>
					</td>
  					<td colspan="1"><label for="tf">목표 금액</label><input type="number" id="tf" class="form-control" placeholder="목표금액" name="bbsTargetfund" maxlength="50"></td>
  					<td colspan="1"><label for="dl">펀딩 마감날짜</label><input type="date" id="dl" class="form-control" placeholder="펀딩마감날짜" name="bbsDeadline" maxlength="50"></td>
  					<td colspan="1"><label for="cd">공연 날짜</label><input type="date" id="cd" class="form-control" placeholder="공연시작일" name="bbsConcertday" maxlength="50"></td>
				</tr>
				<tr>
					<td colspan="4">
					<label for="sc">출연 아티스트</label>
	  						<%
	  							for(int i=0 ; i<artist_list.size() ; i++){
	  								%>
	  								<div class="col-sm">
									<img src="images/<%=artist_list.get(i).getFilename()%>"
									style="width: 100px; height: 100px;">
									<h4><%=artist_list.get(i).getName()%></h4>
									</div>
	  							<%
	  							}
	  						
	  						%>
					</td>
				</tr>
				
				<tr>
					<td colspan="4"><label for="ctt">글 내용</label><textarea type="text" id="ctt" class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;"></textarea></td>
				</tr>
				
			</tbody>
		</table>
		<input type="submit" class="btn btn-primary pull-right" value="글쓰기">
		</form>
		
	</div>
	
	</div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>