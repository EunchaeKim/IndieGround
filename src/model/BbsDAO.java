package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Properties;

public class BbsDAO {
	private Connection conn;
	private ResultSet rs;

	public BbsDAO() {
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

	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				return rs.getString(1); // 현재 날짜를 그대로 반환
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; // DB오류
	}

	public int getNext() {
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				return rs.getInt(1) + 1; // 현재 날짜를 그대로 반환
			}
			return 1; // 첫번째 게시물인 경우
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB오류
	}

	public ArrayList<Bbs> getSearchList(String bbsLocation, String bbsGenre, String bbsTitle) {
		String SQL = "SELECT * FROM BBS WHERE bbsLocation LIKE ? AND bbsGenre LIKE ? AND bbsTitle LIKE ? AND bbsAvailable=1";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			if (bbsLocation.equals("allLoc")) {
				bbsLocation = "%";
			} else {
				if (bbsLocation.equals("seoul")) {
					bbsLocation = "서울";
				} else if (bbsLocation.equals("gyunggi")) {
					bbsLocation = "경기";
				} else if (bbsLocation.equals("daegu")) {
					bbsLocation = "대구";
				} else if (bbsLocation.equals("busan")) {
					bbsLocation = "부산";
				}
				bbsLocation = bbsLocation + "%";
			}
			if (bbsGenre.equals("allGen")) {
				bbsGenre = "%";
			}
			if (bbsTitle == null) {
				bbsTitle = "%";
			} else {
				bbsTitle = "%" + bbsTitle + "%";
			}

			pstmt.setString(1, bbsLocation);
			pstmt.setString(2, bbsGenre);
			pstmt.setString(3, bbsTitle);

			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			while (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				bbs.setBbsLocation(rs.getString(7));
				bbs.setBbsGenre(rs.getString(8));
				bbs.setBbsCurrfund(rs.getInt(9));
				bbs.setBbsTargetfund(rs.getInt(10));
				bbs.setBbsDeadline(rs.getString(11));
				bbs.setBbsConcertday(rs.getString(12));
				list.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public int write(String bbsTitle, String userID, String bbsContent, String bbsLocation, String bbsGenre,
			int bbsTargetfund, String bbsDeadline, String bbsConcertday) {
		String SQL = "INSERT INTO BBS VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);
			pstmt.setString(7, bbsLocation);
			pstmt.setString(8, bbsGenre);
			pstmt.setInt(9, 0);
			pstmt.setInt(10, bbsTargetfund);
			pstmt.setString(11, bbsDeadline);
			pstmt.setString(12, bbsConcertday);

			// rs=pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함 insert에는 필요없음
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB오류
	}

	public ArrayList<Bbs> getList(int pageNumber) {
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			while (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				bbs.setBbsLocation(rs.getString(7));
				bbs.setBbsGenre(rs.getString(8));
				bbs.setBbsCurrfund(rs.getInt(9));
				bbs.setBbsTargetfund(rs.getInt(10));
				bbs.setBbsDeadline(rs.getString(11));
				bbs.setBbsConcertday(rs.getString(12));
				list.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public ArrayList<Bbs> getmyConcert(String userID) {
		String SQL = "SELECT * FROM BBS WHERE userID=? AND bbsAvailable = 1";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			while (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				bbs.setBbsLocation(rs.getString(7));
				bbs.setBbsGenre(rs.getString(8));
				bbs.setBbsCurrfund(rs.getInt(9));
				bbs.setBbsTargetfund(rs.getInt(10));
				bbs.setBbsDeadline(rs.getString(11));
				bbs.setBbsConcertday(rs.getString(12));
				list.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false; // DB오류
	}

	public Bbs getBbs(int bbsID) {
		String SQL = "SELECT * FROM BBS WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				bbs.setBbsLocation(rs.getString(7));
				bbs.setBbsGenre(rs.getString(8));
				bbs.setBbsCurrfund(rs.getInt(9));
				bbs.setBbsTargetfund(rs.getInt(10));
				bbs.setBbsDeadline(rs.getString(11));
				bbs.setBbsConcertday(rs.getString(12));
				return bbs;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null; // DB오류
	}

	public int update(int bbsID, String bbsTitle, String bbsContent, String bbsLocation, String bbsGenre,
			int bbsTargetfund, String bbsDeadline, String bbsConcertday) {
		String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent =?, bbsLocation = ?, bbsGenre = ?, bbsTargetfund = ?, bbsDeadline = ?, bbsConcertday = ? WHERE bbsID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setString(3, bbsLocation);
			pstmt.setString(4, bbsGenre);
			pstmt.setInt(5, bbsTargetfund);
			pstmt.setString(6, bbsDeadline);
			pstmt.setString(7, bbsConcertday);
			pstmt.setInt(8, bbsID);
			// rs=pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함 insert에는 필요없음
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB오류
	}

	public int getFund(int bbsID) { // 특정 공연에 대한 총 펀딩금액
		String SQL = "SELECT bbsCurrFund FROM BBS WHERE bbsID= ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			int totalFund=0;
			while (rs.next()) {
				totalFund+= rs.getInt(1);
			}
			return totalFund;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB오류
	}

	public int setFund(int bbsID, int money) { // 펀딩금액 수정	
		
		String SQL = "UPDATE BBS SET bbsCurrFund=? WHERE bbsID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getFund(bbsID) + money);
			pstmt.setInt(2, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB오류
	}

	public int delete(int bbsID) {
		String SQL = "UPDATE BBS SET bbsAvailable=0 WHERE bbsID= ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB오류
	}

	public String progress(int bbsID) { // 공연 진행 상황
		String SQL = "SELECT A.participate FROM concertlineup A INNER JOIN bbs B ON A.bbsID=B.bbsID WHERE B.bbsAvailable=1 AND A.bbsID=?";
		String SQL2 = "SELECT * from bbs WHERE date(bbsDeadline)>=NOW() and bbsID=?";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			PreparedStatement pstmt2 = conn.prepareStatement(SQL2);
			pstmt.setInt(1, bbsID);
			pstmt2.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getInt(1) == 0)
					return "섭외중";
			}
			rs = pstmt2.executeQuery();
			if (rs.next()) {
				return "펀딩진행중";
			}

			return "펀딩마감";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null; // DB오류
	}

	public ArrayList<Profile> getlineup(int bbsID) { // 특정 공연의 라인업 리스트
		String SQL = "SELECT A.name,A.filename,A.genre,A.self_introduction,A.url_music,A.url_sns FROM user A INNER JOIN concertlineup B ON A.name=B.artist WHERE B.bbsID=?";
		ArrayList<Profile> list = new ArrayList<Profile>();

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			while (rs.next()) {
				Profile artist = new Profile();
				artist.setName(rs.getString(1));
				artist.setFilename(rs.getString(2));
				artist.setGenre(rs.getString(3));
				artist.setSelf_introduction(rs.getString(4));
				artist.setUrl_music(rs.getString(5));
				artist.setUrl_sns(rs.getString(6));
				if (artist.getSelf_introduction() == null) {
					artist.setSelf_introduction("");
				}
				if (artist.getUrl_music() == null) {
					artist.setUrl_music("");
				}
				if (artist.getUrl_sns() == null) {
					artist.setUrl_sns("");
				}
				list.add(artist);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public int lineup(String name) {
		String SQL = "INSERT INTO concertlineup VALUES(?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, name);
			pstmt.setInt(3, 0);

			// rs=pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함 insert에는 필요없음
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB오류
	}

	public int deletelineup(int bbsID) {
		String SQL = "DELETE FROM concertlineup WHERE bbsID= ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB오류
	}

	public int updateLineup(int bbsID, String artist) {

		String SQL = "INSERT INTO concertlineup VALUES(?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			pstmt.setString(2, artist);
			pstmt.setInt(3, 0);

			// rs=pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함 insert에는 필요없음
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB오류
	}

	public String artistParticipate(String artist, int bbsID) {
		String SQL = "SELECT participate from concertlineup where artist=? AND bbsID=?";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, artist);
			pstmt.setInt(2, bbsID);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				if (rs.getInt(1) == 1) {
					return "섭외완료";
				} else if (rs.getInt(1) == 0) {
					return "섭외중";
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null; // DB오류
	}

	public int isParticipate(String artist, int bbsID) {
		String SQL = "SELECT participate from concertlineup where artist=? AND bbsID=?";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, artist);
			pstmt.setInt(2, bbsID);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				return rs.getInt(1); // 1 섭외완료 0 섭외중
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB오류
	}

	public int declineParticipate(String artist, int bbsID) { // 공연 참여 거절
		String SQL = "delete from concertlineup where artist=? AND bbsID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, artist);
			pstmt.setInt(2, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB오류
	}

	public int acceptParticipate(String artist, int bbsID) { // 공연 참여 승낙
		String SQL = "UPDATE concertlineup SET participate=1 WHERE artist=? AND bbsID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, artist);
			pstmt.setInt(2, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB오류
	}

	public ArrayList<Bbs> getrequestlist(String artist) { // 아티스트가 출연요청받은 공연
		String SQL = "SELECT B.* FROM concertlineup A INNER JOIN bbs B ON A.bbsID=B.bbsID WHERE A.artist=? AND B.bbsAvailable=1";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, artist);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			while (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				bbs.setBbsLocation(rs.getString(7));
				bbs.setBbsGenre(rs.getString(8));
				bbs.setBbsCurrfund(rs.getInt(9));
				bbs.setBbsTargetfund(rs.getInt(10));
				bbs.setBbsDeadline(rs.getString(11));
				bbs.setBbsConcertday(rs.getString(12));
				list.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public ArrayList<Bbs> getfundedlist(String userID) { // 펀딩했던 공연들의 리스트
		String SQL = "SELECT B.* FROM fundbbs A INNER JOIN bbs B ON A.bbsID=B.bbsID WHERE A.userID=? AND B.bbsAvailable=1";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				bbs.setBbsLocation(rs.getString(7));
				bbs.setBbsGenre(rs.getString(8));
				bbs.setBbsCurrfund(rs.getInt(9));
				bbs.setBbsTargetfund(rs.getInt(10));
				bbs.setBbsDeadline(rs.getString(11));
				bbs.setBbsConcertday(rs.getString(12));
				list.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public int getfundedmoney(String userID, int bbsID) { // 특정 공연에 대한 펀딩금액
		String SQL = "SELECT A.fund FROM fundbbs A INNER JOIN bbs B ON A.bbsID=B.bbsID WHERE A.userID=? AND A.bbsID=? AND B.bbsAvailable=1";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setInt(2, bbsID);
			rs = pstmt.executeQuery(); // 실행했을 때 나오는 결과를 가져올 수 있도록 함
			if (rs.next()) {
				return rs.getInt(1); // 중복으로 펀딩 가능!
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public int fundAvoidDup(String userID, int bbsID) {
		String SQL = "SELECT fund FROM fundbbs WHERE userID=? AND bbsID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setInt(2, bbsID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1); // 중복있음
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public int fundingConcert(String userID, int bbsID, int money) { // 공연에 펀딩하기
		int prevFund=fundAvoidDup(userID, bbsID);
		
		if (prevFund != -1) {
			String SQL2 = "UPDATE fundbbs SET fund=? WHERE userID=? AND bbsID=?";

			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL2);
				pstmt.setInt(1, prevFund+money);
				pstmt.setString(2, userID);
				pstmt.setInt(3, bbsID);
				return pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			}

		} else {
			String SQL = "INSERT INTO fundbbs VALUES(?, ?, ?)";

			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID);
				pstmt.setInt(2, bbsID);
				pstmt.setInt(3, money);
				return pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		return -1; // DB오류
	}
	
	public ArrayList<String> getAlertFollowingList(String userID) {
		String SQL = "select B.id FROM bbs A INNER JOIN follow B WHERE A.bbsAvailable=1 AND B.followerid=? ORDER BY A.bbsDate DESC";
		ArrayList<String> list = new ArrayList<String>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				list.add(rs.getString(1)); // 중복있음
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public ArrayList<Bbs> getAlertBbsList(String userID) { // 최신순으로 팔로잉 아티스트가 참여한 공연 목록 구현. 외래키 걸려서인지 실행X

		String SQL = "select A.* FROM bbs A INNER JOIN follow B WHERE A.bbsAvailable=1 AND B.followerid=? ORDER BY A.bbsDate DESC";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				bbs.setBbsLocation(rs.getString(7));
				bbs.setBbsGenre(rs.getString(8));
				bbs.setBbsCurrfund(rs.getInt(9));
				bbs.setBbsTargetfund(rs.getInt(10));
				bbs.setBbsDeadline(rs.getString(11));
				bbs.setBbsConcertday(rs.getString(12));
				list.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

}
