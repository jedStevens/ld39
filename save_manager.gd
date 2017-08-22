extends Node

var EXT = ".ds"

var BASE_DIR = OS.get_data_dir() + "/saves/"

var DATA_CRYPT = true
var NAME_CRYPT = true

### Game Scope

func load_save(path, file):
	return load_leaf(path, file)

func create_save(character_header, path=""):
	create_leaf(character_header, path, get_file_name(character_header["name"]))

func get_saves(path=""):
	return load_branch(path)

func remove_save(path, filename):
	var dir = Directory.new()
	dir.open(path)
	print("Removing save @ ", dir.get_current_dir()," ... wanted ", path, filename)
	return dir.remove(filename)
	

###  Concept Scope

func create_leaf(data, path="", file_name="leaf.json"):
	create_data_dir(path)
	create_data_file(data, format_path(path+"/"+file_name))

func load_leaf(path, file_name):
	var file = File.new()
	var n_path = BASE_DIR + format_path(file_name)
	print("Loading Leaf @ ", path)
	file.open(n_path, file.READ)
	var data = data_decrypt(file.get_as_text())
	file.close()
	
	var out_dict = {}
	out_dict.parse_json(data)
	
	out_dict["path"] = path
	out_dict["filename"] = file_name
	
	return out_dict

func create_branch(path=""):
	create_data_dir(path)

func load_branch(path):
	path = OS.get_data_dir() + "/"+path
	var leaves = []
	var dir = Directory.new()
	dir.open(path)
	print("Loading From: ", dir.get_current_dir())
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			leaves.append(load_leaf(path, file))
	
	dir.list_dir_end()
	
	return leaves

func get_file_name(s):
	if NAME_CRYPT:
		return name_crypt(s)+EXT
	return s+EXT

func name_crypt(s):
	var out_str = ""
	var name=s.to_ascii()
	for c in name:
		out_str += str(c)
	var final_str = ""
	for i in range(out_str.length()/2):
		final_str += RawArray([alpha_ascii_wrap(int(out_str.substr(i*2,2)))]).get_string_from_ascii()
	return final_str

func data_crypt(s):
	var arr = s.to_ascii()
	var out = RawArray()
	for c in arr:
		out.push_back(ascii_shift(c, 5))
	return out.get_string_from_ascii()

func data_decrypt(s):
	var arr = s.to_ascii()
	var out = RawArray()
	for c in arr:
		out.push_back(ascii_shift(c, -5))
	return out.get_string_from_ascii()

func ascii_shift(c, n):
	if c < 32:
		return c
	elif c > 127:
		return 32 + (127 - c)
	else:
		var shifted = c+n
		if shifted > 127:
			return 32 + (shifted-127)
		elif shifted < 32:
			return 127 - (32 - shifted)
		else:
			return shifted

func create_data_dir(path=""):
	var data_dir = Directory.new()
	data_dir.open(OS.get_data_dir())
	
	if ! data_dir.dir_exists(path):
		data_dir.make_dir_recursive(path)
		print("Created Directory @ ", path)

func create_data_file(data, path=""):
	path = BASE_DIR+path
	
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(data_crypt(data.to_json()))
	file.close()
	
	print("Created File @ ", path)

func format_path(path):
	if path.begins_with("/"):
		return format_path(path.substr(1,path.length()-1))
	
	return path

func alpha_ascii_wrap(n):
	return (n % 26) + 65