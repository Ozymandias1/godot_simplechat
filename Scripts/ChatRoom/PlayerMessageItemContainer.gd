# PlayerMessageItemContainer.gd 플레이어 메시지 아이템 컨테이너 스크립트
extends Control

const PLAYER_MESSAGE_ITEM = preload("res://Scenes/ChatRoom/PlayerMessageItem.tscn")

# 컨테이너에 메시지 항목 추가
func add_message(message: String):
	var new_msg_item = PLAYER_MESSAGE_ITEM.instantiate()
	new_msg_item.message_text = message
	#new_msg_item.position = Vector2.ZERO
	add_child(new_msg_item)
	adjust_message_position()

# 컨테이너 내의 자식 객체들(메시지) 위치 조정
func adjust_message_position():
	# 새로 추가된 메시지는 트리구조상 마지막에 위치하므로 마지막을 제외한 나머지를 이동
	var child_count = self.get_child_count()
	for i in range(0, child_count - 1):
		var child = self.get_child(i)
		var target_pos = Vector2(child.size.x * -0.5, (child_count - i) * -37 + 25)
		var tween: Tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(child, "position", target_pos, 0.25)
