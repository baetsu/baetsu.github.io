package com.joongang.domain;

import java.sql.Timestamp;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO {
	//rn = row number 데이터에 번호 매기기(리스트 불러올때 필요:범위로)
	private Long rn;
	private Long bno;
	private String title;
	private String content;
	private String writer;
	private Timestamp regdate;
	private Timestamp updatedate;
	
	private List<BoardAttachVO> attachList;
}
