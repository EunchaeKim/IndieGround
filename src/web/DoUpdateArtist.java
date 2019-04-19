package web;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.DBUtil;

/**
 * Servlet implementation class DoUpdateArtist
 */
@WebServlet("/DoUpdateArtist")
public class DoUpdateArtist extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DoUpdateArtist() {
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
		
		if(request.getParameter("admit")!=null) {
			String applyname=request.getParameter("admit");
			String applyid=null;
			ResultSet rs=DBUtil.findUserID(conn,applyname);
			
			if (rs != null) {
				try {
					if(rs.next()) { // existing user
						applyid=rs.getString(1);
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
			if(applyid!=null) {
				if(DBUtil.artistapply_admit(conn,applyid)!=-1){
					out.println("<script>");
					out.println("alert('admit complete')");
					out.println("location.href='main.jsp'");
					out.println("</script>");
				}
			}
		}else if(request.getParameter("decline")!=null) {
			String applyname=request.getParameter("admit");
			String applyid=null;
			ResultSet rs=DBUtil.findUserID(conn,applyname);
			
			if (rs != null) {
				try {
					if(rs.next()) { // existing user
						applyid=rs.getString(1);
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
			if(applyid!=null) {
				if(DBUtil.artistapply_decline(conn,applyid)!=-1) {
					out.println("<script>");
					out.println("alert('decline complete')");
					out.println("location.href='main.jsp'");
					out.println("</script>");
				}
			}
		}
		
		out.println("<script>");
		out.println("alert('something wrong!')");
		out.println("location.href='main.jsp'");
		out.println("</script>");
		
	}

}
