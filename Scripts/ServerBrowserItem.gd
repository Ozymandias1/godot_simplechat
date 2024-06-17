# ServerBrowserItem.gd 서버 브라우져 아이템 스크립트
extends HBoxContainer

@onready var label_room_name = $LabelRoomName
@onready var label_ip_address = $LabelIpAddress
@onready var label_port = $LabelPort
@onready var btn_join = $BtnJoin

# 방제목, ip주소, 포트번호 텍스트 설정
func set_item_text(room_name: String, ip: String, port: String):
	label_room_name.text = room_name
	label_ip_address.text = ip
	label_port.text = port

# 시그널 연결을 위한 버튼 얻기
func get_join_button():
	return btn_join

# 서버 정보 얻기
func get_server_info():
	return {
		"RoomName": label_room_name.text,
		"IP": label_ip_address.text,
		"Port": int(label_port.text)
	}
