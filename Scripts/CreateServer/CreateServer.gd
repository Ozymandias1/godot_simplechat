# CreateServer.gd 서버 설정 스크립트
extends Control

@onready var player_setup = $Container/SetupContainer/PlayerSetup
@onready var server_setup = $Container/SetupContainer/ServerSetup

# 생성 버튼 클릭 시그널
func _on_btn_create_pressed():
	var player_info: Dictionary = player_setup.get_player_info()
	var server_info: Dictionary = server_setup.get_server_info()
	# 서버이름의 경우 빈 문자열이면 플레이어 이름을 사용해 임의의 명칭으로 설정
	if server_info.name.is_empty():
		server_info.name = "%s의 서버" % player_info.name
		
	print(player_info)
	print(server_info)
	
# 취소 버튼 클릭 시그널
func _on_btn_cancel_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")
