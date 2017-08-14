tool
extends Sprite

var timer = 0
export var sway_time = 3.0
export var sway_range = 15.0

func _ready():
	set_process(true)

func _process(delta):
	timer += delta
	
	set_rot(sin((timer)/2.0) * deg2rad(sway_range))
