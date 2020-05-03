extends Node

const SAVE_FILE_NAME = "save.json"

var high_score: int = 0
var money: int = 0
var count_of_weapons: int = 3
var push_power: float = 1.5
var max_energy: int = 3

func _init():
	load_from_file(SAVE_FILE_NAME)

func save_to_file(filename):
	var save_file = File.new()
	save_file.open("user://" + filename, File.WRITE)
	var data_dict = {
		"high_score": high_score,
		"money": money,
		"count_of_weapons": count_of_weapons,
		"push_power": push_power,
		"max_energy": max_energy
	}
	save_file.store_line(to_json(data_dict))
	save_file.close()

func load_from_file(filename):
	var save_file = File.new()
	var open_error = save_file.open("user://" + filename, File.READ)
	if open_error != OK:
		print("File didn`t loaded. Using default data.")
		save_file.close()
		save_to_file(SAVE_FILE_NAME)
		save_file.open("user://" + filename, File.READ)
#		return
	var data = parse_json(save_file.get_line())
	for key in data.keys():
		call("set_" + key, data[key])
	save_file.close()
	
func save():
	save_to_file(SAVE_FILE_NAME)

func get_high_score():
	return high_score

func get_money():
	return money
	
func get_count_of_weapons():
	return count_of_weapons
	
func get_push_power():
	return push_power
	
func get_max_energy():
	return max_energy

func set_high_score(value):
	high_score = value

func set_money(value):
	money = value
	
func set_count_of_weapons(value):
	count_of_weapons = value
	
func set_push_power(value):
	push_power = value
	
func set_max_energy(value):
	max_energy = value
