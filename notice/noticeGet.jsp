<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/header.jsp"%>
<link rel="stylesheet" href="/resources/css/noticeGet.css">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
$(function() {
	const operForm = $("#operForm");
	$("#list_btn").on('click', function(e) {
		self.location = "/notice/noticeList";
	});
	
	let bno = '<c:out value="${notice.bno}"/>';
	$.getJSON("/notice/getAttachList/" + bno, function(attachList) {
		console.log("attachList:" + attachList);
		let str = "";
		//callback -> array반복시 요청됨
		$(attachList).each(function(i, attach) {
			console.log(i, attach.uuid, attach.filename, attach.filetype);
			//이미지일 경우, 썸네일 화면에 노출
			if(attach.filetype == 1) {
				//썸네일 이미지 경로
				let fileCallPath = encodeURIComponent(attach.uploadpath + "\\s_" + attach.uuid + "_" + attach.filename);
				str +="<li data-path='" + attach.uploadpath + "'";
				str +=" data-uuid='" + attach.uuid + "' data-filename='" + attach.filename + "' data-type='" + attach.filetype + "'>";
				str += " <div>";
				str += "  <span>" + attach.filename + "</span>";
				str += "   <img src='/display?filename=" + fileCallPath + "'/>";
				str += " </div>";
				str += "</li>";
			} else {
				//이미지가 아닌 경우
				str +="<li data-path='" + attach.uploadpath + "'";
				str +=" data-uuid='" + attach.uuid + "' data-filename='" + attach.filename + "' data-type='" + attach.filetype + "'>";
				str += " <div>";
				str += "  <span>" + attach.filename + "</span>";
				str += "  <img src='/resources/img/attach.png'/>";
				str += " </div>";
				str += "</li>";
			}
		});
		$(".uploadResult ul").html(str);
	});
	
	function showImage(fileCallPath) {
		$(".bigPictureWrapper").css("display", "flex").show();
		$(".bigPicture").html("<img src='/display?filename=" + fileCallPath + "'/>").animate({width:'100%', top:'0'}, 600);
	}
	$(".uploadResult").on("click", "li", function(e) {
		console.log("view image");
		let liObj = $(this);
		let path = encodeURIComponent("\\notice\\" + liObj.data("path") + "\\" + liObj.data("uuid") + "_" + liObj.data("filename"));
		if (liObj.data("type")) {
			showImage(path);
		} else {
			if (path.toLowerCase().endsWith('pdf')) {
				//new window
				window.open("/pdfviewer?filename=" + path);
			} else {
				//download
				self.location = "/downloadFile?filename=" + path;
			}
		}
	});
	$(".bigPictureWrapper").on("click", function(e) {
		$(".bigPictureWrapper").hide();
		$(".bigPicture").css("top", "15%");
	});
	
});
</script>
<body>

	<div class="board_title">
		<h3>공지사항</h3>
	</div>
	
	<div class="wrapper_read">
		<div class="wrapper_table">
		
			<table class="read_table">
	
					<tr>
						<th class="th_title">제목</th>
						<td class="td_title">${notice.title}</td>
					</tr>
					
					<tr>
						<th class="th_writer">작성자</th>
						<td class="td_writer">${notice.writer}</td>
					</tr>
					
					<tr>
						<th class="th_date">작성일</th>
						<td>
						<c:choose>
							<c:when test="${notice.regdate} == ${notice.updatedate}">
							<fmt:formatDate value="${notice.regdate}" pattern="YY-MM-dd hh:mm"/>
							</c:when>
							<c:otherwise>
							<fmt:formatDate value="${notice.updatedate}" pattern="YY-MM-dd hh:mm"/>
							</c:otherwise>
						</c:choose>
						</td>
					</tr>
			</table>
		</div>
		
		<div class="read_table_content">
			<textarea class="read_content" name="content" readonly="readonly">${notice.content}</textarea>
		</div>
		
		<div class="read_bottom">
			<button class="read_button" id="list_btn">목록</button>
			<c:if test="${auth.userid eq notice.writer}">
			<button class="read_button" id="modify_btn">수정</button>
			</c:if>
			<form id="operForm" action="/notice/noticeModify" method="get">
				<input type="hidden" id="bno" name="bno" value='<c:out value="${notice.bno}"/>'>
				<input type="hidden" name="pageNum" value='<c:out value="${criteria.pageNum}"/>'>
				<input type="hidden" name="amount" value='<c:out value="${criteria.amount}"/>'>
				<input type="hidden" name="type" value="<c:out value="${criteria.type}"/>"/>
				<input type="hidden" name="keyword" value="<c:out value="${criteria.keyword}"/>"/>
			</form>
		</div>
		
		
		<div class="article-bottom">
			<div class="field1 get-th field-style">
				<label><b>첨부파일</b></label>
			</div>
			
			<div class="field2 get-td">
				<div class="uploadResult">
					<ul class="file_list">
					
					</ul>
				</div>
			</div>
		</div>
		
		<div class="bigPictureWrapper">
	    	<div class="bigPicture"></div>
	    </div>
	    
	</div>
</body>

<%@include file="../includes/footer.jsp" %>