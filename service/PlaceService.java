package com.joongang.service;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.joongang.domain.PlaceVO;
import com.joongang.mapper.PlaceMapper;

import lombok.Setter;

@Service
public class PlaceService {
	@Setter(onMethod_=@Autowired)
	private PlaceMapper mapper;
	
	public List<PlaceVO> getResState(int sno, Timestamp resdate) {
		PlaceVO vo = new PlaceVO();
		vo.setSno(sno);
		vo.setResdate(resdate);
		return mapper.getResState(vo);
	}
	
	@Transactional(rollbackFor = SQLException.class)
	public int reservation(List<PlaceVO> list) throws SQLException {
		int result = 0;
		for(PlaceVO vo : list) {
			if(mapper.hasReserved(vo) != 0) {
				//이미 예약이 되어있을 경우 예외 발생
				throw new SQLException();
			}
			mapper.insert(vo);
		}
		result = list.stream().iterator().next().getSno();
		return result;
	}
	
	public List<PlaceVO> getResInfo(String userid, int sno, Timestamp resdate) {
		PlaceVO vo = new PlaceVO();
			vo.setUserid(userid);
			vo.setSno(sno);
			vo.setResdate(resdate);
		return mapper.getResInfo(vo);
	}
	
	public List<Integer> getPlaceNo() {
		List<Integer> list = mapper.getPlaceNo();
		return list;
	}
}
