package com.joongang.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.joongang.domain.BoardAttachVO;
import com.joongang.domain.BoardVO;
import com.joongang.domain.Criteria;
import com.joongang.mapper.BoardAttachMapper;
import com.joongang.mapper.NoticeAttachMapper;
import com.joongang.mapper.NoticeMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class NoticeService {
	@Setter(onMethod_= @Autowired)
	private NoticeMapper noticeMapper;
	
	@Setter(onMethod_= @Autowired)
	private NoticeAttachMapper attachMapper;
	
	
	
	
	public List<BoardVO> getList() {
		return noticeMapper.getList();
	}
	public BoardVO get(Long bno) {
		return noticeMapper.read(bno);
	}


	public List<BoardVO> getList(Criteria criteria) {
		return noticeMapper.getListWithPaging(criteria);
	}
	public int getTotal(Criteria criteria) {
		return noticeMapper.getTotalCount(criteria);
	}
	
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("get Attach list by bno" + bno);
		return attachMapper.findByBno(bno);
	}
	
	public List<BoardVO> getRecentNoticeList(Long rownum) {
		return noticeMapper.getRecentNoticeList(rownum);
	}
}
