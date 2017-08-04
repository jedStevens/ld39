extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_arrow_pressed():
	player.set_weapon(player.ARROW)
	play_intro_cin()


func _on_staff_pressed():
	player.set_weapon(player.STAFF)
	play_intro_cin()


func _on_sword_pressed():
	player.set_weapon(player.SWORD)
	play_intro_cin()

func play_intro_cin():
	get_node("anim").play("lead_out")

func on_lead_out_completed():
	get_tree().change_scene(player.next_scn)