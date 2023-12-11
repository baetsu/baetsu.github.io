<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/header.jsp"%>

<link rel="stylesheet" href="/resources/css/modify.css">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">
	$(function() {
		let formObj = $("form");
		$('button').on('click', function(e) {
			e.preventDefault();
			let operation = $(this).data("oper");
			console.log(operation);
			
			if(operation === 'remove') {
				formObj.attr("action", "/board/remove");
			} else if(operation === 'list') {
				let pageNumTag = $("input[name='pageNum']").clone();
				let amountTag = $("input[name='amount']").clone();
				let typeTag = $("input[name='type']").clone();
				let keywordTag = $("input[name='keyword']").clone();
				formObj.empty();
				formObj.attr("action", "/board/list").attr("method", "get");
				formObj.append(pageNumTag);
				formObj.append(amountTag);
				formObj.append(typeTag);
				formObj.append(keywordTag);
			} else if (operation === 'modify') {
				console.log('modify');
				let str = "";
				$(".uploadResult ul li").each(function(i, listItem) {
					let liObj = $(listItem);
					console.log("--------------------------");
					console.log(liObj.data("filename"));
					str += "<input type='hidden' name='attachList["+i+"].filename' value='" + liObj.data("filename")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].uuid' value='" + liObj.data("uuid")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].uploadpath' value='" + liObj.data("path")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].filetype' value='" + liObj.data("type")+"'>";
				});
				console.log(str);
				formObj.append(str).submit();
			}
			formObj.submit();
		});
		
		//attchList
		let bno = '<c:out value="${vo.bno}"/>';
		$.getJSON("/board/getAttachList/" + bno, function(attachList) {
			console.log("attachList: " + attachList);
			let str = "";
			$(attachList).each(function(i, attach) {
				console.log(i, attach.filename, attach.filetype);
				let fileCallPath = encodeURIComponent(attach.uploadpath + "\\s_" + attach.uuid + "_" + attach.filename);
				if (attach.filetype == 1) {
					//img
					str +="<li data-path='" + attach.uploadpath + "'";
					str +=" data-uuid='" + attach.uuid + "' data-filename='" + attach.filename + "' data-type='" + attach.filetype + "'>";
					str += " <div>";
					str += "  <span>" + attach.filename + "</span>";
					
					str += "  <button type='button' data-file=\'" + fileCallPath + "\'"
					str += "   data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i>X</button><br>";
					
					str += "   <img src='/display?filename=" + fileCallPath + "'/>";
					str += " </div>";
					str += "</li>";
				} else {
					//not img
					str +="<li data-path='" + attach.uploadpath + "'";
					str +=" data-uuid='" + attach.uuid + "' data-filename='" + attach.filename + "' data-type='" + attach.filetype + "'>";
					str += " <div>";
					str += "  <span>" + attach.filename + "</span>";
					
					str += "  <button type='button' data-file=\'" + fileCallPath + "\'"
					str += "   data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i>X</button><br>";
					
					str += "  <img src='/resources/img/attach.png'/>";
					str += " </div>";
					str += "</li>";
				}
			});
			$(".uploadResult ul").html(str);
		});
		
		//첨부파일 삭제버튼
		$(".uploadResult").on("click", "button", function(e) {
			console.log('delete click');
			if (confirm("Remove this file? " )) {
				let targetLi = $(this).closest("li");
				targetLi.remove();
			}
		});
		//첨부파일 선택(변경)
		let regex = new RegExp("(.*)\.(exe|zip|alz)$");
		let maxSize = 5*1024*1024;
		function checkExtension(filename, fileSize) {
			if (fileSize >= maxSize) {
				alert("파일 사이즈 초과");
				return false;
			}
			if (regex.test(filename)) {
				alert("해당 종류의 파일은 업로드할 수 없습니다.");
				return false;
			}
			return true;
		}
		$("#uploadFile").on("change", function(e) {
			let formData = new FormData();
			let inputFile = $("#uploadFile");
			let files = inputFile[0].files;
			for (let i=0; i<files.length; i++) {
				if (!checkExtension(files[i].name, files[i].size)) {
					return false;
				}
				formData.append("uploadFile", files[i]);
			}
			$.ajax({
				type : 'post',
				url : '/uploadFileAjax',
				processData : false,
				contentType : false,
				data : formData,
				success : function(result) {
					console.log("result: " + result);
					showUploadResult(result);
				}
			});
		});
		
		function showUploadResult(result) {
			if(!result || result.length == 0) { return; }
			let uploadUL = $(".uploadResult ul");
			let str = "";
			$(result).each( function (i, obj) {
				console.log(result);
				if (obj.image) {
					let fileCallPath = encodeURIComponent(obj.uploadpath + "\\s_" + obj.uuid + "_" + obj.filename);
					str +="<li data-path='" + obj.uploadpath + "'";
					str +=" data-uuid='" + obj.uuid + "' data-filename='" + obj.filename + "' data-type='" + obj.image + "'>";
					str +="  <div>";
					str +="   <span> " + obj.filename + "</span>";
					str +="   <button type='button' data-file=\'" + fileCallPath + "\'"
					str +="     data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i>X</button><br>";
					str +="   <img src='/display?filename=" + fileCallPath + "'/>";
					str +="  </div>";
					str +="</li>";
				} else {
					let fileCallPath = encodeURIComponent(obj.uploadpath + "\\" + obj.uuid + "_" + obj.filename);
					str +="<li data-path='" + obj.uploadpath + "'";
					str +=" data-uuid='" + obj.uuid + "' data-filename='" + obj.filename + "' data-type='" + obj.image + "'>";
					str +="  <div>";
					str +="   <span> " + obj.filename + "</span>";
					str +="   <button type='button' data-file=\'" + fileCallPath + "\'"
					str +="     data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i>X</button><br>";
					str +="   <img src='/resources/img/attach.png'/>";
					str +="  </div>";
					str +="</li>";
				}
			});
			uploadUL.append(str);
		}
	});
