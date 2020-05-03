extends Node2D

func _ready():
	update_combo(0)
	update_experience(0)
	update_money(0)

func update_combo(combo):
	$UpperHUD/VBoxContainer/Cobmo.text = 'Комбо: ' + str(combo)


func update_experience(experience):
	$UpperHUD/VBoxContainer/Experience.text = 'Опыт: ' + str(experience)


func update_money(money):
	$UpperHUD/VBoxContainer/Money.text = 'Деньги: ' + str(money)

	
func update_energy(energy):
	pass


func update_hp(hp):
	pass
