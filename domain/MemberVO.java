package com.joongang.domain;

import java.sql.Timestamp;

import lombok.Data;
@Data
public class MemberVO {
	private String userid;
	private String userpw;
	private String username;
	private String location;
	private String gender;
	private Timestamp regdate;
	private Timestamp updatedate;
}
