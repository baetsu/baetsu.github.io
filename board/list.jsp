<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/header.jsp"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 목록</title>
<link rel="stylesheet" href="/resources/css/boardList.css">
</head>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	$(function() {
		$(".write_btn").on('click', function(e) {
			self.location = "/board/register";
		});
		
		let result = '<c:out value="${result}"/>';
		checkModal(result);
		history.replaceState({}, null, null);
		function checkModal(result) {
			if (result === '' || history.state) {
				return;
			}
			if (parseInt(result) > 0) {
				result = parseInt(result) + " 번 글이 등록되었습니다.";
			} else {
				result = "처리가 완료 되었습니다.";
			}
			alert(result);
		}
		
		$(".get").on('click', function(e) {
			e.preventDefault();
			
			//form 동적생성
			let form = $('<form></form>');
			let type = $('select[name=type]').val();
			let keyword = $('input[name=keyword]').val();
			form.attr("method", "get");
			form.attr("action", "/board/get");
			form.append("<input type='hidden' name='bno' value='" + $(this).attr("href") + "'>");
			form.append("<input type='hidden' name='pageNum' value='" + <c:out value="${pageDTO.criteria.pageNum}"/> + "'>");
			form.append("<input type='hidden' name='amount' value='" + <c:out value="${pageDTO.criteria.amount}"/> + "'>");
			form.append("<input type='hidden' name='type' value='" + type + "'>");
			form.append("<input type='hidden' name='keyword' value='" + keyword + "'>");
			form.appendTo('body');
			form.submit();
		});
		
		$(".paginate_button a").on('click', function(e) {
			e.preventDefault();
			let form = $('<form></form>');
			let type = $('select[name=type]').val();
			let keyword = $('input[name=keyword]').val();
			form.attr("method", "get");
			form.attr("action", "/board/list");
			form.append("<input type='hidden' name='pageNum' value='" + $(this).attr("href") + "'>");
			form.append("<input type='hidden' name='amount' value='" + <c:out value="${pageDTO.criteria.amount}"/> + "'>");
			form.append("<input type='hidden' name='type' value='" + type + "'>");
			form.append("<input type='hidden' name='keyword' value='" + keyword + "'>");
			form.appendTo('body');
			form.submit();
		});
		
		//replyCount
		let list = new Array();
		//list라는 키값으로 오브젝트가 넘어옴
		//bno를 array에 넣어주기
		<c:forEach items="${list}" var="board">
			list.push(<c:out value="${board.bno}"/>);
		</c:forEach>
		console.log("list: " + list);
		//url뒤에 전달할 데이터 기입
		$.getJSON("/replies/cnt", {list:list}, function(data) {
			let keys = Object.keys(data);
			$(keys).each(function(i, bno) {
				let replyCnt = data[bno];
				let text = $("a[name=" + bno + "]").text().trim() + "[" + replyCnt + "]";
				$("a[name=" + bno + "]").text(text);
			});				
		});
		
		//attachListOnList
		if (list.length == 0) {
			return;
		}
        $.getJSON("/board/getAttachListOnList", {list:list}, function(data) {
        	console.log(data);
        	let html = "";
        	//내림차순정렬 (100, 99, ...)
         	let keys = Object.keys(data).sort((a, b) => Number(b)-Number(a));
        	$(keys).each(function(i, bno) {
        		let attach = data[bno];
        		console.log(bno);
        		if (attach.length == 0) {
        			return;
        		}
        		if (attach[0] != null ) {
        			if(attach[0].filetype) {
        				let fileCallPath = encodeURIComponent(attach[0].uploadpath + "\\s_" + attach[0].uuid + "_" + attach[0].filename);
        				html = "<img src='/display?filename=" + fileCallPath + "'>";
        			} else {
        				html = "<img src='/resources/img/attach.png'>";
        			}
        			$("#" + bno).html(html);
        		}
        	});
        });
        //검색 내용 없을 경우 경고창 출력
		let searchForm = $("#searchForm");
		$("#searchForm button").on("click", function(e) {
			if (!searchForm.find("option:selected").val()) {
				alert("검색종류를 선택하세요.");
				return false;
			}
			if (!searchForm.find("input[name='keyword']").val()) {
				alert("키워드를 입력하세요.");
				return false;
			}
			searchForm.find("input[name='pageNum']").val("1");
			e.preventDefault();
			searchForm.submit();
		});
	});
