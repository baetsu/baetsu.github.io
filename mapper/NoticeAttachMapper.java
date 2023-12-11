package com.joongang.mapper;

import java.util.List;

import com.joongang.domain.BoardAttachVO;

public interface NoticeAttachMapper {
	public void insert(BoardAttachVO attachVO);
	public List<BoardAttachVO> findByBno(Long bno);
	public void delete(String uuid);
	public void deleteAll(Long bno);
	public List<BoardAttachVO> getOldFiles(String uploadpath);
}
