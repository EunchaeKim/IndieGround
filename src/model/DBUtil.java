package model;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


public class DBUtil {
	
	public static ResultSet findUser(Connection conn, String uid) {
		// TODO Auto-generated method stub
		String sqlSt = "SELECT passwd,name,filename,self_introduction,url_music,url_sns,genre FROM user WHERE id=";

		Statement st;
		try {
			st = conn.createStatement();

			if (st.execute(sqlSt + "'" + uid + "'")) {
				return st.getResultSet();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	public static ResultSet findUserID(Connection conn, String uname) {
		// TODO Auto-generated method stub
		String sqlSt = "SELECT id FROM user WHERE name=";

		Statement st;
		try {
			st = conn.createStatement();

			if (st.execute(sqlSt + "'" + uname + "'")) {
				return st.getResultSet();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	public static ResultSet findmyfollowing(Connection conn, String uid) {
		// TODO Auto-generated method stub
		String sqlSt = "SELECT id FROM follow WHERE followerid=";

		Statement st;
		try {
			st = conn.createStatement();

			if (st.execute(sqlSt + "'" + uid + "'")) {
				return st.getResultSet();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	public static ResultSet findmyfollower(Connection conn, String uid) {
		// TODO Auto-generated method stub
		String sqlSt = "SELECT followerid FROM follow WHERE id=";

		Statement st;
		try {
			st = conn.createStatement();

			if (st.execute(sqlSt + "'" + uid + "'")) {
				return st.getResultSet();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	
	public static ResultSet findArtistApply(Connection conn, String uid) {
		// TODO Auto-generated method stub
		String sqlSt = "SELECT id,applydate,applyresult FROM artist_apply WHERE id=";

		Statement st;
		try {
			st = conn.createStatement();

			if (st.execute(sqlSt + "'" + uid + "'")) {
				return st.getResultSet();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	public static ResultSet findAllArtistApply(Connection conn,String applyResult) {
		// TODO Auto-generated method stub
		String sqlSt = "SELECT id,applydate FROM artist_apply WHERE applyresult=";

		Statement st;
		try {
			st = conn.createStatement();
			if (st.execute(sqlSt + "'" + applyResult + "'")) {
				return st.getResultSet();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	
	
	
	public  ResultSet isAdmin(Connection conn, String uid) {
		String sqlSt = "SELECT user_type FROM user WHERE id=";

		Statement st;
		try {
			st = conn.createStatement();
			if (st.execute(sqlSt + "'" + uid + "'")) {
				return st.getResultSet();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	
	public static int join(Connection conn, String uid,String passwd,String uname,String email,String phone) {
		
		String sqlSt = "SELECT id FROM user where id=?";
		String sqlSt2 = "SELECT name FROM user where name=?";
		ResultSet rs;
		try {
			PreparedStatement pstmt=conn.prepareStatement(sqlSt);
			pstmt.setString(1, uid);
			rs=pstmt.executeQuery(); // 아이디 중복
			if(rs.next()) {
				if(rs.getString(1).equals(uid))
					return -2;
			}
			//*
			PreparedStatement pstmt2=conn.prepareStatement(sqlSt2);
			pstmt2.setString(1, uname);
			rs=pstmt2.executeQuery(); // 닉네임 중복
			if(rs.next()) {
				if(rs.getString(1).equals(uname))
					return -3;
			}//*/
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		
		String SQL="INSERT INTO USER VALUES (?, ?, ?, ?, ?, 0, ?, NULL,NULL,NULL,NULL)";
		PreparedStatement pstmt;
		
		try {	
			pstmt=conn.prepareStatement(SQL);
			pstmt.setString(1, uid);
			pstmt.setString(2, passwd);
			pstmt.setString(3, uname);
			pstmt.setString(4, email);
			pstmt.setString(5, phone);
			pstmt.setString(6, "unknown.png");
			
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public static int dofollow(Connection conn, String uid, String artistf){
		String SQL="INSERT INTO follow VALUES (?,?)";
		PreparedStatement pstmt;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, artistf);
			pstmt.setString(2, uid);
		
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
  }
	
	public static int unfollow(Connection conn, String uid, String artistf){
		String SQL="DELETE FROM follow WHERE id=? and followerid=?";
		PreparedStatement pstmt;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, artistf);
			pstmt.setString(2, uid);
			
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
  }
	
	public static int uploadFile(Connection conn, String uid, String fileName){
		String SQL="UPDATE user SET filename=? WHERE id=?";
		PreparedStatement pstmt;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fileName);
			pstmt.setString(2, uid);
		
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
  }
	
	public static int uploadIntroduction(Connection conn, String uid, String self_introduction, String url_music,String url_sns,String genre){
		String SQL="UPDATE user SET self_introduction=?,url_music=?,url_sns=?,genre=? WHERE id=?";
		PreparedStatement pstmt;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, self_introduction);
			pstmt.setString(2, url_music);
			pstmt.setString(3, url_sns);
			pstmt.setString(4, genre);
			pstmt.setString(5, uid);
		
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
  }
	
	
	
	public static int artistapply_init(Connection conn, String uid,String date){
		String SQL="INSERT INTO ARTIST_APPLY VALUES (?, ?, ?)";
		PreparedStatement pstmt;
		
		try {
			pstmt=conn.prepareStatement(SQL);
			pstmt.setString(1, uid);
			pstmt.setString(2, date);
			pstmt.setString(3, "심사중");
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
  }
	
	public static int artistapply_retry(Connection conn, String uid,String date){
		String SQL="UPDATE ARTIST_APPLY SET applydate=?,applyresult=? WHERE id=?";
		PreparedStatement pstmt;
		
		try {
			pstmt=conn.prepareStatement(SQL);
			pstmt.setString(1, date);
			pstmt.setString(2, "심사중");
			pstmt.setString(3, uid);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
  }
	
	public static int artistapply_admit(Connection conn, String uid){
		String SQL="UPDATE ARTIST_APPLY SET applyresult=? WHERE id=?";
		PreparedStatement pstmt;
		
		try {
			pstmt=conn.prepareStatement(SQL);
			pstmt.setString(1, "승인");
			pstmt.setString(2, uid);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
  }
	
	public static int artistapply_decline(Connection conn, String uid){
		String SQL="UPDATE ARTIST_APPLY SET applyresult=? WHERE id=?";
		PreparedStatement pstmt;
		
		try {
			pstmt=conn.prepareStatement(SQL);
			pstmt.setString(1, "불허");
			pstmt.setString(2, uid);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
  }


}
