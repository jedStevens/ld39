extends Node2D 	

signal hit_demon

func _ready():
	set_process(true)
	set_scale(Vector2(1 if get_pos().x < 160 else -1, 1))

func _process(delta):
	for aoe in get_node("aoe").get_children():
		if aoe.is_monitoring_enabled():
			for body in  aoe.get_overlapping_bodies():
				print("WTF: ", body.get_name())
				if body.is_in_group("player_weapon"):
					queue_free()
					emit_signal("hit_demon")