extends KinematicBody2D

export(NodePath) var power_bar

export(PackedScene) var select_block_scn
export(int) var number_of_blocks = 24
export(int) var block_distance = 24

export(bool) var double_jump = false
var has_double_jump = false

var jump_height = 165

var move_speed = 175
var block_chain = [] #selection blocks

var next_sword_is_block = false # next sword is in block mode

var velocity = Vector2(0,0)

var dead = false

var takes_input = true

var jump_cooldown = 0.5
var jump_timer = 0

var invul = false
var invul_cooldown = 0.15
var invul_timer = 0

var last_damage = 0
var recent_damage = 0


var sword_power_cost = 10

export(ColorRamp) var invul_colors

signal on_selection(chain)

func _ready():
	create_selection_blocks()
	set_process(true)
	player.body = self

func _process(delta):
	## Movement
	if jump_timer > 0:
		jump_timer -= delta
	if invul_timer > 0:
		invul_timer -= delta
		recent_damage = last_damage * (invul_timer/invul_cooldown)
		get_node("skin").set_modulate(invul_colors.interpolate(invul_timer/invul_cooldown))
	else:
		get_node("skin").set_modulate(Color(1,1,1,1))
	
	var move_input = Vector2(0,0)
	velocity.y += delta * player.GRAVITY
	
	if Input.is_key_pressed(KEY_A):
		move_input.x -= 1
	if Input.is_key_pressed(KEY_D):
		move_input.x += 1
	if Input.is_key_pressed(KEY_W) and jump_timer <= 0:
		move_input.y += 1
		jump_timer = jump_cooldown
		
	if Input.is_key_pressed(KEY_S):
		move_input.y -= 0.25
	
	if !can_jump() and move_input.y > 0:
		move_input.y = 0
	
	velocity = Vector2(move_input.x * move_speed, velocity.y - move_input.y * (jump_height))
	
	
	
	if takes_input:
		var motion = move(velocity * delta)
		if (is_colliding()):
			var n = get_collision_normal()
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			move(motion)
		
	var flip = (move_input.x < 0)
	if flip:
		if !get_node("skin").is_flipped_h():
			get_node("skin").set_flip_h(true)
	elif move_input.x > 0:
		get_node("skin").set_flip_h(false)
	
	if move_input.x != 0:
		if get_node("anim").get_current_animation() != "move":
			get_node("anim").play("move")
	else:
		if get_node("anim").get_current_animation() != "idle" and not dead:
			get_node("anim").play("idle")
		elif get_node("anim").get_current_animation() != "death" and dead:
			get_node("anim").play("death")
	## Attacks
	
	if player.weapon == player.SWORD:
		var block = str(int(get_snapped_degree_angle(rad2deg(get_local_mouse_pos().angle()), 30)))
		if not Input.is_mouse_button_pressed(BUTTON_LEFT) and not Input.is_mouse_button_pressed(BUTTON_RIGHT):
			if block_chain.size() >0:
				for i in range(number_of_blocks):
					get_node("blocks/"+str(i*30)).set_selected(false)
				emit_signal("on_selection", block_chain)
				block_chain = []
			else:
				for i in range(number_of_blocks):
					get_node("blocks/"+str(i*30)).set_selected(false)
				get_node("blocks/"+block).set_selected(true)
				
		else:
			if Input.is_mouse_button_pressed(BUTTON_RIGHT):
				next_sword_is_block = true
			
			get_node("blocks/"+block).set_selected(true)
			
			if block_chain.find(int(block)) == -1:
				block_chain.append(int(block))
	
	if player.weapon == player.ARROW:
		var block = str(int(get_snapped_degree_angle(rad2deg(get_local_mouse_pos().angle()), 15)))
		
		if not Input.is_mouse_button_pressed(BUTTON_LEFT):
			if block_chain.size() >0:
				for i in range(number_of_blocks):
					get_node("blocks/"+str(i*15)).set_selected(false)
				emit_signal("on_selection", block_chain)
				block_chain = []
			else:
				for i in range(number_of_blocks):
					get_node("blocks/"+str(i*15)).set_selected(false)
				get_node("blocks/"+block).set_selected(true)
				
		elif get_node(power_bar).current_charge<=0:
			get_node(power_bar).charge(16,2)
		else:
			if block_chain.find(int(block)) == -1:
				block_chain.append(int(block))
			get_node("blocks/"+block).set_selected(true)
	
	if player.weapon == player.STAFF:
		var block = str(int(get_snapped_degree_angle(rad2deg(get_local_mouse_pos().angle()), 45)))
		
		if not Input.is_mouse_button_pressed(BUTTON_LEFT):
			if block_chain.size() >0:
				for i in range(number_of_blocks):
					get_node("blocks/"+str(i*45)).set_selected(false)
				emit_signal("on_selection", block_chain)
				block_chain = []
			
			for i in range(number_of_blocks):
				get_node("blocks/"+str(i*45)).set_selected(false)
			get_node("blocks/"+block).set_selected(true)
				
		else:
			if block_chain.find(int(block)) == -1:
				block_chain = [int(block)]
	
	if get_power() / get_node(power_bar).max_val < 0.25:
		if not get_node("low_hp_sfx").is_active():
			get_node("low_hp_sfx").play("low_hp")
	else:
		get_node("low_hp_sfx").stop_all()

