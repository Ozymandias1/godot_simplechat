# ServerBroadcaster.gd 서버 브로드캐스터, 서버 브라우져에서 서버정보 보내기/얻기를 위한 스크립트
# Autoload를 사용하여 전역으로 사용한다.
extends Node

signal get_server_info_finished
signal server_detected(ip, server_info)

var broadcaster: PacketPeerUDP
var broadcast_bind_port: int = 15000

var broadcast_listener: PacketPeerUDP
var broadcast_listen_port: int = 15001

#region 서버 정보 방송
# 주어진 ip주소를 브로드캐스트 ip주소로 변환한다.
func get_broadcast_address(server_ip: String):
	var ip_split = server_ip.split(".")
	return "%s.%s.%s.255" % [ip_split[0], ip_split[1], ip_split[2]]

# 내 서버정보 방송 시작
func start_broadcast_my_server_info(server_ip: String, server_info: Dictionary):
	# 브로드캐스터를 생성하고 연결된 네트워크상의 장비들에게
	# 나의 서버정보 방송을 위해 끝자리 주소를 255로 설정한다.
	broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)
	var broadcast_server_ip = get_broadcast_address(server_ip)
	broadcaster.set_dest_address(broadcast_server_ip, broadcast_listen_port)

	var is_succeeded = broadcaster.bind(broadcast_bind_port) # 브로드캐스트로 바인딩
	if is_succeeded == OK:
		# 지정한 포트로 브로드캐스터 바인딩이 성공하면
		# 1초간격으로 서버 정보 방송을 위해 타이머를 생성하여 처리한다.
		var broadcast_timer: Timer = Timer.new()
		broadcast_timer.timeout.connect(_on_timeout_broadcast_my_server_info.bind(server_info))
		broadcast_timer.wait_time = 1.0
		broadcast_timer.autostart = true
		broadcast_timer.one_shot = false
		add_child(broadcast_timer)
	else:
		printerr("브로드캐스터 바인딩 실패")

# 내 서버 정보 방송 타이머 콜백
func _on_timeout_broadcast_my_server_info(server_info: Dictionary):
	# 서버 정보를 utf8 버퍼로 변환하여 패킷으로 처리
	var broadcast_data: String = JSON.stringify(server_info)
	var broadcast_packet: PackedByteArray = broadcast_data.to_utf8_buffer()
	broadcaster.put_packet(broadcast_packet)
#endregion

#region 서버 정보 얻기
func start_get_server_info():
	close_listener()
	broadcast_listener = PacketPeerUDP.new()
	var is_succeeded = broadcast_listener.bind(broadcast_listen_port) # 리슨포트로 바인딩
	if is_succeeded == OK:
		# 리슨포트로 바인딩이 성공하면 타이머를 생성하여 5초동안 연결된 네트워크상에 생성된 서버정보를 얻는다.
		var listener_timer: Timer = Timer.new()
		listener_timer.timeout.connect(_on_timeout_listening_server_info)
		listener_timer.wait_time = 5.0
		listener_timer.autostart = true
		listener_timer.one_shot = true
		add_child(listener_timer)
	else:
		printerr("리스너 바인딩 실패")

# 리스너 닫기
func close_listener():
	if broadcast_listener != null:
		broadcast_listener.close()
		broadcast_listener = null

# 서버 정보 얻는 리스너 타이머 아웃 콜백
func _on_timeout_listening_server_info():
	close_listener()
	get_server_info_finished.emit()

# 스크립트 업데이트
func _process(_delta):
	# 매 프레임마다 리스너가 유효하면 가져올 서버 정보가 있는지 체크하여 처리한다.
	if broadcast_listener and broadcast_listener.get_available_packet_count() > 0:
		var server_ip: String = broadcast_listener.get_packet_ip()
		var _port: int = broadcast_listener.get_packet_port()
		var data_bytes: PackedByteArray = broadcast_listener.get_packet()
		var data: String = data_bytes.get_string_from_utf8()
		var server_info: Dictionary = JSON.parse_string(data)
		server_detected.emit(server_ip, server_info)
#endregion
