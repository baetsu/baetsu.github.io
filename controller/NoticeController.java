package com.joongang.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.joongang.domain.BoardAttachVO;
import com.joongang.domain.BoardVO;
import com.joongang.domain.Criteria;
import com.joongang.domain.PageDTO;
import com.joongang.service.NoticeService;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/notice/*")
@Log4j2
public class NoticeController {
	@Setter(onMethod_= @Autowired)
	private NoticeService noticeService;
	
	//공지사항 목록
	@GetMapping("/noticeList")
	public String boardList(Criteria criteria, Model model, Long bno) {
		List<BoardVO> list = noticeService.getList(criteria);
		model.addAttribute("list", list);
		int total = noticeService.getTotal(criteria);
		model.addAttribute("pageDTO", new PageDTO(criteria, total));
		log.info(list + "total: " + total + "  " + criteria.getListLink());
		return "/notice/noticeList";
	}
	
	//공지사항 상세보기
	@GetMapping("/noticeGet")
	public String getBno(@RequestParam("bno") Long bno, Model model,
						Criteria criteria) {
		BoardVO boardVO = noticeService.get(bno);
		model.addAttribute("notice", boardVO);
		return "/notice/noticeGet";
	}
	
	//첨부파일 목록
	@GetMapping(value = "/getAttachList/{bno}",
		produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList (
			@PathVariable("bno") Long bno) {
		log.info("getAttachList" + bno);
		return new ResponseEntity<>(noticeService.getAttachList(bno), HttpStatus.OK);
	}
		
	//첨부파일 화면에 보이기
	@GetMapping(value = "/getAttachListOnList",
		produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> getAttachListOnList (
			@RequestParam(value="list[]") List<Long> list) {
		log.info("getAttachListOnList" + list.stream().collect(Collectors.toList()));
		Map<Long, List<BoardAttachVO>> map = new HashMap<Long, List<BoardAttachVO>>();
		for (Long bno : list) {
			map.put(bno, noticeService.getAttachList(bno));
		}
		String gson = new Gson().toJson(map, HashMap.class);
		return new ResponseEntity<>(gson, HttpStatus.OK);
	}
	
	 @GetMapping(value = "/getRecentNoticeList/{rownum}",
			 produces = MediaType.APPLICATION_JSON_VALUE)
	 @ResponseBody
	 public ResponseEntity<List<BoardVO>> getRecentNoticeList (
			 @PathVariable("rownum") Long rownum) {
		 log.info("getRecentNoticeList " + rownum);
		 return new ResponseEntity<>(noticeService.getRecentNoticeList(rownum), HttpStatus.OK);
	 }
}
