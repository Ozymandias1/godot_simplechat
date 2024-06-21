# Player.gd 플레이어 관련(이동, 메시지) 처리
extends Node2D

@export var move_speed: float = 100

@onready var name_tag = $NameTag
@onready var message_container = $MessageContainer
@onready var player_anim_sprite = $PlayerAnimSprite

var is_move_enabled : bool = true

# 노드 트리 추가시 호출
func _enter_tree():
	set_multiplayer_authority(name.to_int())

# 플레이어 이름표 텍스트 설정
func set_player_name_tag_text(player_name: String):
	name_tag.text = player_name

# 플레이어 이름 스프라이트 설정
func set_player_sprite(sprite_color: String):
	var sprite_path: String = "res://Data/Sprite_Player_%s.tres" % sprite_color
	player_anim_sprite.sprite_frames = load(sprite_path)

# 플레이어 캐릭터 위에 메시지 보여주기
func show_message(message: String):
	message_container.add_message(message)

# 업데이트
func _process(delta):
	if multiplayer.multiplayer_peer != null and is_multiplayer_authority(): # 권한이 있는 경우만 입력 처리를 수행
		process_player_movement(delta)
		process_player_animation()

# 플레이어 이동 처리
func process_player_movement(delta):
	if is_move_enabled:
		var horizontal_input = Input.get_axis("Move Left", "Move Right")
		var vertical_input = Input.get_axis("Move Up", "Move Down") # 아래쪽이 positive한 방향이므로
		self.position += Vector2(horizontal_input, vertical_input) * move_speed * delta

# 플레이어 애니메이션 처리
func process_player_animation():
	if is_move_enabled:
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
	else:
		player_anim_sprite.play("Idle")
