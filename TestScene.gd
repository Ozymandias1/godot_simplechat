extends Node2D

@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween: Tween = create_tween()
	tween.tween_property(player, "position", Vector2(1000, player.position.y), 5.0)
	tween.finished.connect(_on_move_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("ui_up"):
		var tween: Tween = create_tween()
		tween.tween_property(player, "scale", Vector2(2,2), 10.0)

func _on_move_finished():
	player.queue_free()
