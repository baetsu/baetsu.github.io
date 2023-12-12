<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>서울숲공원 홈페이지</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap');
</style>
<link rel="stylesheet" href="/resources/css/header.css">
</head>
<body>


	<div class="wrapper_head">
        <div class="wrapper_title">
            <img src="/resources/img/웹 로고.png" class="logo_img">
        </div>
        <div class="header_contents">
            <div class="wrapper_sub">
            	<ul class="sns_list">
            		<li>
		                <a href="https://blog.naver.com/seoul_parks_official" target="blank"><img src="/resources/img/sns_icon1.png" class="sns_icon"></a>
            		</li>
            		<li>
                		<a href="https://www.instagram.com/seoulforestpark/" target="blank"><img src="/resources/img/sns_icon2.png" class="sns_icon"></a>
            		</li>
            		<li>
		                <a href="https://www.youtube.com/@Seoulforest" target="blank"><img src="/resources/img/sns_icon3.png" class="sns_icon"></a>
            		</li>
            		
            		<c:choose>
	                <c:when test="${!empty auth}">
	                	<li>	                	
					<span class="user_login">
						<strong><c:out value="${auth.username}"/></strong>
						님, 환영합니다!
					</span>
				</li>
				<li>
                        		<a href="/member/logout" class="user_logout"><span>로그아웃</span></a>
                    		</li>
			</c:when>
			<c:otherwise>
				<li>
		                        <a href="/member/login" class="user_logout">
		                            <span>로그인</span>
	                        </a>
                    		</li>
                    		<li>
		                        <a href="/member/signup" class="user_logout">
		                            <span>회원가입</span>
	                        </a>
                    		</li>
			</c:otherwise>
			</c:choose>
            	</ul>
                

            </div>
            <nav class="wrapper_menu">
                <ul class="menu_list">
                    <li>
                        <a href="/">
                            <span class="menu_item">홈</span>
                        </a>
                    </li>
                    <li>
                        <a href="/board/list">
                            <span class="menu_item">자유게시판</span>
                        </a>
                    </li>
                    <li>
                        <a href="/notice/noticeList">
                            <span class="menu_item">공지사항</span>
                        </a>
                    </li>
                    <li>
                        <a href="https://parks.seoul.go.kr/parks/detailView.do?pIdx=5#target03" target="blank">
                            <span class="menu_item">공원안내</span>
                        </a>
                    </li>
                    
                    <c:choose>
                    <c:when  test="${!empty auth}">
						<li>
							<a href="/place/main">
		                    	<span class="menu_item">공간대관</span>
		                    </a>
		                </li>                
                    </c:when>
                    <c:otherwise>
                    	<li>
                    		<a href="https://parks.seoul.go.kr/ecoinfo/ecology/wild.do">
                    			<span class="menu_item">생태정보</span>
                    		</a>
                    	</li>
                    </c:otherwise>
					</c:choose>
                </ul>
            </nav>
        </div>
    </div>
    
    
</body>
</html>
