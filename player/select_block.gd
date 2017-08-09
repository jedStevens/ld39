extends Node2D

export(bool)var selected = false

var guide_size = 32

func set_selected(b):
	selected = b
	get_node("selected").set_hidden(!b)
	set_process(true)

func get_selected():
	return selected

func _process(delta):
	update()

func _draw():
	if selected:
		draw_line(Vector2(0,0), get_pos().normalized() * guide_size, Color(1,1,1,0.25), 2)