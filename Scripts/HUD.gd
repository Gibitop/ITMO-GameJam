extends Control

func _ready():
	update_combo(0)
	update_experience(0)
	update_money(0)
	update_energy(0)
	update_hp(0)

func update_combo(combo):
	$TL/Cobmo.text = 'Комбо: ' + str(combo)


func update_experience(experience):
	$TL/Experience.text = 'Опыт: ' + str(experience)


func update_money(money):
	$TL/Money.text = 'Деньги: ' + str(money)

	
func update_energy(energy):
	$BL/Energy.text = 'Энергия: ' + str(energy)


func update_hp(hp):
	$BL/HP.text = 'Здоровье: ' + str(hp)
	

