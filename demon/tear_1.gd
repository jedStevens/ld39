extends Node2D
export(int) var damage=25
var already_hit_player = false

var max_offset = 24
func _ready():
	set_fixed_process(true)
	set_rot(randf() * 2 * PI)
	var angle = randf()
	set_pos(get_pos() + Vector2(sin(angle), cos(angle)) * max_offset * (randf() * 0.5 + 0.5))

func _fixed_process(delta):
	check_for_player()

func check_for_player():
	if not already_hit_player:
		for area in get_node("attacks").get_children():
			
			if area.overlaps_body(player.body):
				player.body.damage(damage* (0 if already_hit_player else 1), area)
				queue_free()
				already_hit_player = true
				break

func on_aoe_enter(body):
	if body.is_in_group("player_weapon"):
		queue_free()