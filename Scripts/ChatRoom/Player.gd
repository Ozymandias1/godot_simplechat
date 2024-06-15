extends Node2D

@export var move_speed: float = 100

@onready var message_container = $MessageContainer
@onready var player_anim_sprite = $PlayerAnimSprite

# 플레이어 캐릭터 위에 메시지 보여주기
func show_message(message: String):
	message_container.add_message(message)

# 업데이트
func _process(delta):
	var horizontal_input = Input.get_axis("Move Left", "Move Right")
	var vertical_input = Input.get_axis("Move Up", "Move Down") # 아래쪽이 positive한 방향이므로
	self.position += Vector2(horizontal_input, vertical_input) * move_speed * delta

	process_player_animation()

# 플레이어 애니메이션 처리
func process_player_animation():
	
	if Input.is_action_pressed("Move Right"):
		player_anim_sprite.play("Move")
		player_anim_sprite.flip_h = false
		
	elif Input.is_action_pressed("Move Left"):
		player_anim_sprite.play("Move")
		player_anim_sprite.flip_h = true
		
	elif Input.is_action_pressed("Move Up"):
		player_anim_sprite.play("Move")
		player_anim_sprite.flip_h = false
		
	elif Input.is_action_pressed("Move Down"):
		player_anim_sprite.play("Move")
		player_anim_sprite.flip_h = true
		
	else:
		player_anim_sprite.play("Idle")