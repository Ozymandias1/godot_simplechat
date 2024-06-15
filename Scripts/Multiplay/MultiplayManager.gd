# MultiplayManager.gd 멀티플레이(채팅)의 서버-클라이언트 처리 스크립트
extends Node

signal player_connected(peer_id, player_info)

# 접속한 모든 플레이어에 대한 정보(본인 포함)
var connected_players = {}

# 나의 정보
var my_player_data = {
	"Name": "Player", # 이름
	"SpriteID": 0 # 선택한 플레이어 스프라이트 이미지 인덱스
}

# 스크립트 시작
func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)

# 피어 접속시 호출되는 콜백 시그널
func _on_peer_connected(peer_id):
	# 접속한 플레이어의 peer_id를 기준으로 플레이어 등록하는 함수를 모든 피어에서 호출
	_add_player.rpc_id(peer_id, my_player_data)
	
# 피어 접속시 호출되는 플레이어 등록함수로 모든 피어에서 호출
@rpc("any_peer", "reliable")
func _add_player(player_info):
	var peer_id = multiplayer.get_remote_sender_id()
	connected_players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)
