extends Popup

export(NodePath) var location_label
export(NodePath) var name_label
export(NodePath) var level_label

export(NodePath) var icon_box

func set_location(loc):
	get_node(location_label).set_text(loc)
func set_level(level):
	get_node(level_label).set_text(str(level))
func set_name(name):
	get_node(name_label).set_text(name)

func set_icons(icons):
	for child in get_node(icon_box).get_children():
		get_node(icon_box).remove_child(child)
	
	for icon in icons:
		get_node(icon_box).add_child(icon)

func _on_close_pressed():
	hide()

