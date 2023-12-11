<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@include file="../includes/header.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet" href="/resources/css/login.css">
</head>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	$(function() {
		$(".login_button").on('click', function(e) {
			console.log('click test');
			e.preventDefault();
			if(isValid()) {
				$("form").submit();
			}
		});
		
		function isValid() {
			console.log('test');
			let user_id = $("#userid").val();
			let user_pw = $("#userpw").val();
			
			$("#error_msg").text("");
			
			if(user_id == "") {
				$("#error_msg").text("이메일을 입력해주세요.");
				$("#userid").focus();
				return false;
			}
			if(user_pw == "") {
				$("#error_msg").text("비밀번호를 입력해주세요.");
				$("#userpw").focus();
				return false;
			}
			return true;
		}
		let error = "${error}";
		console.log(error);
		if(error === "") {
			return;
		}
		if (error === "nonuser") {
			$("#userid").focus();
		} else {
			$("#userpw").focus();
		}
		let msg = (error === "nonuser") ? "존재하지 않는 Email입니다." : "비밀번호가 일치하지 않습니다.";
		alert(msg);
		
	});
</script>
<body>
    <div class="login_title">
        <h3>로그인</h3>
    </div>
    
	<div class="wrapper_login">
		<div class="login_form">
		<form action="/member/login" class="login_form" method="post">

			<div class="form_field">
				<label for="username">E-mail</label>
				<input type="email" class="id_control" id="userid" name="userid"
				placeholder="E-mail을 입력하세요" value="${memberVO.userid}"/>
			</div>
			
			<div class="form_field">
				<label for="password">비밀번호</label>
				<input type="password" class="pw_control" id="userpw" name="userpw"
				placeholder="비밀번호를 입력하세요"/>
			</div>
			
			<div id="error_msg" class="error">
	        </div>
	        
	        <div class="goto_register">
                <a href="/member/signup">아직 회원이 아니신가요?</a>
            </div>

            <div class="login_button">
                <input type="submit" value="로그인">
            </div>
		</form>
		</div>
	</div>
</body>
</html>
<%@include file="../includes/footer.jsp" %>
