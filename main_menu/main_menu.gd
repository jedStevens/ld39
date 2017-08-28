extends Node2D

# Root Manager
var _next_scn = null
export(PackedScene) var cinematic
#export(PackedScene) var save_n_load

export(NodePath) var continue_button

func _on_credits_pressed():
	on_action()
	get_node("camera").set_lerp_target(get_node("credits").get_pos())
	get_node("moon_anim").play("hide")

func _ready():
	OS.set_window_size(Vector2(960,600))
	set_process(true)
	
	if save_manager.get_saves("saves") == []:
		get_node(continue_button).set_disabled(true)

func _process(delta):
	pass

func _on_back_pressed():
	on_action()
	get_node("camera").set_lerp_target(get_node("main_pos").get_pos())
	
	var moon_timer = mega.execute_in(1.6, get_node("moon_anim"), "play", ["show"])
	add_child(moon_timer)

func _on_play_pressed():
	on_action()
	get_node("anim").play("lead_out")
	#_next_scn = save_n_load
	

func on_action():
	get_node("sfx").play("hover")
	

func on_lead_out_completed():
	get_tree().change_scene_to(_next_scn)

func _on_quit_pressed():
	get_tree().quit()

func _on_new_pressed():
	on_action()
	get_node("anim").play("lead_out")
	_next_scn = cinematic

func _on_fullscreen_pressed():
	OS.set_window_fullscreen(not OS.is_window_fullscreen())