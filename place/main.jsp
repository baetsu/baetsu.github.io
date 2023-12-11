<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<link rel="stylesheet" href="/resources/css/image-picker.css">
<link rel="stylesheet" href="/resources/css/reservation.css">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="/resources/js/image-picker.js"></script>
<script src="/resources/js/image-picker.min.js"></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
<script>
	$(function() {
		let startStr;
		initFullCalendar();
		function initFullCalendar() {
	        let calendarEl = document.getElementById('calendar');
	        let calendar = new FullCalendar.Calendar(calendarEl, {
	          initialView: 'dayGridMonth',
	          selectable: true,
	          unselectAuto: false,
	          select: function(info) {
	        	  //console.log(info.startStr);
	        	  startStr = info.startStr;
	        	  $('#seatPicker').prop('selectedIndex', 0).trigger('change');
	          }
	        });
	        calendar.setOption('contentHeight', 450);
	        calendar.render();
			startStr = calendar.getDate().toISOString();
		}
		initPlaceNo();
		function initPlaceNo() {
			$.getJSON("/place/getPlaceNo/", function(data) {
				console.log(data);
				$(data).each(function(i, item) {
					let option = $("<option data-img-src='/resources/img/number_0" + (i+1) + ".png' value='" + (i+1) + "'></option>");
					$('#seatPicker').append(option);
				});
				$("select").imagepicker();
				$('#seatPicker').prop('selectedIndex', 0).trigger('change');
			});
		}
		
		function getTime() {
			//alert(startStr);
			const d = new Date(startStr);
			d.setHours(0);
			d.setMinutes(0);
			d.setSeconds(0);
			return d.getTime();
		}
		
		$("#seatPicker").on('change', function() {
			$.getJSON("/place/getResState/",
					{sno:$("#seatPicker").find(':selected').val(), resdate: getTime()}, function(data) {
				$("#seats").empty();
				console.log(data);
				console.log("${auth.userid}");
				$(data).each(function(i, item) {
					let input;
					if (item.userid === null) {
						input = $("<label class='box'><input type='checkbox' id=" + (i+1) + ">" + "[" + item.tno +
								".  " + item.duration + "시]" + "  ✔예약가능 </input><span class='checkmark'></span><label><br/>");
					} else {
						if ("${auth.userid}" === item.userid) {
							input = $("<label class='box'><input type='checkbox' disabled='disabled' id=" + (i+1) + ">" + "[" + item.tno +
									".  " + item.duration + "시]" + "  ❗예약중 </input><span class='checkmark'></span><label><br/>");
						} else {
							input = $("<label class='box'><input type='checkbox' disabled='disabled' id=" + (i+1) + ">" + "[" + item.tno +
									".  " + item.duration + "시]" + "  ❌예약불가 </input><span class='checkmark'></span><label><br/>");
						}
					}
					$("#seats").append(input);
				});
			});
		});
		
		$("#reservation").on('click', function(e) {
			let list = new Array();
			$("#seats input").each(function(i, item) {
				let inputObj = $(item);
				if (inputObj.is(':checked')) {
					//alert(startStr + " " + $("#seatPicker option:checked").val() + " " + inputObj.attr('id'));
					let obj = {userid:"${auth.userid}", sno:$("#seatPicker option:checked").val(),
							tno:inputObj.attr('id'), resdate:getTime()};
					list.push(obj);
				}
			});
			$.ajax({
				url:"/place/reservation/",
				data:JSON.stringify(list),
				dataType:'json',
				contentType: 'application/json',
				type:'post',
				success : function(result) {
					alert(result + "번 공간이 예약되었습니다.");
					$('#seatPicker').prop('selectedIndex', result-1).trigger('change');
				}
			});
		});
	});


</script>
<body>
	<div class="reservation_title">
		<h3>공원내 공간 예약</h3>
	</div>
	
	<div class="wrapper_main" style="display:flex; margin-top:5px;">
		<div id='calendar' style="width:50%;"></div>
		<div class="resConts" style="width:50%; margin-left:20px;">			
			<div class="pick_place" style="height:25%;">
				<h3>장소선택</h3>
				<select id="seatPicker" class="image-picker show-html"></select>
			</div>
			<h3>시간선택</h3>
			<div id="seats" style="height:65%;">
			</div>
			
			
			<div  class="btn_area" style="height:10%;">
				<button id="reservation" type="button">예약하기</button>
			</div>
		</div>
	</div>
</body>
</html>

<%@include file="../includes/footer.jsp"%>