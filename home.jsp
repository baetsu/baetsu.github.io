<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="./includes/header.jsp" %>
<html>
<head>
	<title></title>
</head>
<script src="/resources/js/replyService.js"></script>
<link rel="stylesheet" href="/resources/css/home.css">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
$(function() {
	let msg = "${msg}";
	if(msg === "") {
		return;
	}
	let txt;
	if(msg === "logout") {
		txt = "로그아웃 되었습니다.";
	}
	alert(txt);
});

//board
$(function() {
	let rownum = 5;
	$.getJSON("/board/getRecentBoardList/"+rownum, function(data) {
    	//console.log(data);
    	let str = "";
		let boardList = $(".recent_boardUL");
		
		for(let i=0; i < rownum; i++) {
			str += "<li>";
			str += " <a href='" + data[i].bno + "'>";
			str += "  <span>" + data[i].title + "</span>";
			str += "  <span>" + ReplyService.displyTime2(data[i].regdate) + "</span></a>";
			str += "</li>";
		}
		boardList.html(str);
		
    });
		$(".recent_boardUL").on("click", "li a", function(e) {
			e.preventDefault();
			console.log('a click');
			let form = $('<form></form>');
			form.attr("method", "get");
			form.attr("action", "/board/get");
			form.append("<input type='hidden' name='bno' value='" + $(this).attr("href") + "'>");
			form.appendTo('body');
			form.submit();
		});
		
});
//notice
$(function() {
	let rownum = 5;
	$.getJSON("/notice/getRecentNoticeList/"+rownum, function(data) {
    	console.log(data);
    	let str = "";
		let noticeList = $(".recent_noticeUL");
		
		for(let i=0; i < rownum; i++) {
			str += "<li>";
			str += " <a href='" + data[i].bno + "'>";
			str += "  <span>" + data[i].title + "</span>";
			str += "  <span>" + ReplyService.displyTime2(data[i].regdate) + "</span></a>";
			str += "</li>";
		}
		noticeList.html(str);
		
    });
		$(".recent_noticeUL").on("click", "li a", function(e) {
			e.preventDefault();
			console.log('a click');
			let form = $('<form></form>');
			form.attr("method", "get");
			form.attr("action", "/notice/noticeGet");
			form.append("<input type='hidden' name='bno' value='" + $(this).attr("href") + "'>");
			form.appendTo('body');
			form.submit();
		});
		
		let board = $(".wrapper_board");
		let notice = $(".wrapper_notice");
		$("#t_board").on("click", function() {
			console.log('board show');
			board.show();
			notice.hide();
		});
		$("#t_notice").on("click", function() {
			console.log('notice show');
			board.hide();
			notice.show();
		});
		
});
</script>
<body>
    <div class="wrapper_home">

        <div class="home_image">
            <img src="/resources/img/banner(1).jpg" class="main_img">
        </div>

        <div class="home_content">
        	<form>
            <div class="home_notice">
                <div class="post_title">
                    <a href="#" id="t_board"><label>자유게시판</label></a>
                    <a href="#" id="t_notice"><label>공지사항</label></a>
                </div>
                <div>
	                <div class="wrapper_board">
	                    <ul class="recent_boardUL">
	                       
	                    </ul>
	                </div>
	                <div class="wrapper_notice">
	                	<ul class="recent_noticeUL">
	                	
	                	</ul>
	                </div>
                </div>
            </div>
        	</form>

            <div class="home_banner">

                <img src="/resources/img/card news_01.png" class="banner_img">
            </div>
        </div>
    </div>
	



</html>
<%@include file="./includes/footer.jsp" %>