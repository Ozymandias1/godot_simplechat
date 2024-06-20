# JoinServer.gd 서버 접속 화면 스크립트
extends Control

@onready var player_setup = $Container/SetupContainer/PlayerSetup
@onready var server_browser = $Container/SetupContainer/ServerBrowser

# 스크립트 시작
func _ready():
	# 스크립트 시작시(서버 접속 화면 시작시) 서버 브라우져씬에 생성될 join버튼의 클릭 시그널을 연결한다.
	server_browser.on_join_btn_pressed.connect(join_server)

# 취소 버튼 클릭 시그널
func _on_btn_cancel_pressed():
	ServerBroadcaster.close_listener() # 리스너 닫고 씬 이동
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

# 서버 입장 처리
func join_server(server_data: Dictionary):
	
	var player_info: Dictionary = player_setup.get_player_info()
	
	MultiplayManager.load_scene("res://Scenes/ChatRoom.tscn")
	MultiplayManager.join_chat_room(server_data, player_info)
