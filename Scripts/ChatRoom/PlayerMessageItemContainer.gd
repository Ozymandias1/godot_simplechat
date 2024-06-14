# PlayerMessageItemContainer.gd 플레이어 메시지 아이템 컨테이너 스크립트
extends Control

const PLAYER_MESSAGE_ITEM = preload("res://Scenes/ChatRoom/PlayerMessageItem.tscn")

# 컨테이너에 메시지 항목 추가
func add_message(message: String):
	var new_msg_item = PLAYER_MESSAGE_ITEM.instantiate()
	new_msg_item.message_text = message
	new_msg_item.position = Vector2.ZERO	
	add_child(new_msg_item)
	adjust_message_position()

# 컨테이너 내의 자식 객체들(메시지) 위치 조정
func adjust_message_position():
	var child_count = self.get_child_count()
	for i in range(child_count):
		var child = self.get_child(i)
		child.position.y = (child_count - i) * -37
