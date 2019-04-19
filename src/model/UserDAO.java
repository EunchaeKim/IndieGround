package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Properties;

public class UserDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	public UserDAO() {
		try {
			Properties connectionProps = new Properties();
			// String dbURL = "jdbc:mysql://localhost:3306/BBS?serverTimezone=UTC";
			String dbURL = "jdbc:mysql://localhost:3306/webdb?serverTimezone=UTC";
			String dbID = "root";
			String dbPassword = "0728";

			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
			// conn=DriverManager.getConnection(dbURL, connectionProps);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public int login(String userID, String userPassword) {
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString(1).equals(userPassword)) {
					return 1; // 로그인 성공
				} else
					return 0; // 비밀번호 불일치
			}
			return -1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -2; // 데이터베이스 오류
	}

	public int join(User user) {
		String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, ?, 0, ?, NULL,NULL,NULL,NULL)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getId());
			pstmt.setString(2, user.getPasswd());
			pstmt.setString(3, user.getName());
			pstmt.setString(4, user.getEmail());
			pstmt.setString(5, user.getPhone());
			pstmt.setString(6, "unknown.png");
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public int isAdmin(String uid) {
		String SQL = "SELECT user_type FROM user WHERE id=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int isArtist(String uid) {		
		String SQL = "SELECT * FROM artist_apply WHERE id=? AND applyresult='승인'";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				return 1;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public int apply_init(String uid, String date) {
		String SQL = "INSERT INTO ARTIST_APPLY VALUES (?, ?, ?)";
		PreparedStatement pstmt;

		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, uid);
			pstmt.setString(2, date);
			pstmt.setString(3, "심사중");
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int apply_retry(String uid,String date){
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
	
	public int apply_admit(String uid){
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
	
	public int apply_decline(String uid){
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

	public int findExistArtist(String userID) { // 아티스트 심사할때 씀!
		// TODO Auto-generated method stub
		String SQL = "SELECT id,applydate,applyresult FROM artist_apply WHERE id=?";
		Date today = new Date();
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");
		String now = date.format(today);

		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) { // existing user
				// *
				String result = (String) rs.getString(3);
				if (result.equals("불허")) {
					apply_retry(userID, now);

					return 2;
					

				} else if (result.equals("승인") || result.equals("심사중")) {
					return -2;
					
				}

			} else { // 완벽한 null값이 될 수 없다.
				if (apply_init(userID, now) != -1) {
					return 1;
					
				}
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;
	}

	public String avoidDupID(String id) {
		// TODO Auto-generated method stub
		String SQL = "SELECT id FROM user WHERE id=?";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public String avoidDupName(String name) {
		// TODO Auto-generated method stub
		String SQL = "SELECT name FROM user WHERE name=?";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, name);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public String findUserID(String uname) {
		// TODO Auto-generated method stub
		String SQL = "SELECT id FROM user WHERE name=?";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, uname);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public String getNickname(String uid) {
		String SQL = "SELECT name FROM user WHERE id=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	public String getFilename(String uid) {
		String SQL = "SELECT filename FROM user WHERE id=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	public String getSelfIntroduction(String uid) {
		String SQL = "SELECT self_introduction FROM user WHERE id=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				if (rs.getString(1) != null)
					return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	public String getMusicurl(String uid) {
		String SQL = "SELECT url_music FROM user WHERE id=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				if (rs.getString(1) != null)
					return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	public String getSnsurl(String uid) {
		String SQL = "SELECT url_sns FROM user WHERE id=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				if (rs.getString(1) != null)
					return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	public String getGenre(String uid) {
		String SQL = "SELECT genre FROM user WHERE id=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				if (rs.getString(1) != null)
					return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	public String getApplyDate(String uid) {
		String SQL = "SELECT applydate FROM artist_apply WHERE id=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				if (rs.getString(1) != null)
					return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	public String getApplyResult(String uid) {
		String SQL = "SELECT applyresult FROM artist_apply WHERE id=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				if (rs.getString(1) != null)
					return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	public ArrayList<Profile> getArtistList() {
		String SQL = "SELECT id FROM ARTIST_APPLY WHERE applyresult='승인'";
		ArrayList<String> id_list = new ArrayList<String>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			while (rs.next()) {
				id_list.add(rs.getString(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		SQL = "SELECT name,filename,genre,self_introduction,url_music,url_sns FROM user WHERE id= ?";

		ArrayList<Profile> artist_list = new ArrayList<Profile>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			for (int i = 0; i < id_list.size(); i++) {
				pstmt.setString(1, id_list.get(i));
				rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
				if (rs.next()) {
					Profile artist = new Profile();
					artist.setName(rs.getString(1));
					artist.setFilename(rs.getString(2));
					artist.setGenre(rs.getString(3));
					artist.setSelf_introduction(rs.getString(4));
					artist.setUrl_music(rs.getString(5));
					artist.setUrl_sns(rs.getString(6));

					if (artist.getGenre() == null) {
						artist.setGenre("");
					}
					if (artist.getSelf_introduction() == null) {
						artist.setSelf_introduction("");
					}
					if (artist.getUrl_music() == null) {
						artist.setUrl_music("");
					}
					if (artist.getUrl_sns() == null) {
						artist.setUrl_sns("");
					}

					artist_list.add(artist);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return artist_list;
	}

	public ArrayList<Profile> getApplyList() {
		String SQL = "SELECT * FROM ARTIST_APPLY WHERE applyresult='심사중'";
		ArrayList<String> id_list = new ArrayList<String>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			while (rs.next()) {
				id_list.add(rs.getString(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		SQL = "SELECT name,filename,genre,self_introduction,url_music,url_sns FROM user WHERE id= ?";

		ArrayList<Profile> apply_list = new ArrayList<Profile>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			for (int i = 0; i < id_list.size(); i++) {
				pstmt.setString(1, id_list.get(i));
				rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
				if (rs.next()) {
					Profile apply = new Profile();
					apply.setName(rs.getString(1));
					apply.setFilename(rs.getString(2));
					apply.setGenre(rs.getString(3));
					apply.setSelf_introduction(rs.getString(4));
					apply.setUrl_music(rs.getString(5));
					apply.setUrl_sns(rs.getString(6));

					if (apply.getGenre() == null) {
						apply.setGenre("");
					}
					if (apply.getSelf_introduction() == null) {
						apply.setSelf_introduction("");
					}
					if (apply.getUrl_music() == null) {
						apply.setUrl_music("");
					}
					if (apply.getUrl_sns() == null) {
						apply.setUrl_sns("");
					}

					apply_list.add(apply);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return apply_list;
	}

	public ArrayList<Profile> getFollowerList(String user_id) {
		String SQL = "SELECT followerid FROM follow WHERE id=?";
		ArrayList<String> id_list = new ArrayList<String>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_id);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			while (rs.next()) {
				id_list.add(rs.getString(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		SQL = "SELECT name,filename,genre,self_introduction,url_music,url_sns FROM user WHERE id= ?";

		ArrayList<Profile> follower_list = new ArrayList<Profile>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			for (int i = 0; i < id_list.size(); i++) {
				pstmt.setString(1, id_list.get(i));
				rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
				if (rs.next()) {
					Profile follower = new Profile();
					follower.setName(rs.getString(1));
					follower.setFilename(rs.getString(2));
					follower.setGenre(rs.getString(3));
					follower.setSelf_introduction(rs.getString(4));
					follower.setUrl_music(rs.getString(5));
					follower.setUrl_sns(rs.getString(6));

					if (follower.getGenre() == null) {
						follower.setGenre("");
					}
					if (follower.getSelf_introduction() == null) {
						follower.setSelf_introduction("");
					}
					if (follower.getUrl_music() == null) {
						follower.setUrl_music("");
					}
					if (follower.getUrl_sns() == null) {
						follower.setUrl_sns("");
					}

					follower_list.add(follower);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return follower_list;
	}

	public ArrayList<Profile> getFollowingList(String user_id) {
		String SQL = "SELECT id FROM follow WHERE followerid=?";
		ArrayList<String> id_list = new ArrayList<String>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_id);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			while (rs.next()) {
				id_list.add(rs.getString(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		SQL = "SELECT name,filename,genre,self_introduction,url_music,url_sns FROM user WHERE id= ?";

		ArrayList<Profile> following_list = new ArrayList<Profile>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			for (int i = 0; i < id_list.size(); i++) {
				pstmt.setString(1, id_list.get(i));
				rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
				if (rs.next()) {
					Profile following = new Profile();
					following.setName(rs.getString(1));
					following.setFilename(rs.getString(2));
					following.setGenre(rs.getString(3));
					following.setSelf_introduction(rs.getString(4));
					following.setUrl_music(rs.getString(5));
					following.setUrl_sns(rs.getString(6));

					if (following.getGenre() == null) {
						following.setGenre("");
					}
					if (following.getSelf_introduction() == null) {
						following.setSelf_introduction("");
					}
					if (following.getUrl_music() == null) {
						following.setUrl_music("");
					}
					if (following.getUrl_sns() == null) {
						following.setUrl_sns("");
					}

					following_list.add(following);

				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return following_list;
	}

	public int dofollow(String uid, String artistf) {
		String preSQL = "SELECT * FROM follow WHERE followerid=? AND id=?";

		try {
			PreparedStatement prepstmt = conn.prepareStatement(preSQL);
			prepstmt.setString(1, uid);
			prepstmt.setString(2, artistf);
			rs = prepstmt.executeQuery();
			if (rs.next()) {
				return -1; // 중복
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		String SQL = "INSERT INTO follow VALUES (?,?)";
		PreparedStatement pstmt;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, artistf);
			pstmt.setString(2, uid);

			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public int unfollow(String uid, String artistf) {

		String SQL = "DELETE FROM follow WHERE followerid=? AND id=?";
		PreparedStatement pstmt;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, uid);
			pstmt.setString(2, artistf);

			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public ArrayList<Profile> getArtistSearchList(String name, String genre) {

		ArrayList<Profile> artist_list = getArtistList();
		ArrayList<Profile> ga_list = new ArrayList<Profile>();

		String SQL = "SELECT name,filename,genre,self_introduction,url_music,url_sns FROM user WHERE name LIKE ? AND genre LIKE ?";

		if (name.equals("") && genre.equals("allGen")) {
			return artist_list;
		}

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			if (genre.equals("allGen")) {
				pstmt.setString(1, "%"+name + "%");
				pstmt.setString(2, "%");
			} else {
				pstmt.setString(1, "%"+name + "%");
				pstmt.setString(2, genre + "%");
			}

			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			while (rs.next()) {
				Profile aritst = new Profile();
				aritst.setName(rs.getString(1));
				aritst.setFilename(rs.getString(2));
				aritst.setGenre(rs.getString(3));
				aritst.setSelf_introduction(rs.getString(4));
				aritst.setUrl_music(rs.getString(5));
				aritst.setUrl_sns(rs.getString(6));

				if (aritst.getSelf_introduction() == null) {
					aritst.setSelf_introduction("");
				}
				if (aritst.getUrl_music() == null) {
					aritst.setUrl_music("");
				}
				if (aritst.getUrl_sns() == null) {
					aritst.setUrl_sns("");
				}

				ga_list.add(aritst);

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ga_list;
	}

	public int uploadIntroduction(String uid, String uname, String self_introduction, String url_music, String url_sns,
			String genre) {
		String SQL = "UPDATE user SET name=?,self_introduction=?,url_music=?,url_sns=?,genre=? WHERE id=?";
		PreparedStatement pstmt;
		try {
			pstmt = conn.prepareStatement(SQL);
			if (uname == null) {
				uname = getNickname(uid);
			}
			if (self_introduction == null) {
				self_introduction = getSelfIntroduction(uid);
			}
			if (url_music == null) {
				url_music = getMusicurl(uid);
			}
			if (url_sns == null) {
				url_sns = getSnsurl(uid);
			}
			pstmt.setString(1, uname);
			pstmt.setString(2, self_introduction);
			pstmt.setString(3, url_music);
			pstmt.setString(4, url_sns);
			pstmt.setString(5, genre);
			pstmt.setString(6, uid);

			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

}
