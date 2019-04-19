<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="model.DBUtil"%>
<%@ page import="web.DBConnectionManage"%>
<%@ page import="web.DoLogIn"%>
<%@ page import="model.UserDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
<meta name="viewport" content="width-device-width", initial-scale="1">
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

			<form class="navbar-form navbar-right">
				<a href="main.jsp" class="btn btn-default">접속하기</a>
			</form>
		</div>
	</div>
</nav>
<div class="container">
		<div class="jumbotron">
			<div class = "container">
				<h1>IndieGround</h1>
				<p>인디/언더그라운드 공연 펀딩 사이트</p>
				<p><a class="btn btn-primary btn-pull" href="main.jsp" role="button">자세히 알아보기</a></p>
			</div>
		</div>
	</div>	
	<div class="container">
		<div id="myCarousel" class="carousel slide" data-ride="carousel">
			<ol class="carousel-indicators">
				<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
				<li data-target="#myCarousel" data-slide-to="1"></li>
				<li data-target="#myCarousel" data-slide-to="2"></li>
			</ol>
			<div class="carousel-inner">
				<div class="item active" >
					<img class="img-responsive center-block" src="images/5101.jpg">
				</div>
				<div class="item">
				<img class="img-responsive center-block" src="images/51013.jpg"/>
				</div>
				<div class="item">
				<img class="img-responsive center-block" src="images/daltokki.jpg"/>
				</div>
			</div>
			<a class="left carousel-control" href="#myCarousel" data-slide="prev">
				<span class="glyphicon glyphicon-chevron-left"></span>
			</a>
			<a class="right carousel-control" href="#myCarousel" data-slide="next">
				<span class="glyphicon glyphicon-chevron-right"></span>
			</a>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>

</body>
</html>