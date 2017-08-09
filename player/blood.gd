extends Node2D

func _ready():
	set_process(true)
	emit_blood()

func _process(delta):
	if not (get_node("small_blood").is_emitting() or get_node("medium_blood").is_emitting()):
		queue_free()

func emit_blood():
	get_node("small_blood").set_emitting(true)
	get_node("medium_blood").set_emitting(true)