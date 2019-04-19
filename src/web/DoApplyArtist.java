package web;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.DBUtil;

/**
 * Servlet implementation class DoApplyArtist
 */
@WebServlet("/DoApplyArtist")
public class DoApplyArtist extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DoApplyArtist() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		ServletContext sc = getServletContext();
		Connection conn= (Connection) sc.getAttribute("DBconnection");
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		
		String userID=null;
		if(session.getAttribute("uid")!=null){
			userID=(String)session.getAttribute("uid");
		}
		Date today = new Date();
	    SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");
	    String now=date.format(today);
	    ResultSet rs = DBUtil.findArtistApply(conn,userID);
	    
	
	    if (rs != null) {
			try {
				if(rs.next()) { // existing user
					//*
					String result=(String)rs.getString(3);
					if(result.equals("불허")) {
						DBUtil.artistapply_retry(conn,userID,now);
						
						out.println("<script>");
						out.println("alert('retry success!')");
						out.println("location.href='myinfo.jsp'");
						out.println("</script>");	
						
					}
					else if(result.equals("승인")||result.equals("심사중")) {
						out.println("<script>");
						out.println("alert('already applied!')");
						out.println("location.href='myinfo.jsp'");
						out.println("</script>");
					}
					
				}else { // 완벽한 null값이 될 수 없다.
					if(DBUtil.artistapply_init(conn,userID,now)!=-1) {
						
						out.println("<script>");
						out.println("alert('apply success!')");
						out.println("location.href='myinfo.jsp'");
						out.println("</script>");
					}
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    }
		//*/
		
		//System.out.println(newstring); // 2011-01-18
		
	}
}
