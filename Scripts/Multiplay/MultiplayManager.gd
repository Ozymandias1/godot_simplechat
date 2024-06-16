# MultiplayManager.gd 멀티플레이(채팅)의 서버-클라이언트 처리 스크립트
extends Node

signal player_connected(peer_id, player_info)

# 접속한 모든 플레이어에 대한 정보(본인 포함)
var connected_players = {}

# 나의 정보
var my_player_data = {
	"Name": "Player", # 이름
	"SpriteColor": "Beige" # 선택한 플레이어 스프라이트 이미지 인덱스
}

# 스크립트 시작
func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)

# 씬 로드 함수
@rpc("call_local", "reliable")
func load_scene(scene_path):
	get_tree().change_scene_to_file(scene_path)

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

# 대화방 생성
func create_chat_room(player_info: Dictionary, server_info: Dictionary, max_player_count: int):
	# 멀티플레이 피어 생성후 지정된 포트와 최대 접속자수를 이용해 서버를 생성한다.
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(server_info.Port, max_player_count)
	if error:
		printerr(error)
		return error
	# 멀티플레이어 피어 설정
	multiplayer.multiplayer_peer = peer
	
	# 내 플레이어 데이터 설정 및 플레이어 연결 시그널 발동
	my_player_data["Name"] = player_info["Name"]
	my_player_data["SpriteColor"] = player_info["SpriteColor"]
	connected_players[1] = my_player_data	
	player_connected.emit(1, my_player_data)
	# 서버 프라우져 브로드 캐스트 시작
	# server_info ↓
	#return {
		#"RoomName": server_name,
		#"Port": port
	#}
