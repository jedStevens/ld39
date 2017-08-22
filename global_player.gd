extends Node

const GOLDEN_RATIO = 1.61803398875

const SWORD = 0
const STAFF = 1
const ARROW = 2

const GRAVITY = 200

const HITS_PER_LEVEL = [1, 3, 5]

var damage = 1
# Swipes, Eye, Claw, Tail, Fire

var weapon = SWORD

var body = null

var next_scn = "res://game.tscn"

var name = "name"

func set_weapon(new_weapon):
	weapon = new_weapon

func load_data(header):
	if "name" in header.keys():
		name = header["name"]