extends KinematicBody2D
var direction = Vector2(0,-1)
var move_speed= 120
func _ready():
	set_fixed_process(true)
	get_node("sfx").play("fireball")
func _fixed_process(delta):
	get_node("sprite").set_global_rot(direction.angle())
	get_node("sprite/Particles2D").set_param(Particles2D.PARAM_INITIAL_ANGLE, rad2deg(direction.angle()-PI))
	move(move_speed * direction * delta)
	if is_colliding():
		queue_free()