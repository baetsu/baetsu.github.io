package com.joongang.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.joongang.domain.Criteria;
import com.joongang.domain.ReplyVO;

public interface ReplyMapper {
	public int insert(ReplyVO replyVO);
	public ReplyVO read(Long bno);
	public int delete(Long bno);
	public int update(ReplyVO replyVO);
	public List<ReplyVO> getList(Long bno);
	
	public List<ReplyVO> getListWithPaging(@Param("criteria")Criteria criteria, @Param("bno")Long bno);
	public int getTotalCount(Long bno);
}
