extends Node

var high_score: int = 0
var money: int = 0
var count_of_weapons: int = 0
var push_power: float = 0
var max_hp: int = 3

func save_to_file(filename):
	var save_file = File.new()
	save_file.open("user://" + filename, File.WRITE)
	var data_dict = {
		"high_score": high_score,
		"money": money,
		"count_of_weapons": count_of_weapons,
		"push_power": push_power,
		"max_hp": max_hp
	}
	save_file.store_line(to_json(data_dict))
	save_file.close()

func load_from_file(filename):
	var save_file = File.new()
	save_file.open("user://" + filename, File.READ)
	var data = parse_json(save_file.get_line())
	for key in data.keys():
		call("set_" + key, data[key])
	save_file.close()

func get_high_score():
	return high_score

func get_money():
	return money
	
func get_count_of_weapons():
	return count_of_weapons
	
func get_push_power():
	return push_power
	
func get_max_hp():
	return max_hp

func set_high_score(value):
	high_score = value

func set_money(value):
	money = value
	
func set_count_of_weapons(value):
	count_of_weapons = value
	
func set_push_power(value):
	push_power = value
	
func set_max_hp(value):
	max_hp = value
