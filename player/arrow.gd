tool
extends KinematicBody2D

export(float) var move_speed = 200
export(float) var time = 3
var timer = 0
var direction = Vector2(0,0)
var curve = Vector2(0,0)
var curve_amount = 5
var grav_str = 6
var charge = 0

var gamma = 2

var dead = false

var grav = Vector2(0,0)

func _ready():
	set_fixed_process(true)
	timer = time
	
	set_rot(direction.angle())
	
	correct_sprite()

func _fixed_process(delta):
	timer -= delta
	if timer < 0:
		queue_free()
	direction+=curve.normalized()*curve_amount*delta
	curve_amount += delta*player.GOLDEN_RATIO
	
	grav += Vector2(0,grav_str) * delta
	
	if is_colliding() and not dead:
		if get_collider().is_in_group("stone"):
			get_node("sfx").play("metal_hit")
			dead = true
	if not dead:
		var travel_dir = direction.normalized()*delta*(move_speed/3+2*move_speed/3*charge/4)+grav
		move(travel_dir)
	
	
	
		set_rot(travel_dir.angle())
	
	correct_sprite()
	

func correct_sprite():
	get_node("sprite").set_global_rot(0)
	
	get_node("sprite").set_frame((get_snapped_degree_angle(get_global_rotd()+180-7.5, 15)) / 15)
	get_node("Particles2D").set_texture(get_node("sprite").get_texture())
	get_node("Particles2D").set_param(Particles2D.PARAM_ANIM_INITIAL_POS, fmod((get_node("sprite").get_frame()/24.0),1))
	
func get_snapped_degree_angle(rot, snap_to):
	var snapped_rot = round((rot + 7.5)/ snap_to) * snap_to
	var mod_rot = fmod(snapped_rot, 360.0)
	if mod_rot <0:
		mod_rot = 360 + mod_rot
	
	return mod_rot