extends Node2D

export(bool)var selected = false

func set_selected(b):
	selected = b
	get_node("selected").set_hidden(!b)

func get_selected():
	return selected