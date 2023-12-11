package com.joongang.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.joongang.domain.AuthVO;
import com.joongang.domain.MemberVO;
import com.joongang.mapper.MemberMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class MemberService {
	//new로 쓰는건 vo만 가능하므로 @Autowired사용
	@Setter(onMethod_ = @Autowired)
	private MemberMapper mapper;
	
	
	@Setter(onMethod_ = @Autowired)
	private PasswordEncoder pwencoder;
	
	
	//프론트에서 입력한 정보(회원가입)가 컨트롤러로 이동 -> 값들을 memberVO클래스를 이용해 받아들임
	//비번 인코딩 (암호화)
	public void signup(MemberVO vo) {
		vo.setUserpw(pwencoder.encode(vo.getUserpw()));
		mapper.insert(vo);
	}
	
	//입력된 id, pw로 정보들 불러와 입력값과 비교(인코딩된 pw를 디코딩하기 위해 matches사용)
	public AuthVO authenticate(MemberVO vo) throws Exception {
		//로그인 할 때 입력한 id/pw으로 MemberVO에 저장된 DB를 가져옴 (나머지 정보들 불러오기)
		MemberVO selectVO = mapper.selectMemberByUserid(vo.getUserid());
		
		//입력한 id/pw와 DB에 저장된 데이터 비교
		//matches(rawData, db에 저장된 data)
		if (selectVO == null) {
			//미가입상태
			throw new Exception("nonuser");
		}
		if (!pwencoder.matches(vo.getUserpw(), selectVO.getUserpw())) {
			//exception 발생(비밀번호 오류)
			throw new Exception("nomatch");
		}
		//authVO에 불러온 값들 저장해서 return해주기
		AuthVO authVO = new AuthVO();
		authVO.setUserid(selectVO.getUserid());
		authVO.setUsername(selectVO.getUsername());
		return authVO;
	}
	
	
}
