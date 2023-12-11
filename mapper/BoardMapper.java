package com.joongang.mapper;

import java.util.List;

import com.joongang.domain.BoardVO;
import com.joongang.domain.Criteria;

public interface BoardMapper {
	public void insert(BoardVO boardVO);
	public List<BoardVO> getList();
	public BoardVO read(Long bno);
	public int update(BoardVO vo);
	public int delete(Long bno);
	public List<BoardVO> getListWithPaging(Criteria criteria);
	public int getTotalCount(Criteria criteria);
	
	public List<BoardVO> getRecentBoardList(Long rownum);
}
