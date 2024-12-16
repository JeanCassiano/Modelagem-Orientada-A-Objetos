extends Enemy

class_name Orc

func _ready() -> void:
	_health = 100  # Altere o valor de vida do Orc
	SPEED = 50
	DAMAGE = 10  
	healthbar.init_health(_health)  # Atualize a barra de vida com o novo valor
	super._ready()  # Chame o método _ready da classe base