</script>
<body>
	<div class="modify_title">
		<h3>게시글 수정</h3>
	</div>
	
	<div class="wrapper_modify">
		<div class="read_line"></div>
		
		<form action="/board/modify" method="post">
		<input type="hidden" name="pageNum" value='<c:out value="${criteria.pageNum}"/>'>
		<input type="hidden" name="amount" value='<c:out value="${criteria.amount}"/>'>
		<input type="hidden" name="type" value="<c:out value="${criteria.type}"/>"/>
		<input type="hidden" name="keyword" value="<c:out value="${criteria.keyword}"/>"/>
			<table class="read_table">
				<thead>
					<tr>
						<th class="th_num">번호</th>
						<td class="td_num"><input class="form_control" name="bno"
							value='<c:out value="${vo.bno}"/>' readonly="readonly"></td>
					</tr>
					
					<tr>
						<th class="th_title">제목</th>
						<td class="td_title"><input class="form_control" name="title"
							value='<c:out value="${vo.title}"/>'></td>
					</tr>
					
					<tr>
						<th class="th_writer">작성자</th>
						<td class="td_writer"><input class="form_control" name="writer"
							value='<c:out value="${vo.writer}"/>' readonly="readonly"></td>
					</tr>
					
					<tr>
						<th class="th_date">작성일</th>
						<td><input class="form_control" name="regDate"
							value='<fmt:formatDate value="${vo.regdate}" pattern="yyyy-MM-dd"/>' readonly="readonly"></td>
					</tr>
				</thead>
			</table>
			
			
			<div class="read_table_content">
				<textarea class="read_content" name="content"><c:out value="${vo.content}"/></textarea>
			</div>
			
			<div class="field1 get-th field-style">
				<label><b>첨부파일</b></label>
			</div>
			<div class="field2 get-td">
				<input type="file" name="uploadFile" id="uploadFile" class="file-input" multiple/>
			</div>
			
			
			<div class="uploadResult">
				<ul class="file_list">
				</ul>
			</div>
			
			<div class="btn_list">
				<c:if test="${auth.userid eq vo.writer}">
					<button type="submit" data-oper="modify" class="read_button">수정 완료</button>
					<button type="submit" data-oper="remove" class="read_button">글 삭제</button>
				</c:if>
				<button type="submit" data-oper="list" class="read_button">글 목록</button>
			</div>
		</form>
	</div>
</body>


<%@include file="../includes/footer.jsp" %>