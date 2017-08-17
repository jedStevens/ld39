extends Node

func execute_in(timeout, obj, function_name, args=[], conn_flags=0):
	var timer = Timer.new()
	timer.connect("timeout", obj, function_name, args, conn_flags)
	timer.set_wait_time(timeout)
	timer.set_one_shot(true)
	timer.start()
	return timer