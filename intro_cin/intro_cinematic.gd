extends Node2D

func on_completed():
	get_tree().change_scene("res://weapon_chooser/weapon_chooser.tscn")
	
func _on_skip_cin_pressed():
	on_completed()