</script>
<body>

    <div class="board_title">
        <h3>게시판</h3>
    </div>
    
    
    <div class="wrapper_board">
		<div class="wrapper_table">
			<table class="board_table">
				<thead>
					<tr>
						<th class="th_num">글 번호</th>
						<th class="th_title">글 제목</th>
						<th class="th_writer">작성자</th>
						<th>첨부파일</th>
						<th class="th_date">작성일자</th>
					</tr>
				</thead>
				
				<tbody>
					<c:forEach var="board" items="${list}">
						<tr align="center">
							<td><c:out value="${board.bno}"/></td>
							<th>
								<a class="get" href='<c:out value="${board.bno}"/>' name='<c:out value="${board.bno}"/>'>
									<c:out value="${board.title}"/>
								</a>
							</th>
							<td><c:out value="${board.writer}"/></td>
							<td id='<c:out value="${board.bno}"/>'></td>
							<td>
								<c:choose>
									<c:when test="${board.regdate} == ${board.updatedate}">
										<fmt:formatDate pattern="YY-MM-dd hh:mm" value="${board.regdate}"/>
									</c:when>
									<c:otherwise>
										<fmt:formatDate pattern="YY-MM-dd hh:mm" value="${board.updatedate}"/>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			
			
	
	
			<div class="board_bottom">
				<button class="write_btn" id="write_btn">글쓰기</button>
			</div>

			<!-- page -->
			<div class="board_page">
				<ul class="pagination">
					<c:if test="${pageDTO.prev}">
						<li class="paginate_button previous">
							<a href="${pageDTO.startPage-1}">Prev</a>
						</li>
					</c:if>
					<c:forEach var="num" begin="${pageDTO.startPage}" end="${pageDTO.endPage}">
						<li class="paginate_button ${pageDTO.criteria.pageNum==num ? 'active_list' : '' }">
							<a href="${num}">${num}</a>
						</li>
					</c:forEach>
					<c:if test="${pageDTO.next}">
						<li class="paginate_button next">
							<a href="${pageDTO.endPage+1}">Next</a>
						</li>
					</c:if>
				</ul>
			</div>
			<!-- page -->
			
			<div class="searchform">
				<form action="/board/list" id="searchForm">
					<select name="type" class="select-style">
						<option value="" <c:out value="${pageDTO.criteria.type == null ? 'selected' : ''}"/>>선택</option>
						<option value="T" <c:out value="${pageDTO.criteria.type eq 'T' ? 'selected' : ''}"/>>제목</option>
						<option value="C" <c:out value="${pageDTO.criteria.type eq 'C' ? 'selected' : ''}"/>>내용</option>
						<option value="W" <c:out value="${pageDTO.criteria.type eq 'W' ? 'selected' : ''}"/>>작성자</option>
						<option value="TC" <c:out value="${pageDTO.criteria.type eq 'TC' ? 'selected' : ''}"/>>제목 or 내용</option>
						<option value="TW" <c:out value="${pageDTO.criteria.type eq 'TW' ? 'selected' : ''}"/>>제목 or 작성자</option>
						<option value="TWC" <c:out value="${pageDTO.criteria.type eq 'TWC' ? 'selected' : ''}"/>>제목 or 내용 or 작성자</option>
					</select>
					<input type="text" class="select-style" name="keyword" placeholder="검색어를 입력해주세요" value="<c:out value="${pageDTO.criteria.keyword}"/>"/>
					<input type="hidden" name="pageNum" value="<c:out value="${pageDTO.criteria.pageNum}"/>"/>
					<input type="hidden" name="amount" value="<c:out value="${pageDTO.criteria.amount}"/>"/>
					<button class="search_btn">검색</button>
				</form>
			</div>
		</div>
	</div>
	
</body>
</html>

<%@include file="../includes/footer.jsp" %>