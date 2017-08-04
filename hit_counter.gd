extends HBoxContainer

export(Texture) var skull_icon = null
var skulls = 0

func set_skulls(n):
	if n!=skulls:
		for c in get_children():
			c.queue_free()
			remove_child(c)
		
		skulls = n
		 
		for i in range(skulls):
			var new_skull = TextureFrame.new()
			new_skull.set_texture(skull_icon)
			add_child(new_skull)
	
	