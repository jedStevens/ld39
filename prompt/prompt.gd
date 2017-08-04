extends Sprite

const CHAR_LIMIT = 34

const NORMAL = 0
const ERROR = 1
const WARNING = 2
const SUCCESS = 3

var hotkey = KEY_SLASH
var altkey = KEY_QUOTELEFT

var showing = false

var command  = ""
var response = ""

signal on_command(cmd)

func write_res(text, type=NORMAL):
	if text.length() > CHAR_LIMIT:
		text = text.substr(0,CHAR_LIMIT)
	
	
	if type == NORMAL:
		get_node("response").set("custom_colors/font_color", Color(1,1,1))
	elif type == ERROR:
		get_node("response").set("custom_colors/font_color", Color(1,0,0))
	elif type == WARNING:
		get_node("response").set("custom_colors/font_color", Color(1,1,0))
	elif type == SUCCESS:
		get_node("response").set("custom_colors/font_color", Color(0,1,0))
	get_node("response").set_text(text)
	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	set_process_input(true)
	write_res("Dreamlight Console v0.1")

func _input(event):
	if event.type == InputEvent.KEY:
		if event.pressed:
			if event.scancode == hotkey or event.scancode == altkey:
				showing = not showing
				if showing:
					command = "/"
			elif event.scancode == KEY_BACKSPACE:
				command = command.substr(0, command.length() - 1)
				if command == "":
					command = "/"
			elif event.scancode == KEY_RETURN and showing:
				emit_signal("on_command", command.substr(1,command.length()-1))
				command = "/"
			else:
				if command.length() < CHAR_LIMIT:
					command += RawArray([event.unicode]).get_string_from_utf8()

func _process(delta):
	if showing:
		set_opacity(1)
		get_node("command").set_text(command)
		
	else:
		set_opacity(0)
		
func term_out(text, type=NORMAL_MSG):
	print(text)