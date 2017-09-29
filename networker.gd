extends Node2D

const IDLE = 0
const CONNECTING = 1

var state = IDLE

var connected = false

var host = null
var client = null

var magic_code = "666"

var server_url = "http://dreamlight-server.herokuapp.com"
var server_port = null

func _ready():
	# Start connecting to the dreamlight server,
	# it should ping back on port 80 @ http://dreamlight-server.herokuapp.com/port
	# with a port number for the TCP connection
	
	if OS.get_environment("DREAMLIGHTSERVER") == magic_code:
		# read neighbor file for game.port
		server_port = read_game_port_file()
		
		tcp_listen()
		print("Running Server Version on port: ", server_port)
		
	else:
		# request the game.port over HTTP
		print("running client version because we got code: ", OS.get_environment("DREAMLIGHTSERVER"))

func read_game_port_file():
	var file = File.new()
	file.open("game.port", File.READ)
	return int(file.get_as_text())
	

func tcp_listen():
	host = TCP_Server.listen(server_port)

func on_success_connection():
	# Activate the multiplayer button
	pass

func on_fail_connection():
	# Try again.
	# After 3 tries this must be clicked to reset the
	# attempts for automatic connection
	pass

func _process(delta):
	if host != null:	
		# Monitor for a network response
		pass
	elif client != null:
		# Do player things
		pass