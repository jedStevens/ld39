extends Node2D

const MAX_PLAYERS = 32

var players_ready = false

var players=[]


func _ready():
	set_process(true)

func load_player(player_data):
	var new_player = {}

func set_player_ready(p_id):
	players[p_id].ready = true

func _process(delta):
	pass

func _on_bar_death():
	for player in get_node("players").get_children():
		if not player.dead:
			player.kill()
			get_node("anim").set_speed(1)
			get_node("anim").play("death")
			get_node("music").stop()