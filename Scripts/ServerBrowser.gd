# ServerBrowser.gd 서버 브라우져 스크립트
extends Control

signal on_join_btn_pressed(server_data)

const SERVER_BROWSER_ITEM = preload("res://Scenes/ServerBrowserItem.tscn")
@onready var btn_refresh = $VBoxContainer/BtnRefresh
@onready var container = $VBoxContainer/Container

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
	if ip.is_empty() == false: # ip주소가 유효한 값으로 넘오오지 않는 경우가 있으므로 확인후 처리
		var node_name_key: String = ip.replace(".", "_") # ip를 그대로 사용시 노드이름에 .은 허용되지 않으므로 _로 치환하여 처리
		if container.has_node(node_name_key) == false:
			var new_server_item = SERVER_BROWSER_ITEM.instantiate()
			new_server_item.name = node_name_key
			container.add_child(new_server_item)
			
			new_server_item.set_item_text(server_info.RoomName, ip, server_info.Port)
			# 씬 트리구조상 플레이어 데이터 설정을 위해 버튼 눌림 시그널 처리를 한곳(JoinServer.gd)에서 처리한다.
			new_server_item.btn_join.pressed.connect(_btn_join_pressed.bind(new_server_item.call("get_server_info")))

# 접속 버튼 클릭 처리
func _btn_join_pressed(server_data):
	# 입장 버튼 클릭시 연결된 시그널에 서버데이터를 보내서 실제 입장 처리는 그곳에서 한다.
	on_join_btn_pressed.emit(server_data)
