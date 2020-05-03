extends Control

onready var money_label = $VBoxContainer/HBoxContainer2/Money

onready var energy_current_label = $VBoxContainer/HBoxContainer/VSplitContainer/Label2
onready var projectiles_current_label = $VBoxContainer/HBoxContainer/VBoxContainer2/Label5
onready var push_current_label = $VBoxContainer/HBoxContainer/VBoxContainer3/Label8

onready var energy_cost_label = $VBoxContainer/HBoxContainer/VSplitContainer/Label3
onready var projectiles_cost_label = $VBoxContainer/HBoxContainer/VBoxContainer2/Label4
onready var push_cost_label = $VBoxContainer/HBoxContainer/VBoxContainer3/Label7

onready var energy_buy_button = $VBoxContainer/HBoxContainer/VSplitContainer/BuyEnergy
onready var projectiles_buy_button = $VBoxContainer/HBoxContainer/VBoxContainer2/BuyProjectiles
onready var push_buy_button = $VBoxContainer/HBoxContainer/VBoxContainer3/BuyPush

onready var user_data = get_node("/root/UserData")

const INIT_ENERGY = 3
const INIT_PROJECTILES = 3

var current_energy 
var current_projectiles
var current_push
var current_push_level
var current_money

func _ready():
	var current_energy = user_data.get_max_energy()
	var current_projectiles = user_data.get_count_of_weapons()
	var current_push = user_data.get_push_power()
	var current_push_level = _log2(current_push) + 1
	var current_money = user_data.get_money()
	money_label.text = "Деньги: " + str(current_money)
	energy_current_label.text = str(current_energy)
	projectiles_current_label.text = str(current_projectiles)
	
	push_current_label.text = str(current_push)
	
	energy_cost_label.text = str(1000 * pow(2, current_energy - INIT_ENERGY))
	projectiles_cost_label.text = str(1000 * pow(2, current_projectiles - INIT_PROJECTILES))
	push_cost_label.text = str(1000 * pow(2, current_push_level - 1))
	
	if current_money < 1000 * pow(2, current_energy - INIT_ENERGY):
		energy_buy_button.disabled = true
	if current_money < 1000 * pow(2, current_projectiles - INIT_PROJECTILES):
		projectiles_buy_button.disabled = true
	if current_money < 1000 * pow(2, current_push_level - 1):
		push_buy_button.disabled = true
		
func _log2(n):
	return log(n) / log(2)

func _on_BuyEnergy_pressed():
	var current_energy = user_data.get_max_energy()
	user_data.set_max_energy(user_data.get_max_energy() + 1)
	user_data.set_money(user_data.get_money() - 1000 * pow(2, current_energy - INIT_ENERGY))
	user_data.save()
	_ready()


func _on_BuyProjectiles_pressed():
	var current_projectiles = user_data.get_count_of_weapons()
	user_data.set_count_of_weapons(user_data.get_count_of_weapons() + 1)
	user_data.set_money(user_data.get_money() - 1000 * pow(2, current_projectiles - INIT_PROJECTILES))
	user_data.save()
	_ready()


func _on_BuyPush_pressed():
	var current_push = user_data.get_push_power()
	var current_push_level = _log2(current_push) + 1
	user_data.set_push_power(user_data.get_push_power() * 2)
	user_data.set_money(user_data.get_money() - 1000 * pow(2, current_push_level - 1))
	user_data.save()
	_ready()


func _on_ToMenu_pressed():
	user_data.save()
	get_tree().change_scene("res://Scenes/UI/MainMenuBackground.tscn")
