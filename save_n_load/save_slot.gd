tool
extends Control

export var character_name = "name goes here" setget set_character_name, get_character_name

var header = {}

signal remove_slot(slot)
signal selected

export(NodePath) var name_box = null
func get_character_name():
	return character_name
func set_character_name(name):
	character_name = name
	if name_box != null:
		get_node(name_box).set_text(character_name)

func set_info(char_header):
	header = char_header
	get_node("details").set_location(char_header["location"])
	get_node("details").set_name(char_header["name"])
	get_node("details").set_level(char_header["level"])
	get_node("details").set_icons([])


func _on_preview_pressed():
	get_node("details").popup_centered()

func _on_delete_pressed():
	get_node("delete_confirm").popup_centered()

func _on_delete_confirm_confirmed():
	emit_signal("remove_slot")

func _on_select_pressed():
	emit_signal("selected")