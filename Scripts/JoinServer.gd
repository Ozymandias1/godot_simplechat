extends Control

# 취소 버튼 클릭 시그널
func _on_btn_cancel_pressed():
	ServerBroadcaster.close_listener() # 리스너 닫고 씬 이동
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
