package com.joongang.domain;

import lombok.Data;

@Data
public class PageDTO {
	private static final int ppl = 10;
	private int startPage;
	private int endPage;
	private boolean prev, next;
	
	private int total;
	private Criteria criteria;
	
	public PageDTO(Criteria criteria, int total) {
		this.criteria = criteria;
		this.total = total;
		
		this.endPage = (int) (Math.ceil(criteria.getPageNum() / (float)(ppl*1.0))) * ppl;
		this.startPage = this.endPage - (ppl-1);
		int realEnd = (int) (Math.ceil((total * 1.0) / criteria.getAmount()));
		if(realEnd < this.endPage) {
			this.endPage = realEnd;
		}
		this.prev = this.startPage > 1;
		this.next = this.endPage < realEnd;
	}
}
