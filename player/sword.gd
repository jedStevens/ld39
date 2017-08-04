extends KinematicBody2D

export(float) var move_speed = 120
export(float) var time = 0.4
var timer = 0
var direction = Vector2(0,0)
var gamma = 2

var dead = false

func _ready():
	set_fixed_process(true)
	timer = time
	
	set_rot(direction.angle())
	
	correct_sprite()

func _fixed_process(delta):
	timer -= delta
	if timer < 0:
		queue_free()
	
	if is_colliding() and not dead and get_collider().is_in_group("stone"):
		dead = true
		get_node("sfx").play("metal_hit")
	
	move(direction.normalized()*delta*move_speed)
	
	set_rot(direction.angle())
	
	correct_sprite()
	

func correct_sprite():
	get_node("sprite").set_global_rot(0)
	
	get_node("sprite").set_frame((get_snapped_degree_angle(get_global_rotd()+180, 30)) / 30)
	get_node("Particles2D").set_texture(get_node("sprite").get_texture())
	get_node("Particles2D").set_param(Particles2D.PARAM_ANIM_INITIAL_POS, fmod((get_node("sprite").get_frame()/12.0),1))
	
func get_snapped_degree_angle(rot, snap_to):
	var snapped_rot = round((rot + 7.5)/ snap_to) * snap_to
	var mod_rot = fmod(snapped_rot, 360.0)
	if mod_rot <0:
		mod_rot = 360 + mod_rot
	
	return mod_rot