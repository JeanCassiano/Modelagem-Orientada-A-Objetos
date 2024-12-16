extends Enemy

class_name Skeleton

func _ready() -> void:
	_health = 50  # Altere o valor de vida do Orc
	SPEED = 40
	DAMAGE = 25
	healthbar.init_health(_health)  # Atualize a barra de vida com o novo valor
	super._ready()  # Chame o método _ready da classe base
