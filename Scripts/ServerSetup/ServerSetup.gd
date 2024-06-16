extends BoxContainer

@onready var line_edit_server_name = $Container/ServerNameContainer/LineEditServerName
@onready var line_edit_port = $Container/PortNumberContainer/LineEditPort

# 서버 정보 얻기
func get_server_info():
	var server_name = line_edit_server_name.text
	# 포트 번호가 입력되지 않으면 10000번으로 설정
	var port = int(line_edit_port.text)
	if line_edit_port.text.is_empty():
		port = 10000
	
	return {
		"RoomName": server_name,
		"Port": port
	}
