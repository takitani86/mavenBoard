package ino.web.freeBoard.controller;

import ino.web.freeBoard.common.util.Paging;
import ino.web.freeBoard.dto.FreeBoardDto;
import ino.web.freeBoard.service.FreeBoardService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class FreeBoardController {

	@Autowired
	private FreeBoardService freeBoardService;
	
	@RequestMapping("/main.ino")
	public ModelAndView main(HttpServletRequest request,
			@RequestParam(defaultValue="") String searchType,
			@RequestParam(defaultValue="") String keyword,
			@RequestParam(defaultValue="1") int curPage) {
		ModelAndView mav = new ModelAndView();
		HashMap<String, Object> map = new HashMap<>();
		map.put("searchType", searchType);
		map.put("keyword", keyword);
		int count = freeBoardService.getCount(map);
		List<Map<String, Object>> searchList = freeBoardService.getSearchList(map);
		Paging page = new Paging(count, curPage);
		map.put("startPage", page.getPageBegin());
		map.put("endPage", page.getPageEnd());
		List<FreeBoardDto> list = freeBoardService.freeBoardList(map);
		
		mav.setViewName("boardMain");
		mav.addObject("searchList", searchList);
		mav.addObject("page", page);
		mav.addObject("searchType", searchType);
		mav.addObject("keyword", keyword);
		mav.addObject("freeBoardList", list);

		return mav;
	}
	
	// AJAX 검색기능
	@RequestMapping("/searchResult.ino")
	@ResponseBody
	public Map<String, Object> searchResult(HttpServletRequest request,
			@RequestParam(defaultValue="") String searchType,
			@RequestParam(defaultValue="") String keyword,
			@RequestParam(defaultValue="1") int curPage,
			@RequestParam(defaultValue="") String startDate,
			@RequestParam(defaultValue="") String endDate) {
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		map.put("searchType", searchType);
		map.put("keyword", keyword);
		if (keyword.equals("")) {
			map.clear();
			map.put("searchType", "DCODE003");
			map.put("startDate", startDate);
			map.put("endDate", endDate);
		}
		int count = freeBoardService.getCount(map);
		Paging page = new Paging(count, curPage);
		map.put("startPage", page.getPageBegin());
		map.put("endPage", page.getPageEnd());
		List<FreeBoardDto> list = new ArrayList<>();
		list = freeBoardService.freeBoardList(map);

		map.put("list", list);
		map.put("page", page);
		return map;
	}
	
	// 더미데이터 집어넣기
	@RequestMapping("/dummy.ino")
	public String dummy() {
		FreeBoardDto dto = new FreeBoardDto();
		for (int i = 0; i < 10; i++) {
			dto.setTitle(i + "번째 게시물입니다.");
			dto.setName("이상희");
			dto.setContent("더미게시물입니다.");
			freeBoardService.freeBoardInsertPro(dto);
		}
		System.out.println("10개의 게시물을 추가했습니다.");
		return "redirect:main.ino";
	}

	@RequestMapping("/freeBoardInsert.ino")
	public String freeBoardInsert() {
		return "freeBoardInsert";
	}

	@RequestMapping("/freeBoardInsertPro.ino")
	public String freeBoardInsertPro(HttpServletRequest request, FreeBoardDto dto) {
		freeBoardService.freeBoardInsertPro(dto);
		// int newNum = freeBoardService.getNewNum();
		return "redirect:main.ino";
	}

	@RequestMapping("/freeBoardDetail.ino")
	public ModelAndView freeBoardDetail(HttpServletRequest request) {
		FreeBoardDto dto = freeBoardService.getDetailByNum(Integer.parseInt(request.getParameter("num")));
		return new ModelAndView("freeBoardDetail", "freeBoardDto", dto);
	}

	@RequestMapping("/freeBoardModify.ino")
	public String freeBoardModify(HttpServletRequest request, FreeBoardDto dto) {
		freeBoardService.freeBoardModify(dto);
		return "redirect:/main.ino";
	}

	@RequestMapping("/freeBoardDelete.ino")
	public String freeBoardDelete(int num) {
		freeBoardService.FreeBoardDelete(num);
		return "redirect:/main.ino";
	}
}