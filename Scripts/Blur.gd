extends ColorRect

export (float) var blur_amount = 2.5

func _ready():
	material.set_shader_param("blur_amount", blur_amount)
	
