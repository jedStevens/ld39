extends RigidBody2D

export var frame = 0

func _ready():
	set_fixed_process(true)

func set_frame(i):
	get_node("Particles2D").set_param(Particles2D.PARAM_ANIM_INITIAL_POS, int(i / 24.0))

func _fixed_process(delta):
	get_node("Particles2D").set_param(Particles2D.PARAM_INITIAL_ANGLE, get_global_rotd()-180)
	for body in get_colliding_bodies():
		if body.is_in_group("stone"):
			if get_linear_velocity().length() > 50.0:
				get_node("sfx").play("metal_hit")