def get_valid_port():
	# Should check if ports are in use
	# for now use one-to-one webpage and server
	return 4202

def create_port_file(path="game.port"):
	file = open(path,"w")
	file.write(str(get_valid_port()))
	file.close()
