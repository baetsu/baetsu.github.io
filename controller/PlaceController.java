package com.joongang.controller;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.joongang.domain.AuthVO;
import com.joongang.domain.PlaceVO;
import com.joongang.service.PlaceService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@AllArgsConstructor
@RequestMapping("/place/*")
@Log4j2
public class PlaceController {
	private PlaceService service;
	
	@ResponseBody
	@GetMapping(value = "/getResState",
			produces = { MediaType.APPLICATION_JSON_VALUE })
	public ResponseEntity<List<PlaceVO>> getResState(@RequestParam(value="sno") int sno,
			@RequestParam(value="resdate") Long resdate) {
		Instant instant = Instant.ofEpochMilli(resdate);
		Timestamp ts = Timestamp.from(instant);
		List<PlaceVO> list = service.getResState(sno, ts);
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	//예약 버튼 클릭
	@ResponseBody
	@PostMapping(value = "/reservation", consumes = "application/json",
		produces = { MediaType.APPLICATION_JSON_VALUE })
	public ResponseEntity<Integer> reservation(@RequestBody List<PlaceVO> list) {
		log.info("PlaceVO: " + list);
		int placeNo = 0;
		try {
			placeNo = service.reservation(list);
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		return new ResponseEntity<>(placeNo, HttpStatus.OK);
	}
	
	//예약 내역 조회
	@ResponseBody
	@GetMapping(value = "/getResInfo",
			produces = { MediaType.APPLICATION_JSON_VALUE })
	public ResponseEntity<List<PlaceVO>> getResInfo(@RequestParam(value="sno") int sno,
			@RequestParam(value="resdate") Long resdate, HttpSession session) {
		Instant instant = Instant.ofEpochMilli(resdate);
		Timestamp ts = Timestamp.from(instant);
		AuthVO auth = (AuthVO)session.getAttribute("auth");
		List<PlaceVO> list = service.getResInfo(auth.getUserid(), sno, ts);
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	//공간번호(좌석) 불러오기
	@ResponseBody
	@GetMapping(value = "/getPlaceNo", produces = {MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<List<Integer>> getResState(HttpSession session) {
		List<Integer> list = service.getPlaceNo();
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	//예약 페이지로 이동
	@GetMapping(value = "/main")
	public String reservation(Model model) {
		return "/place/main";
	}
	

}
