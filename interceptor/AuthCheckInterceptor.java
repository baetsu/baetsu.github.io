package com.joongang.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

public class AuthCheckInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		//세션에서 auth 받아옴
		HttpSession session = request.getSession(false);
		if (session != null) {
			Object auth = session.getAttribute("auth");
			if (auth != null) {
				return true;
			}
		}
		String userURI = request.getRequestURI();
		String queryString = request.getQueryString();
		//userURI가 있는지 없는지 체크
		if (queryString != null && !queryString.isEmpty()) {
			userURI += "?" + queryString;
		}
		if (session != null) {
			session.setAttribute("userURI", userURI);
		}
		response.sendRedirect(request.getContextPath() + "/member/login");
		return false;
	}

}
