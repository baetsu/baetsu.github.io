package com.joongang.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.joongang.domain.AuthVO;
import com.joongang.domain.MemberVO;
import com.joongang.service.MemberService;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/member/*")
@Log4j2
public class MemberController {
	@Setter(onMethod_= @Autowired)
	private MemberService memberService;
	
	@GetMapping("/signup")
	//jsp를 리턴하므로 String형
	public String signupForm() {
		//화면에 회원가입페이지 가져오기
		return "/member/signupForm";
	}
	
	@PostMapping("/signup")
	//입력하고 회원가입 버튼 클릭시 form에 입력된 데이터들 가져오기
	//@ModelAttribute생략
	public String signupForm2(MemberVO vo, HttpSession session) {
		//signup호출 = DB에 데이터 저장
		log.info("비밀번호1:" + vo.getUserpw());
		memberService.signup(vo);
		log.info("비밀번호2:" + vo.getUserpw());
		
		//회원가입시 로그인 되기
		try {
			AuthVO authVO = memberService.authenticate(vo);
			session.setAttribute("auth", authVO);
		} catch (Exception e) {
			
		}
		
		//회원가입, 수정 => redirect이용
		return "redirect:/";
	}
	
	@GetMapping("/login")
	public String loginForm() {
		return "/member/loginForm";
	}
	
	@PostMapping("/login")
	public String loginForm2(MemberVO vo, HttpSession session,
			RedirectAttributes ra) {
		try {
			AuthVO authVO = memberService.authenticate(vo);
			//로그인 한 사람의 정보가 session에 저장 (키값 = auth)
			session.setAttribute("auth", authVO);
			//필터 기능
			//object형으로 리턴되므로 형변환해줌
			String userURI = (String)session.getAttribute("userURI");
			if(userURI != null) {	//값이 저장된 상태(로그인 상태)
				//기존의 작업 삭제
				session.removeAttribute(userURI);
				return "redirect:" + userURI;
			}
			return "redirect:/";
		} catch (Exception e) {
			//입력한 id, pw가 없거나 안맞을 경우
			//(memberService>try/catch>exception예외 메시지 출력)
			ra.addFlashAttribute("error", e.getMessage());
			ra.addFlashAttribute("memberVO", vo);
			return "redirect:/member/login";
		}
	}
	//로그아웃 - 세션 삭제 & 홈화면으로 이동 & 메시지(로그아웃 되었습니다) 출력
	@GetMapping("/logout")
	public String logout(HttpSession session, RedirectAttributes ra) {
		//키값 auth제거
		session.removeAttribute("auth");
		ra.addFlashAttribute("msg", "logout");
		return "redirect:/";
	}
}
