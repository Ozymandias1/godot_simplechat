# CreateServer.gd 서버 설정 스크립트
extends Control

# 취소 버튼 클릭 시그널
func _on_btn_cancel_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")
