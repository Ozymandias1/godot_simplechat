# ChatRoom.gd 채팅방
extends Control

#@onready var player = $Player

signal on_player_character_node_created(peer_id, node_instance)

const PLAYER_TEMPLATE = preload("res://Scenes/Player.tscn")

@onready var camera_2d = $Camera2D

var test_messages: Array[String] = [
	"I am trying to make multiple death messages and I want them to be chosen at random, how can I do that?",
	"ahh",
	"youtube",
	"Something like this should get you started",
	"Hello! Looks like you’re enjoying the discussion, but you haven’t signed up for an account yet.",
	"다 팔아먹으려면 크로스 세이브 되는게 유리하겠죠 이 사람아...",
	"크로스 세이브는 왜 지원을 안하냐 ㅠㅠ",
	"그래...크로스플레이됐음됐다...",
	"크로스세이브 지원하려면 자체 플랫폼 운영해야 하고 DLC도 소액결제로 바꿔야 하는데 이정도면 라이브서비스 게임이죠.",
	"켜고 끌수 있는 거 넘좋구만. 핵쟁이들이랑은 같이 하기 싫었는데",
]

#func _on_test_timer_timeout():
	#player.show_message(test_messages.pick_random())
	
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
