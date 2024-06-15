extends Control

@onready var player = $Player

var test_messages: Array[String] = [
	"I am trying to make multiple death messages and I want them to be chosen at random, how can I do that?",
	"ahh",
	"youtube",
	"Something like this should get you started",
	"Hello! Looks like you’re enjoying the discussion, but you haven’t signed up for an account yet.",
	"다 팔아먹으려면 크로스 세이브 되는게 유리하겠죠 이 사람아...",
	"크로스 세이브는 왜 지원을 안하냐 ㅠㅠ",
	"그래...크로스플레이됐음됐다...",
	"크로스세이브 지원하려면 자체 플랫폼 운영해야 하고 DLC도 소액결제로 바꿔야 하는데 이정도면 라이브서비스 게임이죠.",
	"켜고 끌수 있는 거 넘좋구만. 핵쟁이들이랑은 같이 하기 싫었는데",
]

func _on_test_timer_timeout():
	player.show_message(test_messages.pick_random())
