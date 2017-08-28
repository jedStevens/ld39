extends Node2D

var max_demon_hits = 40
var demon_hits = 0
var demon_hit_timer = 0
var demon_hit_delay = 2

var current_level = 0
var hits_needed_to_level_up = player.HITS_PER_LEVEL[0]
var max_level = player.HITS_PER_LEVEL.size()

func _ready():
	set_process(true)
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.KEY:
		if event.scancode == KEY_ESCAPE and event.pressed:
			get_tree().set_pause( !get_tree().is_paused() )

func _process(delta):
	demon_hit_timer -= delta
	get_node("level").set_frame(current_level)
	if hits_needed_to_level_up <= 0:
		current_level += 1
		if current_level >= max_level:
			get_node("../anim").play("win")
			set_process(false)
		else:
			hits_needed_to_level_up = player.HITS_PER_LEVEL[current_level]
			var difficulty_factor = 1 + current_level/3*1.65
			get_tree().call_group(0, "boss_anim", "set_speed", difficulty_factor)
	get_node("hits").set_skulls(hits_needed_to_level_up)

func tear():
	var new_tear = preload("res://demon/tear_1.tscn").instance()
	new_tear.set_pos(get_node("player").get_pos())
	add_child(new_tear)

func pillar_tear():
	if current_level > 0:
		var new_tear = preload("res://demon/tear_2.tscn").instance()
		new_tear.set_pos(Vector2(get_node("player").get_pos().x, 200-64))
		add_child(new_tear)

func _on_eye_area_R_body_enter( body ):
	if body.is_in_group("player_weapon"):
		hit_demon(body)
		body.queue_free()

func _on_eye_area_L_body_enter( body ):
	if body.is_in_group("player_weapon"):
		hit_demon(body)
		body.queue_free()

func hit_demon(cause=null):
	if demon_hit_timer <= 0:
		hits_needed_to_level_up -= player.damage
		demon_hits += 1
		get_node("intro_demon/sfx").play("pain")
		demon_hit_timer = demon_hit_delay
		get_node("intro_demon/anim").play("fade")
		var difficulty_factor = 1 + current_level/3*1.65 + (player.HITS_PER_LEVEL[current_level] - hits_needed_to_level_up) / float(player.HITS_PER_LEVEL[current_level]) * 0.05
		get_tree().call_group(0, "boss_anim", "set_speed", difficulty_factor)
		if cause != null:
			var blood = preload("res://demon/demon_blood.tscn").instance()
			blood.set_rot(randf() * 2 * PI)
			blood.set_pos(cause.get_pos())
			get_node("blood").add_child(blood)


func _on_bar_death():
	if not get_node("player").dead:
		get_node("player").kill()
		get_node("../anim").set_speed(1)
		get_node("../anim").play("death")
		get_node("music").stop()

func to_weapons():
	get_tree().change_scene("res://weapon_chooser/weapon_chooser.tscn")

func demon_eye(i=-1):
	if i == -1:
		i = int(randi() % get_node("close_eye_spawns").get_child_count())
	
	var new_eye = preload("res://demon/close_eye.tscn").instance()
	new_eye.set_pos(get_node("close_eye_spawns").get_child(i).get_pos())
	new_eye.connect("hit_demon", self, "hit_demon")
	add_child(new_eye)

func triple_eye():
	var picked_spawns = []
	for i in range(3):
		var spawn_node = int(randi() % get_node("close_eye_spawns").get_child_count())
		if picked_spawns.find(spawn_node) != -1:
			
			i -=1
			continue
		picked_spawns.append(spawn_node)
		demon_eye(spawn_node)

func win():
	get_tree().change_scene("res://win_screen/win_screen.tscn")
		