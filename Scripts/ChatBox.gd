# ChatRoom.gd 채팅로그, 메시지 입력처리등
extends Control

const CHAT_BOX_MESSAGE_ITEM = preload("res://Scenes/ChatBoxMessageItem.tscn")

@onready var line_edit_input_message = $Container/Controls/LineEditInputMessage
@onready var chat_log = $Container/ScrollContainerChatLog/ChatLog
@onready var scroll_container_chat_log = $Container/ScrollContainerChatLog

@export var max_chatlog_item : int = 50

# 스크립트 시작
func _ready():
	MultiplayManager.player_connected.connect(_on_player_connected)
	MultiplayManager.player_disconnected.connect(_on_player_disconnected)

	# 메시지가 입력되면 스크롤컨테이너의 스크롤 값을 조정해주기 위한 시그널 연결
	scroll_container_chat_log.get_v_scroll_bar().changed.connect(_on_chatlog_v_scroll_changed)

# 채팅로그에 메시지 텍스트 항목 추가
@rpc("any_peer", "reliable", "call_local")
func _add_message_to_chatlog(message_text: String, is_player_message: bool = false):
	var msg_item = CHAT_BOX_MESSAGE_ITEM.instantiate()
	msg_item.text = message_text
	chat_log.add_child(msg_item)

	_remove_oldest_chatlog_message()

	# 플레이어가 입력한 메시지일경우 rpc를 호출한 피어id값에 해당하는 캐릭터위 메시지를 표시한다.
	if is_player_message:
		var peer_id = multiplayer.get_remote_sender_id()
		MultiplayManager.connected_players[peer_id]["PlayerNodeInstance"].show_message(message_text)

# 전송 버튼 클릭 시그널
func _on_btn_send_pressed():
	_on_line_edit_input_message_text_submitted(line_edit_input_message.text)

# 채팅로그 스크롤 컨테이너의 스크롤변화 이벤트 이그널
func _on_chatlog_v_scroll_changed():
	# 채팅로그는 밑에서 위로 올라가는 방식이므로, 메시지가 추가되면 스크롤값을 최대값인 아래로 내려준다
	scroll_container_chat_log.scroll_vertical = scroll_container_chat_log.get_v_scroll_bar().max_value

# 채팅로그가 일정 개수 이상 되었을때 처리하는 함수
func _remove_oldest_chatlog_message():
	var chatlog_item_count = chat_log.get_child_count()
	if chatlog_item_count > max_chatlog_item:
		chat_log.get_child(0).queue_free() # 트리구조상 0번째것이 제일 오래된 채팅로그이므로

# 플레이어 접속시 처리
func _on_player_connected(_peer_id, player_info):
	var message_text = "%s님이 접속하였습니다." % player_info.Name
	_add_message_to_chatlog(message_text)

# 텍스트 입력 완료 처리 시그널
func _on_line_edit_input_message_text_submitted(new_text):
	if line_edit_input_message.text.is_empty() == false:
		var message_text = "%s:%s" % [MultiplayManager.my_player_data.Name, new_text]
		_add_message_to_chatlog.rpc(message_text, true)

		line_edit_input_message.text = ""
		line_edit_input_message.release_focus()

# 텍스트 입력 컨트롤 포커스 들어왔을때 처리
func _on_line_edit_input_message_focus_entered():
	var player_self = MultiplayManager.my_player_data["PlayerNodeInstance"]
	player_self.is_move_enabled = false
	
# 텍스트 입력 컨트롤 포커스 잃었을때의 처리
func _on_line_edit_input_message_focus_exited():
	var player_self = MultiplayManager.my_player_data["PlayerNodeInstance"]
	player_self.is_move_enabled = true

# 핸들링 되지 않은 입력 처리
func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.pressed and (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER):
			line_edit_input_message.grab_focus() # 엔터키가 눌리면 메시지 텍스트 입력창에 포커스

			# 메시지 입력중에는 플레이어 캐릭터의 이동을 막는다.
			var player_self = MultiplayManager.my_player_data["PlayerNodeInstance"]
			player_self.is_move_enabled = false

# 플레이어 접속 해제시 처리
func _on_player_disconnected(_peer_id, player_info):
	var message_text = "%s님이 나갔습니다." % player_info.Name
	_add_message_to_chatlog(message_text)
