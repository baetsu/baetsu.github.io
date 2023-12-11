package com.joongang.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class PlaceVO {
	private int srno;
	private String userid;
	private int sno;
	private Integer tno;
	private String duration;
	private String type;
	private Timestamp resdate;
	private Timestamp regdate;
}
