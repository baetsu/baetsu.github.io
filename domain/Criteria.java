package com.joongang.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Data;

@Data
public class Criteria {
	private static final int app = 10;
	private int pageNum;
	private int amount;
	
	private String type;
	private String keyword;
	
	//1부터 시작해서 10개를 가져온다
	public Criteria() {
		this(1, app);
	}
	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}
	public String getListLink() {
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("pageNum", this.pageNum)
				.queryParam("amount", this.getAmount())
				.queryParam("type", this.getType())
				.queryParam("keyword", this.getKeyword());
		return builder.toUriString();
	}
	
	public String[] getTypeArr() {
		return type == null? new String[] {} : type.split("");
	}
}
