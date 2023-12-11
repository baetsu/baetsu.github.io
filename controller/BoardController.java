package com.joongang.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
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

import com.fasterxml.jackson.annotation.JsonFormat;
import com.google.gson.Gson;
import com.joongang.domain.BoardAttachVO;
import com.joongang.domain.BoardVO;
import com.joongang.domain.Criteria;
import com.joongang.domain.PageDTO;
import com.joongang.service.BoardService;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/board/*")
@Log4j2
public class BoardController {
	@Setter(onMethod_= @Autowired)
	private BoardService boardService;
	
	//게시물 등록 화면
	@GetMapping("/register")
	public String registerForm() {
		return "/board/registerForm";
	}
	//게시물 등록 확인
	@PostMapping("/register")
	public String registerForm2(BoardVO boardVO, RedirectAttributes ra) {
		boardService.register(boardVO);
		ra.addFlashAttribute("result", boardVO.getBno());
		return "redirect:/board/list";
	}
	//게시판 화면
	//페이징 기능 추가
	@GetMapping("/list")
	//creteria의 변수 2개(pageNum, amount)를 가져옴
	public String boardList(Criteria criteria, Model model, Long bno) {
		List<BoardVO> list = boardService.getList(criteria);
		model.addAttribute("list", list);
		int total = boardService.getTotal(criteria);
		//키값 = pageDTO -> list.jsp의 ${pageDTO.prev}
		model.addAttribute("pageDTO", new PageDTO(criteria, total));
		log.info(list + "total: " + total + "  " + criteria.getListLink());
		return "/board/list";
	}
	//게시물 상세보기
	@GetMapping("/get")
	public String getBno(@RequestParam("bno") Long bno, Model model,
						Criteria criteria) {
		//쿼리를 통해서 데이터가 넘어옴
		BoardVO boardVO = boardService.get(bno);
		//"vo" = 프엔에서 쓰이는 키값
		model.addAttribute("vo", boardVO);
		return "/board/get";
	}
	//게시물 수정화면
	@GetMapping("/modify")
	public String modify(@RequestParam("bno") Long bno, Model model,
						Criteria criteria) {
		BoardVO boardVO = boardService.get(bno);
		model.addAttribute("vo", boardVO);
		return "/board/modify";
	}
	//게시물 수정완료시
	@PostMapping("/modify")
	public String modify2(BoardVO board, RedirectAttributes ra,
					Criteria criteria) {
		if(boardService.modify(board)) {
			ra.addFlashAttribute("result", "success");
		}
		ra.addAttribute("pageNum", criteria.getPageNum());
		ra.addAttribute("amount", criteria.getAmount());
		return "redirect:/board/list";
	}
	//게시글 삭제
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, RedirectAttributes ra,
						Criteria criteria) {
		List<BoardAttachVO> attachList = boardService.getAttachList(bno);
		if(boardService.remove(bno)) {
			deleteFiles(attachList);
			ra.addFlashAttribute("result", "success");
		}
		//ra.addAttribute("pageNum", criteria.getPageNum());
		//ra.addAttribute("amount", criteria.getAmount());
		//return "redirect:/board/list";
		return "redirect:/board/list" + criteria.getListLink();
	}
	
	
	public void deleteFiles(List<BoardAttachVO> attachList) {
		if (attachList == null || attachList.size() == 0) {
			return;
		}
		for(BoardAttachVO attachVO : attachList) {
			try {
				Path file = Paths.get("C:\\upload\\" + attachVO.getUploadpath() +
						"\\" + attachVO.getUuid() + "_" + attachVO.getFilename());
				Files.deleteIfExists(file);
				if (Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get("C:\\upload\\" + attachVO.getUploadpath() +
							"\\s_" + attachVO.getUuid() + "_" + attachVO.getFilename());
					Files.delete(thumbNail);
				}
			} catch (Exception e) {
				log.error("delete file error" + e.getMessage());
			}
		}
	}
	
	
	
	
	//첨부파일 목록
	@GetMapping(value = "/getAttachList/{bno}",
			produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList (
			@PathVariable("bno") Long bno) {
		log.info("getAttachList" + bno);
		return new ResponseEntity<>(boardService.getAttachList(bno), HttpStatus.OK);
	}
	
	//첨부파일 화면에 보이기
	 @GetMapping(value = "/getAttachListOnList",
			 produces = MediaType.APPLICATION_JSON_VALUE)
	 public ResponseEntity<String> getAttachListOnList (
			 @RequestParam(value="list[]") List<Long> list) {
		 log.info("getAttachListOnList" + list.stream().collect(Collectors.toList()));
		 Map<Long, List<BoardAttachVO>> map = new HashMap<Long, List<BoardAttachVO>>();
		 for (Long bno : list) {
			 map.put(bno, boardService.getAttachList(bno));
		 }
		 String gson = new Gson().toJson(map, HashMap.class);
		 return new ResponseEntity<>(gson, HttpStatus.OK);
	 }
	 
	 @GetMapping(value = "/getRecentBoardList/{rownum}",
			 produces = MediaType.APPLICATION_JSON_VALUE)
	 @ResponseBody
	 public ResponseEntity<List<BoardVO>> getRecentBoardList (
			 @PathVariable("rownum") Long rownum) {
		 log.info("getRecentBoardList " + rownum);
		 return new ResponseEntity<>(boardService.getRecentBoardList(rownum), HttpStatus.OK);
	 }
}
