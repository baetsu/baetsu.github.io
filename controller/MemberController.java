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
	public String signupForm() {
		return "/member/signupForm";
	}
	
	@PostMapping("/signup")
	//@ModelAttribute생략
	public String signupForm2(MemberVO vo, HttpSession session) {
		log.info("비밀번호1:" + vo.getUserpw());
		memberService.signup(vo);
		log.info("비밀번호2:" + vo.getUserpw());
		
		//회원가입시 로그인 되기
		try {
			AuthVO authVO = memberService.authenticate(vo);
			session.setAttribute("auth", authVO);
		} catch (Exception e) {
			e.printstacktrace();
		}
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
			session.setAttribute("auth", authVO);
			String userURI = (String)session.getAttribute("userURI");
			if(userURI != null) {
				session.removeAttribute(userURI);
				return "redirect:" + userURI;
			}
			return "redirect:/";
		} catch (Exception e) {
			ra.addFlashAttribute("error", e.getMessage());
			ra.addFlashAttribute("memberVO", vo);
			return "redirect:/member/login";
		}
	}
	@GetMapping("/logout")
	public String logout(HttpSession session, RedirectAttributes ra) {
		session.removeAttribute("auth");
		ra.addFlashAttribute("msg", "logout");
		return "redirect:/";
	}
}
