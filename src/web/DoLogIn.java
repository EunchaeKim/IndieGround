package web;

import java.io.IOException;

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.DBUtil;

/**
 * Servlet implementation class DoLogIn
 */
public class DoLogIn extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DoLogIn() {
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
		String uid = request.getParameter("uid");
		String passwd = request.getParameter("passwd");
		
		ServletContext sc = getServletContext();
		Connection conn= (Connection) sc.getAttribute("DBconnection");
		HttpSession session = request.getSession();

		ResultSet rs = DBUtil.findUser(conn, uid);
		ResultSet artistrs = DBUtil.findArtistApply(conn, uid);
		
		PrintWriter out = response.getWriter();
		
		String userID=null;
		if(session.getAttribute("uid")!=null){
			userID=(String)session.getAttribute("uid");
		}
		if (artistrs != null) { // DB로 옮기기
			try {
				if(artistrs.next()) { // existing user
					String artistID = artistrs.getString(1);
					if(artistID!=null){
						String applydate = artistrs.getString(2);
						session.setAttribute("applydate", applydate);
						
						String applyresult=artistrs.getString(3);
						session.setAttribute("applyresult", applyresult);
					}	
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if (rs != null) {
			try {
				if(rs.next()) { // existing user
					String checkpw = rs.getString(1);
					if(userID!=null){
						out.println("<script>");
						out.println("alert('이미 로그인 되어있음')");
						out.println("location.href='main.jsp'");
						out.println("</script>");
					}
					else if (checkpw.equals(passwd)) {
						session.setAttribute("uid", uid);
						
						String checkname = rs.getString(2);

						out.println("<script>");
						out.println("alert('"+checkname+" welcome!')");
						out.println("location.href='main.jsp'");
						out.println("</script>");
					}
					else {
						// wrong passwd
						out.println("<script>");
						out.println("alert('WRONG PASSWORD!!')");
						out.println("location.href='login.jsp'");
						out.println("</script>");
					}
				}
				else {
					// invalid user
					out.println("<script>");
					out.println("alert('invalid user name!!')");
					out.println("location.href='login.jsp'");
					out.println("</script>");
				}			
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
	}

}
