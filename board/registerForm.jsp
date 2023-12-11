<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@include file="../includes/header.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 작성</title>
</head>
<link rel="stylesheet" href="/resources/css/register.css">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	$(function() {
		//해당 파일은 업로드x
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
			//제이쿼리형으로 데이터를 변환하고 each로 인해 값을 하나하나 가져오게 됨
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
					//이미지일 경우 rest방식(동적) 파일 썸네일을 보여줌
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
		//첨부파일 삭제
		$(".uploadResult").on("click", "li button", function(e) {
			console.log('deleteBtn click');
			let targetFile = $(this).data("file");
			let filetype = $(this).data("type");
			let targetLi = $(this).parent().closest("li");
			let attach = {
					fileName : targetFile,
					type : filetype
			};
			
			$.ajax({
				type : 'delete',
				url : '/deleteFile',
				data : JSON.stringify(attach),
				contentType : "application/json; charset=utf-8",
				success : function(result) {
					alert(result);
					targetLi.remove();
				}
			});
		});
		//글 등록 버튼 클릭
		$(".register_submit_button").on("click", function(e) {
			e.preventDefault();
			console.log('registerBtn click');
			let formObj = $(".register_form");
			let str = "";
			$(".uploadResult ul li").each(function(i, listItem) {
				let liObj = $(listItem);
				console.log("----------------------------------------");
				console.log(liObj.data("filename"));
				str += "<input type='hidden' name='attachList["+i+"].filename' value='" + liObj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uuid' value='" + liObj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uploadpath' value='" + liObj.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].filetype' value='" + liObj.data("type")+"'>";
			});
			console.log(str);
			formObj.append(str).submit();
		});
		
	});
</script>
<body>
	<div class="register_title">
		<h3>게시글 작성</h3>
	</div>
	
	<div class="wrapper_register">
		<div class="register_line"></div>
		<div class="register_body">
			<form class="register_form" method="post" action="/board/register">
				<table class="read_table">
					<tr>
						<th class="th_writer">작성자</th>
						<td class="td_writer">
							<input class="title_area" maxlength="50" readonly="readonly" name="writer" value="${auth.userid}"/>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<input class="title_area" maxlength="50" placeholder="제목을 입력해주세요." name="title" required="required"/>
						</td>
					</tr>
				</table>
				
				<div class="register_written"><textarea type="text" class="written_area" placeholder="내용을 입력해주세요." name="content" required="required"></textarea></div>
					
				<div class="register_submit">
					<button class="register_submit_button" type="submit">등록</button>
					<button type="reset">내용 삭제</button>
				</div>
			</form>
		</div>
		
		<div class="article-bottom">
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
		</div>
	</div>
</body>
</html>
<%@include file="../includes/footer.jsp" %>