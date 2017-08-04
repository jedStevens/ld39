extends Node2D

func emit_blood():
	get_node("small_blood").set_emitting(true)
	get_node("medium_blood").set_emitting(true)