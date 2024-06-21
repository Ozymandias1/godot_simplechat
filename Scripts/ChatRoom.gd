# ChatRoom.gd 채팅방
extends Control

signal on_player_character_node_created(peer_id, node_instance)

const PLAYER_TEMPLATE = preload("res://Scenes/Player.tscn")

@onready var camera_2d = $Camera2D
@onready var in_game_menu_screen = $CanvasLayer/InGameMenuScreen

# 스크립트 시작
func _ready():
	MultiplayManager.player_connected.connect(_on_player_connected)
	on_player_character_node_created.connect(MultiplayManager.assign_player_character_node)

	# 서버일경우 player_connected가 emit되지 않으므로 수동 호출
	if multiplayer.is_server():
		_on_player_connected(1, MultiplayManager.my_player_data)

# 플레이어 접속시 호출되는 시그널
func _on_player_connected(peer_id, player_info):
	# 새 플레이어 생성후 이름과 스프라이트 설정
	var new_player = PLAYER_TEMPLATE.instantiate()
	new_player.name = str(peer_id)
	add_child(new_player)

	new_player.set_player_name_tag_text(player_info.Name)
	new_player.set_player_sprite(player_info.SpriteColor)

	on_player_character_node_created.emit(peer_id, new_player)

	# 파라미터의 피어값이 본인의 피어값과 같으면 카메라를 부착한다.
	if peer_id == multiplayer.get_unique_id():
		camera_2d.reparent(new_player, false)
		new_player.z_index = 1

# 핸들링 되지 않는 입력, Esc키가 눌리면 나가기 창을 표시한다
func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			in_game_menu_screen.visible = !in_game_menu_screen.visible
			
# 나가기 버튼 클릭 처리
func _on_btn_exit_pressed():
	MultiplayManager.close_multiplay()
	MultiplayManager.load_scene("res://Scenes/MainMenu.tscn")
