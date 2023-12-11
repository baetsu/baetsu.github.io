package com.joongang.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UserDetailsRepositoryReactiveAuthenticationManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.joongang.domain.BoardAttachVO;
import com.joongang.domain.BoardVO;
import com.joongang.domain.Criteria;
import com.joongang.mapper.BoardAttachMapper;
import com.joongang.mapper.BoardMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class BoardService {
	//Autowired => BoardMapper를 연결하기 위해 사용(의존성 주입) 
	@Setter(onMethod_= @Autowired)
	private BoardMapper boardMapper;
	
	@Setter(onMethod_= @Autowired)
	private BoardAttachMapper attachMapper;
	
	//컨트롤러에서 넘어옴 BoardVO
	//글 등록 + 첨부파일 -> 함께 데이터가 저장
	public void register(BoardVO vo) {
		boardMapper.insert(vo);
		
		List<BoardAttachVO> list = vo.getAttachList();
		if (list == null || list.isEmpty()) {
			return;
		}
		for (BoardAttachVO attach : list) {
			attach.setBno(vo.getBno());
			attachMapper.insert(attach);
		}
	}
	//getList 호출
	public List<BoardVO> getList() {
		return boardMapper.getList();
	}
	//게시물의 정보를 받기위해 BoardVO -> 리턴타입
	public BoardVO get(Long bno) {
		return boardMapper.read(bno);
	}
	
	@Transactional
	public boolean modify(BoardVO vo) {
		log.info("modify .... " + vo);
		attachMapper.deleteAll(vo.getBno());
		boolean modifyResult = boardMapper.update(vo) == 1;
		List<BoardAttachVO> list = vo.getAttachList();
		if (modifyResult && list != null) {
			for (BoardAttachVO attachVO : list) {
				attachVO.setBno(vo.getBno());
				attachMapper.insert(attachVO);
			}
		}
		return modifyResult;
	}
	@Transactional
	public boolean remove(Long bno) {
		attachMapper.deleteAll(bno);
		return boardMapper.delete(bno) == 1;
	}
	
	public List<BoardVO> getList(Criteria criteria) {
		return boardMapper.getListWithPaging(criteria);
	}
	public int getTotal(Criteria criteria) {
		return boardMapper.getTotalCount(criteria);
	}
	
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("get Attach list by bno" + bno);
		return attachMapper.findByBno(bno);
	}
	
	public List<BoardVO> getRecentBoardList(Long rownum) {
		return boardMapper.getRecentBoardList(rownum);
	}
	
}
