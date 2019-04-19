package model;

public class Profile {
	
	private String name;
	private String filename;
	private String genre;
	private String self_introduction;
	private String url_music;
	private String url_sns;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public String getGenre() {
		return genre;
	}
	public void setGenre(String genre) {
		this.genre = genre;
	}
	public String getSelf_introduction() {
		return self_introduction;
	}
	public void setSelf_introduction(String self_introduction) {
		this.self_introduction = self_introduction;
	}
	public String getUrl_music() {
		return url_music;
	}
	public void setUrl_music(String url_music) {
		this.url_music = url_music;
	}
	public String getUrl_sns() {
		return url_sns;
	}
	public void setUrl_sns(String url_sns) {
		this.url_sns = url_sns;
	}
}
