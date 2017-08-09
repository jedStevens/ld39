tool
extends Node2D

func _on_credits_pressed():
	on_action()
	get_node("panel").set_current_tab(1)

func _ready():
	set_process(true)
		

func _process(delta):
	get_node("panel").set_size(get_viewport_rect().size*get_node("camera").get_zoom())

func _on_back_pressed():
	on_action()
	get_node("panel").set_current_tab(0)

func _on_play_pressed():
	on_action()
	get_node("anim").play("lead_out")

func on_action():
	get_node("sfx").play("hover")

func on_lead_out_completed():
	get_tree().change_scene("res://intro_cin/intro_cinematic.tscn")