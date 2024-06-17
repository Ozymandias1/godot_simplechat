# ServerBrowser.gd 서버 브라우져 스크립트
extends Control

const SERVER_BROWSER_ITEM = preload("res://Scenes/ServerBrowserItem.tscn")
@onready var btn_refresh = $VBoxContainer/BtnRefresh

# 스크립트 시작
func _ready():
	# 서버 브라우저 리스너 콜백 시그널 연결
	ServerBroadcaster.get_server_info_finished.connect(_on_get_server_info_finished)
	ServerBroadcaster.server_detected.connect(_on_server_detected)

# 새로고침 버튼 클릭 시그널
func _on_btn_refresh_pressed():
	btn_refresh.disabled = true
	ServerBroadcaster.start_get_server_info()

# 새로고침 완료 시그널
func _on_get_server_info_finished():
	btn_refresh.disabled = false

# 서버가 탐지되었을 경우
func _on_server_detected(ip: String, server_info: Dictionary):
	if ip.is_empty():
		printerr("유효하지 않은 정보")
	print(ip, ",", server_info)
