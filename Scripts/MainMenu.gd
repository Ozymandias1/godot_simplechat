# MainMenu.gd 메인메뉴 화면 처리 스크립트
extends Control

# 서버 생성 버튼 클릭 시그널
func _on_btn_create_server_pressed():
	get_tree().change_scene_to_file("res://Scenes/CreateServer.tscn")

# 서버 입장 버튼 클릭 시그널
func _on_btn_join_server_pressed():
	get_tree().change_scene_to_file("res://Scenes/JoinServer.tscn")

# 메인메뉴 Quit 버튼 클릭 시그널
func _on_btn_quit_pressed():
	get_tree().quit()
