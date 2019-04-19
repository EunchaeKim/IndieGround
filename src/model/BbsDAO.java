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
			rs = pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� ��
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
			rs = pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� ��
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
			rs = pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� ��
			if (rs.next()) {
				return rs.getString(1); // ���� ��¥�� �״�� ��ȯ
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; // DB����
	}

	public int getNext() {
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� ��
			if (rs.next()) {
				return rs.getInt(1) + 1; // ���� ��¥�� �״�� ��ȯ
			}
			return 1; // ù��° �Խù��� ���
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB����
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
					bbsLocation = "����";
				} else if (bbsLocation.equals("gyunggi")) {
					bbsLocation = "���";
				} else if (bbsLocation.equals("daegu")) {
					bbsLocation = "�뱸";
				} else if (bbsLocation.equals("busan")) {
					bbsLocation = "�λ�";
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

			rs = pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� ��
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

			// rs=pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� �� insert���� �ʿ����
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB����
	}

	public ArrayList<Bbs> getList(int pageNumber) {
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� ��
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
			rs = pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� ��
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
			rs = pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� ��
			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false; // DB����
	}

	public Bbs getBbs(int bbsID) {
		String SQL = "SELECT * FROM BBS WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� ��
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
		return null; // DB����
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
			// rs=pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� �� insert���� �ʿ����
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB����
	}

	public int getFund(int bbsID) { // Ư�� ������ ���� �� �ݵ��ݾ�
		String SQL = "SELECT bbsCurrFund FROM BBS WHERE bbsID= ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� ��
			int totalFund=0;
			while (rs.next()) {
				totalFund+= rs.getInt(1);
			}
			return totalFund;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB����
	}

	public int setFund(int bbsID, int money) { // �ݵ��ݾ� ����	
		
		String SQL = "UPDATE BBS SET bbsCurrFund=? WHERE bbsID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getFund(bbsID) + money);
			pstmt.setInt(2, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB����
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
		return -1; // DB����
	}

	public String progress(int bbsID) { // ���� ���� ��Ȳ
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
					return "������";
			}
			rs = pstmt2.executeQuery();
			if (rs.next()) {
				return "�ݵ�������";
			}

			return "�ݵ�����";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null; // DB����
	}

	public ArrayList<Profile> getlineup(int bbsID) { // Ư�� ������ ���ξ� ����Ʈ
		String SQL = "SELECT A.name,A.filename,A.genre,A.self_introduction,A.url_music,A.url_sns FROM user A INNER JOIN concertlineup B ON A.name=B.artist WHERE B.bbsID=?";
		ArrayList<Profile> list = new ArrayList<Profile>();

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� ��
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

			// rs=pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� �� insert���� �ʿ����
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB����
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
		return -1; // DB����
	}

	public int updateLineup(int bbsID, String artist) {

		String SQL = "INSERT INTO concertlineup VALUES(?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			pstmt.setString(2, artist);
			pstmt.setInt(3, 0);

			// rs=pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� �� insert���� �ʿ����
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB����
	}

	public String artistParticipate(String artist, int bbsID) {
		String SQL = "SELECT participate from concertlineup where artist=? AND bbsID=?";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, artist);
			pstmt.setInt(2, bbsID);
			rs = pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� ��
			if (rs.next()) {
				if (rs.getInt(1) == 1) {
					return "���ܿϷ�";
				} else if (rs.getInt(1) == 0) {
					return "������";
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null; // DB����
	}

	public int isParticipate(String artist, int bbsID) {
		String SQL = "SELECT participate from concertlineup where artist=? AND bbsID=?";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, artist);
			pstmt.setInt(2, bbsID);
			rs = pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� ��
			if (rs.next()) {
				return rs.getInt(1); // 1 ���ܿϷ� 0 ������
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB����
	}

	public int declineParticipate(String artist, int bbsID) { // ���� ���� ����
		String SQL = "delete from concertlineup where artist=? AND bbsID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, artist);
			pstmt.setInt(2, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB����
	}

	public int acceptParticipate(String artist, int bbsID) { // ���� ���� �³�
		String SQL = "UPDATE concertlineup SET participate=1 WHERE artist=? AND bbsID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, artist);
			pstmt.setInt(2, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB����
	}

	public ArrayList<Bbs> getrequestlist(String artist) { // ��Ƽ��Ʈ�� �⿬��û���� ����
		String SQL = "SELECT B.* FROM concertlineup A INNER JOIN bbs B ON A.bbsID=B.bbsID WHERE A.artist=? AND B.bbsAvailable=1";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, artist);
			rs = pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� ��
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

	public ArrayList<Bbs> getfundedlist(String userID) { // �ݵ��ߴ� �������� ����Ʈ
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

	public int getfundedmoney(String userID, int bbsID) { // Ư�� ������ ���� �ݵ��ݾ�
		String SQL = "SELECT A.fund FROM fundbbs A INNER JOIN bbs B ON A.bbsID=B.bbsID WHERE A.userID=? AND A.bbsID=? AND B.bbsAvailable=1";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setInt(2, bbsID);
			rs = pstmt.executeQuery(); // �������� �� ������ ����� ������ �� �ֵ��� ��
			if (rs.next()) {
				return rs.getInt(1); // �ߺ����� �ݵ� ����!
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
				return rs.getInt(1); // �ߺ�����
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public int fundingConcert(String userID, int bbsID, int money) { // ������ �ݵ��ϱ�
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
		return -1; // DB����
	}
	
	public ArrayList<String> getAlertFollowingList(String userID) {
		String SQL = "select B.id FROM bbs A INNER JOIN follow B WHERE A.bbsAvailable=1 AND B.followerid=? ORDER BY A.bbsDate DESC";
		ArrayList<String> list = new ArrayList<String>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				list.add(rs.getString(1)); // �ߺ�����
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public ArrayList<Bbs> getAlertBbsList(String userID) { // �ֽż����� �ȷ��� ��Ƽ��Ʈ�� ������ ���� ��� ����. �ܷ�Ű �ɷ������� ����X

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
