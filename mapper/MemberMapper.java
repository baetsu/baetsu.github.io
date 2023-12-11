package com.joongang.mapper;

import com.joongang.domain.MemberVO;

public interface MemberMapper {
	
	public void insert(MemberVO vo);
	public MemberVO selectMemberByUserid(String userid);
}
