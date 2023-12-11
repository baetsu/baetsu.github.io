package com.joongang.mapper;

import java.sql.Timestamp;
import java.util.List;

import com.joongang.domain.PlaceVO;

public interface PlaceMapper {
	public List<PlaceVO> getResState(PlaceVO vo);
	public int hasReserved(PlaceVO vo);
	public int insert(PlaceVO vo);
	public List<PlaceVO> getResInfo(PlaceVO vo);
	public List<Integer> getPlaceNo();
}
