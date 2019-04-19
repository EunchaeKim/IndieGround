<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="web.DBConnectionManage" %>
<%@ page import="model.DBUtil" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="java.io.File" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
<title>IndieGround</title>
</head>
<body>
<%
	ServletContext sc = getServletContext();
	Connection conn = (Connection) sc.getAttribute("DBconnection");

	String userID=null;
	if(session.getAttribute("uid")!=null){
		userID=(String)session.getAttribute("uid");
	}
	
	String directory = application.getRealPath("/images/"); 
	//String directory = "C:/Program Files/Apache Software Foundation/Tomcat 9.0/webapps/webProject/images";
	int maxSize = 100 * 1024 * 1024;
	String encoding = "UTF-8";
	
	MultipartRequest multi = new MultipartRequest(request, directory, maxSize, encoding,
			new DefaultFileRenamePolicy());
	
	String fileName=multi.getOriginalFileName("file");
	String fileRealName=multi.getFilesystemName("file");
	
	
	if(!fileName.endsWith(".jpg")&&!fileName.endsWith(".png")
			&&!fileName.endsWith(".gif")&&!fileName.endsWith(".jpeg")){
		File file=new File(directory+fileRealName);
		file.delete();
		out.write("업로드 할 수 없는 확장자 입니다");
	}else{
		if(DBUtil.uploadFile(conn,userID,fileRealName)!=-1){
		%>
		<script>
			location.href='myinfo.jsp';
		</script>
		<%
		}
	}
	
%>

</body>
</html>