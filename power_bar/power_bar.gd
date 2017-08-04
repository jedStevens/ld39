tool
extends Node2D

export(int) var value=100
var max_val=100
var min_val=0
var regen_per_second = 2.5

var lost_power = 0 # Power lost recently

var charge_timer = 0
var charge_rate = 0
var current_charge = 0
var dead = false

signal death
signal charge_released

func _ready():
	set_process(true)

func _process(delta):
	if not dead:
		value += regen_per_second * delta
	
	lost_power -= delta * 10
	lost_power = max(lost_power, 0)
	lost_power = min(lost_power, max_val - value)
	
	
	if charge_timer > 0:
		current_charge += charge_rate * delta
		charge_timer -= delta
		current_charge = min(current_charge, value)
		if charge_timer < 0:
			release_charge()
			emit_signal("charge_released")
	
	if value > max_val:
		value = max_val
	if value < min_val:
		value = min_val
		emit_signal("death")
		dead=true
	
	get_node("fill").set_scale( Vector2((float(value) / max_val)* get_node("bg").get_scale().x,get_node("fill").get_scale().y))
	get_node("lost_power").set_scale(Vector2((float(lost_power) / max_val)* get_node("bg").get_scale().x,get_node("fill").get_scale().y))
	get_node("lost_power").set_pos(Vector2((float(value) / max_val)* get_node("bg").get_scale().x + get_node("fill").get_pos().x, get_node("fill").get_pos().y))
	get_node("charge").set_scale(Vector2((float(current_charge) / max_val)* -get_node("bg").get_scale().x,get_node("fill").get_scale().y))
	get_node("charge").set_pos(Vector2((float(value) / max_val)* get_node("bg").get_scale().x + get_node("fill").get_pos().x, get_node("fill").get_pos().y))
	get_node("marker").set_pos(Vector2((float(value) / max_val)* get_node("bg").get_scale().x + get_node("fill").get_pos().x -2, get_node("fill").get_pos().y))
	

func charge(rate, max_duration):
	charge_rate = rate
	charge_timer = max_duration
	get_node("sfx").play("charge")

func release_charge():
	lost_power = current_charge
	value -= current_charge
	current_charge = 0
	charge_timer = 0
	get_node("sfx").stop_all()
	get_node("sfx").play("lost_power")

func burst(amount):
	value -= amount
	lost_power += amount
	get_node("sfx").stop_all()
	get_node("sfx").play("lost_power")