extends Node2D

const IDLE = 0
const CONNECTING = 1

var state = IDLE

var connected = false

var host = null
var client = null

var magic_code = "666"

var server_url = "https://dreamlight-server.herokuapp.com"
var server_port = null

var override_as_server = false

var out_timer=0

func _ready():
	# Start connecting to the dreamlight server,
	# it should ping back on port 80 @ http://dreamlight-server.herokuapp.com/port
	# with a port number for the TCP connection
	
	set_process(true)
	
	if OS.get_environment("DREAMLIGHTSERVER") == magic_code or override_as_server:
		# read neighbor file for game.port
		server_port = read_game_port_file()
		
		tcp_listen()
		print("Running Server Version on port: ", server_port)
		
	else:
		# request the game.port over HTTP
		print("running client version, code: ", OS.get_environment("DREAMLIGHTSERVER"))
		server_port = read_game_port_file()
		client_connect()

func read_game_port_file():
	var file = File.new()
	file.open("game.port", File.READ)
	return int(file.get_as_text())
	

func tcp_listen():
	host = TCP_Server.new()
	host.listen(server_port)

func client_connect():
	client = StreamPeerTCP.new()
	client.connect(server_url, server_port)
	print("Searching: ", server_port, ", ",client.get_status())
	

func on_success_connection():
	# Activate the multiplayer button
	pass

func on_fail_connection():
	# Try again.
	# After 3 tries this must be clicked to reset the
	# attempts for automatic connection
	pass

func _process(delta):
	out_timer -= delta
	if host != null:	
		# Monitor for a network response
		if host.is_connection_available():
			print("ouuuu hello: ", host.take_connection())
			
	elif client != null:
		if out_timer < 0:
			reset_ticker()	
			print("Searching: ", server_port, ", ",client.get_status())
		
		if client.get_status() == StreamPeerTCP.STATUS_CONNECTED and not connected:
			connected=true
			print("mmmm theres my friend")
			get_node("AnimationPlayer").stop()

func reset_ticker():
	out_timer = 1