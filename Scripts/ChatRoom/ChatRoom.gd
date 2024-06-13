extends Control

@onready var message_dialog = $Player/MessageDialog
@onready var label = $Player/MessageDialog/BoxContainer/Label
@onready var box_container = $Player/MessageDialog/BoxContainer


var messages: Array[String] = [
	"I am trying to make multiple death messages and I want them to be chosen at random, how can I do that?",
	"ahh",
	"youtube",
	"Something like this should get you started",
	"Hello! Looks like you’re enjoying the discussion, but you haven’t signed up for an account yet."
]

func _on_test_timer_timeout():
	label.text = messages.pick_random()
	box_container.size = Vector2.ZERO
	message_dialog.size = box_container.size
