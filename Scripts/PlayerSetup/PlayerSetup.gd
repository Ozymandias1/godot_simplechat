# PlayerSetup.gd 플레이어 설정 스크립트
extends Control

@export var player_textures: Array[Texture] # 플레이어 이미지(인스펙터에서 설정)
var selected_tex : int = 0 # 선택된 스프라이트 이미지 인덱스

@onready var player_sprite = $Container/PlayerSprite
@onready var line_edit_nick_name = $Container/NicknameContainer/LineEditNickName

# 스크립트 시작
func _ready():
	player_sprite.texture = player_textures[selected_tex] # 시작시 인덱스에 해당하는 텍스쳐로 설정

# < 버튼 클릭 시그널
func _on_btn_left_pressed():
	selected_tex -= 1
	if selected_tex < 0:
		selected_tex = player_textures.size()-1
	player_sprite.texture = player_textures[selected_tex]

# > 버튼 클릭 시그널
func _on_btn_right_pressed():
	selected_tex += 1
	if selected_tex >= player_textures.size():
		selected_tex = 0
	player_sprite.texture = player_textures[selected_tex]

# 플레이어 정보 얻기
func get_player_info():
	# 플레이어 이름이 입력되지 않았다면 임의의 이름으로 설정한다.
	var player_name = line_edit_nick_name.text
	if player_name.is_empty():
		player_name = "사용자%d" % randi_range(1, 100)

	return {
		"name": player_name,
		"tex_index": selected_tex
	}

#func _on_line_edit_nick_name_text_submitted(new_text):
	#print(new_text)
	#if new_text.is_empty():
		#OS.alert("대화명을 입력해주십시오", "대화명 입력")
