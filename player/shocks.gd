extends Node2D

signal hit_demon

var dead = false

func _ready():
	set_process(true)

func _process(delta):
	if not dead:
		for area in get_node("aoe").get_children():
				if area.is_monitoring_enabled():
					for body in area.get_overlapping_areas():
						if body.is_in_group("demon"):
							emit_signal("hit_demon")
							dead =true





func _on_anim_finished():
	queue_free()
