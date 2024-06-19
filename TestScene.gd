extends Node2D

@onready var label = $Label
@onready var label_long = $LabelLong
@onready var v_box_container = $Control/ScrollContainer/VBoxContainer
@onready var scroll_container = $Control/ScrollContainer

var labels : Array[Label]

func _ready():
	labels = [label, label_long]
	scroll_container.get_v_scroll_bar().changed.connect(_on_scroll_changed)

func _on_button_pressed():
	var item = labels.pick_random().duplicate()
	v_box_container.add_child(item)
	_check_max_item_count()

func _on_scroll_changed():
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value

func _check_max_item_count():
	var count = v_box_container.get_child_count()
	if count > 3:
		v_box_container.get_child(0).queue_free()
