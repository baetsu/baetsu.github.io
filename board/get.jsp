<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/header.jsp"%>
<script src="/resources/js/replyService.js"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="/resources/css/get.css">
<script>
	$(function() {
		const operForm = $("#operForm");
		$("#list_btn").on('click', function(e) {
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list");
			operForm.submit();
		});
		$("#modify_btn").on('click', function(e) {
			operForm.attr("action", "/board/modify").submit();
		});
		$("#addReplyBtn").on('click', function() {
			$("#reply").val("");
			$("#modalModBtn").hide();
			$("#modalRegisterBtn").show();
			$("#modalCloseBtn").show();
			$(".modal").modal("show");
		});
		$("#modalCloseBtn").on('click', function() {
			$(".modal").modal("hide");
		});
		$("#modalRegisterBtn").on('click', function() {
			let reply = {
					reply : $("#reply").val(),
					replyer : $("#replyer").val(),
					bno : '<c:out value="${vo.bno}"/>'
			};
			ReplyService.add(reply,
				function(result) {
					alert(result);
					$(".modal").modal("hide");
					getReplyListWithPaging(pageNum);
				},
				function (error) {
					alert(error);
			});
		});
		
		getReplyList();
		function getReplyList() {
			ReplyService.getList(
					{bno: '<c:out value="${vo.bno}"/>'},
					function(list) {
						console.log("list: " + list);
						showReplyList(list);
					},
					function(error) {
						alert(error);
					});
		}
		
		function showReplyList(list) {
			let str = "";
			let replyUL = $(".reply_list");
			if(list == null || list.length == 0) {
				replyUL.html(str);
				return;
			}
			
			for(let i=0, len = list.length || 0; i<len; i++) {
				str +="<li>";
				str +=" <div>";
				str +="  <div class='header'><strong class='primary-font'>"+list[i].replyer+"</strong>";
				str +="   <small class='pull-right text-muted'>"+ReplyService.displyTime(list[i].regdate)+"</small>";
				str +="  </div>";
				str +="  <div data-rno='"+list[i].rno+"' data-replyer='"+list[i].replyer+"'>";
				str +="   <strong id='modify' class='primary-font'>"+list[i].reply+"</strong>";
				if("${auth.userid}"===list[i].replyer) {
				str +="   <button id='remove' type='button' class='close' data-rno='"+list[i].rno+"'>";
				str +="    <span>x</span></button>";
				}
				str +="  </div>";
				str +=" </div>";
				str +="</li>";
			}
			replyUL.html(str);
		}
		//수정
		$(".reply_list").on("click", " li #modify", function(e) {
			console.log("modify test...");
			let replyer = $(this).parent().closest('div').data("replyer");
			let rno = $(this).parent().closest('div').data("rno");
			let auth = "${auth.userid}";
			if(auth !== replyer) {
				return;
			}
			//alert('modify' + auth + ' ' + replyer + ' ' + rno);
			ReplyService.get(rno, function(reply) {
				console.log('get test...');
				$("#reply").val(reply.reply);
				$("#replyer").val(reply.replyer);
				$(".modal").data("rno", reply.rno);
				$("#modalModBtn").show();
				$("#modalRegisterBtn").hide();
				$(".modal").modal("show");
			});
		});
		//수정확인
		$("#modalModBtn").on("click", function() {
			console.log('btn click');
			let reply = {
					rno : $(".modal").data("rno"),
					reply : $("#reply").val(),
			};
			ReplyService.update(reply, function(result) {
				console.log('update test...');
				alert(result);
				$(".modal").modal('hide');
				//수정 완료시 다시 댓글 목록 출력
				getReplyListWithPaging(pageNum);
			}, function(error) {
				alert(error);
			});
			
		});
		
		//삭제
		$(".reply_list").on("click", "li #remove", function(e) {
			console.log('deleteBtn test');
			let rno = $(this).parent().closest('div').data("rno");
			alert('remove ' + rno);
			ReplyService.remove(rno, function(result) {
				alert(result);
				//삭제 후 다시 댓글목록 화면으로 이동
				getReplyListWithPaging(pageNum);
			}, function(error) {
				alert(error);
			});
		});
		//댓글 페이지
		let pageNum = 1;
		let replyPageFooter = $(".panel-footer");
		
		getReplyListWithPaging(pageNum);
		function getReplyListWithPaging(pageNum) {
			ReplyService.getListWithPaging(
					{bno:'<c:out value="${vo.bno}"/>', page: pageNum},
					function(replyCnt, list) {
						console.log("list: " + list);
						showReplyList(list);
						showReplyPaging(replyCnt);
					},
					function (error) {
						alert(error);
					});
		}
		function showReplyPaging(replyCnt) {
			let endNum = Math.ceil(pageNum / 10.0) * 10;
			let startNum = endNum - 9;
			let prev = startNum != 1;
			let next = false;
			let str = "";
			if (endNum * 10 >= replyCnt) {
				endNum = Math.ceil(replyCnt/10.0);
			}
			if (endNum * 10 < replyCnt) {
				next = true;
			}
			str += "<ul class='pagination'>";
			if (prev) {
				str += "<li class='paginate_button'><a href='"+(startNum-1)+"'>Previous</a></li>";
			}
			for (let i = startNum ; i <= endNum; i++) {
				let active = pageNum == i? "active_list":"";
				str += "<li class='paginate_button "+active+" '><a href='"+i+"'>"+i+"</a></li>";
			}
			if (next) {
				str += "<li class='paginate_button'><a href='"+(endNum + 1)+"'>Next</a></li>";
			}
			str += "</ul></div>";
			console.log(str);
			replyPageFooter.html(str);
		}
		//paging
		replyPageFooter.on("click", "li a", function(e) {
			e.preventDefault();
			console.log("page click");
			let targetPageNum = $(this).attr("href");
			console.log("targetPageNum: " + targetPageNum);
			pageNum = targetPageNum;
			getReplyListWithPaging(pageNum);
		});
		
		//첨부파일 출력
		//bno번호
		let bno = '<c:out value="${vo.bno}"/>';
		$.getJSON("/board/getAttachList/" + bno, function(attachList) {
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
			let path = encodeURIComponent(liObj.data("path") + "\\" + liObj.data("uuid") + "_" + liObj.data("filename"));
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
		<h3>게시판</h3>
	</div>
	
	<div class="wrapper_read">
		<div class="wrapper_table">
		
			<table class="read_table">
	
					<tr>
						<th class="th_title">제목</th>
						<td class="td_title">${vo.title}</td>
					</tr>
					
					<tr>
						<th class="th_writer">작성자</th>
						<td class="td_writer">${vo.writer}</td>
					</tr>
					
					<tr>
						<th class="th_date">작성일</th>
						<td>
						<c:choose>
							<c:when test="${vo.regdate} == ${vo.updatedate}">
							<fmt:formatDate value="${vo.regdate}" pattern="YY-MM-dd hh:mm"/>
							</c:when>
							<c:otherwise>
							<fmt:formatDate value="${vo.updatedate}" pattern="YY-MM-dd hh:mm"/>
							</c:otherwise>
						</c:choose>
						</td>
					</tr>
			</table>
		</div>
		
		<div class="read_table_content">
			<textarea class="read_content" name="content" readonly="readonly">${vo.content}</textarea>
		</div>
		
		<div class="read_bottom">
			<button class="read_button" id="list_btn">목록</button>
			<c:if test="${auth.userid eq vo.writer}">
			<button class="read_button" id="modify_btn">수정</button>
			</c:if>
			<form id="operForm" action="/board/modify" method="get">
				<input type="hidden" id="bno" name="bno" value='<c:out value="${vo.bno}"/>'>
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
		
		
		
		<div class="reply_title">
			<h4>댓글 목록</h4>
		</div>
		
		<div class="reply_wrapper">
			<ul class="reply_list">
			
			
			</ul>
			<div class="panel-footer"></div>
		</div>
		
		<!-- Modal -->
    	<div class="modal fade" tabindex="-1" role="dialog">
    		<div class="modal-dialog">
    			<div class="modal-content">
    				<div class="modal-header">
    					<h4 class="modal-title">REPLY MODAL</h4>
    					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
    						<span aria-hidden="true">&times;</span>
   						</button>
   					</div>
					<div class="modal-body">
	   					<div class="form-group">
	   						<label>Reply</label>
	   						<input class="form-control" id='reply' name='reply'>
						</div>
						<div class="form-group">
							<label>Replyer</label> 
							<input class="form-control" id='replyer' name='replyer' value="${auth.userid}" readonly="readonly">
						</div>
					</div>
					<div class="modal-footer">
						<button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
				        <button id='modalRegisterBtn' type="button" class="btn btn-primary">Register</button>
				        <button id='modalCloseBtn' type="button" class="btn btn-info">Close</button>
		        	</div>
	        	</div>
	        <!-- /.modal-content -->
        	</div>
        <!-- /.modal-dialog -->
    	</div>
    <!-- /.modal -->
    
	    <div class="bigPictureWrapper">
	    	<div class="bigPicture"></div>
	    </div>
	    
		<div class="reply_btn">
			<c:if test="${not empty auth}">
			<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>댓글 작성</button>
			</c:if>
		</div>
	</div>
</body>

<%@include file="../includes/footer.jsp" %>