func get_power():
	return get_node(power_bar).value
	
	
func create_selection_blocks():
	if player.weapon == player.SWORD or player.weapon == player.ARROW:
		if player.weapon == player.SWORD:
			number_of_blocks /= 2
		var degree_interval = 360.0/number_of_blocks
		for i in range(number_of_blocks):
			var new_block = select_block_scn.instance()
			new_block.set_pos(Vector2(sin(i*deg2rad(degree_interval)), cos(i*deg2rad(degree_interval))) * block_distance)
			new_block.set_name(str(i*degree_interval))
			new_block.set_selected(false)
			get_node("blocks").add_child(new_block)
	elif player.weapon == player.STAFF:
		var degree_interval = 45
		number_of_blocks = 8
		for i in range(number_of_blocks):
			var new_block = select_block_scn.instance()
			new_block.set_pos(Vector2(sin(i*deg2rad(degree_interval)), cos(i*deg2rad(degree_interval))) * block_distance)
			new_block.set_name(str(i*degree_interval))
			new_block.set_selected(false)
			get_node("blocks").add_child(new_block)
		
func get_snapped_degree_angle(rot, snap_to):
	var snapped_rot = round((rot + 7.5)/ snap_to) * snap_to
	var mod_rot = fmod(snapped_rot, 360.0)
	if mod_rot <0:
		mod_rot = 360 + mod_rot
	
	return mod_rot

func cast_weapon(chain):
	if player.weapon == player.SWORD:
		var new_sword = preload("res://player/sword.tscn").instance()
		new_sword.set_pos(get_pos())
		new_sword.direction = Vector2(sin(deg2rad(chain[-1])), cos(deg2rad(chain[-1])))
		next_sword_is_block = false
		get_node("..").add_child(new_sword)
		get_node(power_bar).burst(sword_power_cost)
	
	if player.weapon == player.ARROW:
		var new_arrow = preload("res://player/arrow.tscn").instance()
		new_arrow.set_pos(get_pos())
		new_arrow.direction = Vector2(sin(deg2rad(chain[0])), cos(deg2rad(chain[0])))
		new_arrow.curve = Vector2(sin(deg2rad(chain[-1])), cos(deg2rad(chain[-1])))
		new_arrow.charge = get_node(power_bar).current_charge
		next_sword_is_block = false
		get_node("..").add_child(new_arrow)
		get_node(power_bar).release_charge()
	
	if player.weapon == player.STAFF:
		var block = chain[-1]
		if fmod(block, 90) == 0:
			var new_ball = preload("res://player/magic_ball.tscn").instance()
			new_ball.direction= Vector2(sin(deg2rad(block)), cos(deg2rad(block)))
			new_ball.set_pos(get_pos() + new_ball.direction *24)
			get_node("..").add_child(new_ball)
			get_node(power_bar).burst(20)
		elif fmod(block, 45) == 0:
			var new_shocks = preload("res://player/shocks.tscn").instance()
			new_shocks.connect("hit_demon", self, "hit_demon")
			new_shocks.set_rotd(block+ 135)
			var direction = Vector2(sin(deg2rad(block)), cos(deg2rad(block)))
			new_shocks.set_pos(get_pos() + direction *24)
			get_node("..").add_child(new_shocks)
			get_node(power_bar).burst(8)
			
			
		elif fmod(block, 15) == 0:
			# Shock
			pass

func can_jump():
	if jump_timer <= 0:
		return true
	if get_node("RayCast2D").is_colliding():
		return true
	if double_jump:
		return has_double_jump
	return false

func damage(d, cause):
	var blood_node = preload("res://player/blood.tscn").instance()
	blood_node.set_rot(cause.get_rot() + randf() * PI - PI/2)
	blood_node.emit_blood()
	add_child(blood_node)
	if d > recent_damage and invul_timer <= 0:
		invul_timer = invul_cooldown
		last_damage = d
		get_node(power_bar).burst(d - recent_damage)
	else:
		print("blocked damage: ", d)
		
	if player.weapon == player.ARROW and block_chain != []:
		var block = int(get_snapped_degree_angle(rad2deg(get_local_mouse_pos().angle()), 15))
		block_chain.append(block)
		cast_weapon(block_chain)

func kill():
	get_node("anim").stop()
	stop_input()
	dead = true
	
func stop_input():
	takes_input = false

func _on_bar_charge_released():
	if player.weapon == player.ARROW and block_chain != []:
		var block = int(get_snapped_degree_angle(rad2deg(get_local_mouse_pos().angle()), 15))
		block_chain.append(block)
		cast_weapon(block_chain)

func hit_demon():
	get_node("..").hit_demon()
