<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<style>
.container {
	width: 500px;
}

#list {
	height: 300px;
	padding: 15px;
	overflow: auto;
}
</style>
<body>
	<div class="container">
		<h1 class="page-header">Chat</h1>		
		
		<table class="table table-bordered">
			<tr>
				<td><input type="text" name="user" id="user" class="form-control" placeholder="유저명"></td>
				<td>
					<button type="button" class="btn btn-default" id="btnConnect">연결</button>
					<button type="button" class="btn btn-default" id="btnDisconnect" disabled>종료</button>
				</td>
			</tr>
			<tr>
				<td colspan="2"><div id="list"></div></td>
			</tr>
			<tr>
				<td colspan="2"><input type="text" name="msg" id="msg" placeholder="대화 내용을 입력하세요." class="form-control" disabled></td>
			</tr>
		</table>
	</div>
</body>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script type="text/javascript">
//채팅 서버 주소
let url = "ws://localhost/chatserver";
   		
// 웹 소켓
let ws;

// 연결하기
$('#btnConnect').click(function() {

	// 유저명 확인
   	if ($('#user').val().trim() != '') {
   		// 연결
	   	ws = new WebSocket(url);
	   			
	   	// 소켓 이벤트 매핑
	   	ws.onopen = function (evt) {
	   		// console.log('서버 연결 성공');
	   		print($('#user').val(), '입장했습니다.');
	   				
	   		// 현재 사용자가 입장했다고 서버에게 통지(유저명 전달)
	   		// -> 1#유저명
			ws.send('1#' + $('#user').val() + '#');
					
			$('#user').attr('readonly', true);
			$('#btnConnect').attr('disabled', true);
			$('#btnDisconnect').attr('disabled', false);
			$('#msg').attr('disabled', false);
			$('#msg').focus();
		};
        
		ws.onmessage = function (evt) {
			var index = evt.data.indexOf("#");
			var endindex = evt.data.indexOf(":");
			var no = evt.data.substring(0, 1); 
			var user = evt.data.substring(index+1, endindex);
			var txt = evt.data.substring(endindex + 1);
	   				
			if (no == '1') {
				var index = evt.data.indexOf("#", 2);
				var no = evt.data.substring(0, 1); 
				var user = evt.data.substring(2, index);
				var txt = evt.data.substring(index + 1);
				print2(user);
			} else if (no == '2') {
				print(user, txt);
			} else if (no == '3') {
				var index = evt.data.indexOf("#", 2);
				var no = evt.data.substring(0, 1); 
				var user = evt.data.substring(2, index);
				var txt = evt.data.substring(index + 1);
				print3(user);
			}
			$('#list').scrollTop($('#list').prop('scrollHeight'));
		};
	   			
		ws.onclose = function (evt) {
			console.log('소켓이 닫힙니다.');
		};

		ws.onerror = function (evt) {
			console.log(evt.data);
		};
	} else {
		alert('유저명을 입력하세요.');
		$('#user').focus();
	}
});

// 메세지 전송 및 아이디
function print(user, txt) {
	let temp = '';
	temp += '<div style="margin-bottom:3px;">';
	temp += '[' + user + '] ';
	temp += txt;
	temp += ' <span style="font-size:11px;color:#777;">' + new Date().toLocaleTimeString() + '</span>';
	temp += '</div>';
			
	$('#list').append(temp);
}
		
// 다른 client 접속		
function print2(user) {
	let temp = '';
	temp += '<div style="margin-bottom:3px;">';
	temp += "'" + user + "' 이(가) 접속했습니다." ;
	temp += ' <span style="font-size:11px;color:#777;">' + new Date().toLocaleTimeString() + '</span>';
	temp += '</div>';
			
	$('#list').append(temp);
}

// client 접속 종료
function print3(user) {
	let temp = '';
	temp += '<div style="margin-bottom:3px;">';
	temp += "'" + user + "' 이(가) 종료했습니다." ;
	temp += ' <span style="font-size:11px;color:#777;">' + new Date().toLocaleTimeString() + '</span>';
	temp += '</div>';
			
	$('#list').append(temp);
}

// DB 연동
function data(user, txt) {
	
	var data = {
			chatWriter : user,
			chatContent : txt
		};
		
		$.ajax({
			type: "post",
			url: "/chat/data.do",
			data: JSON.stringify(data),
			contentType: "application/json; charset=utf-8",
			success: function(res){
				console.log(res.txt);
			}
		});
}

$('#user').keydown(function() {
	if (event.keyCode == 13) {
		$('#btnConnect').click();
	}
});
		
		
		
$('#msg').keydown(function() {
	if (event.keyCode == 13) {
		
		//서버에게 메시지 전달
		//2#유저명#메시지
		ws.send('2#' + $('#user').val() + '#' + $(this).val()); //서버에게
		print($('#user').val(), $(this).val()); //본인 대화창에
		
		// DB 전송
		data($('#user').val(), $(this).val());
		
        $('#msg').val('');
		$('#msg').focus();
		
	}
});
		
$('#btnDisconnect').click(function() {
	ws.send('3#' + $('#user').val() + '#');
	ws.close();
			
	$('#user').attr('readonly', false);
    $('#user').val('');
			
	$('#btnConnect').attr('disabled', false);
	$('#btnDisconnect').attr('disabled', true);
			
	$('#msg').val('');
	$('#msg').attr('disabled', true);
});
</script>
</html>
