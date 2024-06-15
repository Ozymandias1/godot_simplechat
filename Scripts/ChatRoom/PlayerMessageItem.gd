# PlayerMessageItem.gd 플레이어 메시지 아이템 스크립트
extends CenterContainer

@onready var message_label = $MessageLabel

var message_text: String = ""

# 스크립트 시작
func _ready():
	
	# 스크립트 시작시 지정된 메시지 텍스트를 Label에 설정하고 스케일을 0으로 지정한다.
	message_label.text = message_text
	self.scale = Vector2.ZERO
	
	# 플레이어 메시지 아이템은 tween을 사용하여 간단한 애니메이션을 적용한 보이기/숨기기 동작을 수행
	var show_tween: Tween = create_tween()
	show_tween.set_ease(Tween.EASE_IN_OUT)
	show_tween.set_trans(Tween.TRANS_ELASTIC)
	show_tween.tween_property(self, "scale", Vector2.ONE, 0.25) # 0.25초동안 트윈 진행	
	show_tween.finished.connect(_on_show_animation_finished) # 보이기 트윈 진행후 완료되면 호출될 함수 시그널 연결

# 보이기 트윈 완료 후 호출되는 함수
func _on_show_animation_finished():
	# 1.0초간 기다렸다가 숨기기 트윈을 진행한다.
	await get_tree().create_timer(1.0).timeout
	
	# 숨기기 트윈
	var hide_tween: Tween = create_tween()
	hide_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.25)
	hide_tween.finished.connect(_on_hide_animation_finished)

# 숨기기 트윈 완료 후 호출되는 함수
func _on_hide_animation_finished():
	self.queue_free() # 숨기기가 완료되면 제거
