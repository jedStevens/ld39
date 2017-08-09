extends Node2D



func _on_back_pressed():
	get_node("AnimationPlayer").play("fade_out")

func end():
	get_tree().change_scene("res://main_menu/main_menu.tscn")