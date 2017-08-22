extends VBoxContainer

export(PackedScene) var slot_scn
export(NodePath) var slots

func _ready():
	save_manager.create_save({"name":"Jde","level":995,"location":"Garden of Hope"})
	
	reload()
	

func reload():
	for child in get_node(slots).get_children():
		get_node(slots).remove_child(child)
		
	for save in save_manager.get_saves("saves"):
		var slot_node=slot_scn.instance()
		slot_node.set_character_name(save["name"] +", lvl"+str(save["level"]))
		var data = save
		slot_node.set_info(save)
		slot_node.connect("remove_slot", self, "delete_slot", [slot_node])
		slot_node.connect("selected", self, "play_game", [slot_node])
		get_node(slots).add_child(slot_node)
	

func delete_slot(slot):
	print(save_manager.remove_save(slot.header["path"], slot.header["filename"]))
	reload()

func add_slot():
	pass

func play_game(slot):
	player.load_data(slot.header)
	get_tree().change_scene("res://game.tscn")

func _on_back_pressed():
	get_tree().change_scene("res://main_menu/main_menu.tscn")