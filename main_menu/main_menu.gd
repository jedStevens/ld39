extends Node2D

func _on_credits_pressed():
	on_action()
	get_node("camera").set_lerp_target(get_node("credits").get_pos())
	get_node("moon_anim").play("hide")

func _ready():
	set_process(true)

func _process(delta):
	pass

func _on_back_pressed():
	on_action()
	get_node("camera").set_lerp_target(get_node("main_pos").get_pos())
	
	var moon_timer = mega.execute_in(1.6, get_node("moon_anim"), "play", ["show"])
	add_child(moon_timer)

func _on_play_pressed():
	on_action()

func on_action():
	get_node("sfx").play("hover")

func on_lead_out_completed():
	get_tree().change_scene("res://intro_cin/intro_cinematic.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_new_pressed():
	on_action()
	get_node("anim").play("lead_out")
