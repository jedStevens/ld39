extends Label

export var transition_speed = 2.0

var _target_opacity = 0.0

func _ready():
	set_opacity(_target_opacity)
	set_process(true)

func _process(delta):
	set_opacity(lerp(get_opacity(), _target_opacity, delta * transition_speed))

func _on_mouse_enter():
	_target_opacity = 1.0

func _on_mouse_exit():
	_target_opacity = 0.0
