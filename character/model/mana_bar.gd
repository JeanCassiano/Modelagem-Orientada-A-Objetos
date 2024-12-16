extends ProgressBar


@onready var timer = $Timer
@onready var damage_bar = $DamageBar


var mana = 0 : set = _set_mana 

func _set_mana(new_mana):
	var prev_mana = mana
	mana = min(max_value, new_mana)
	value = mana
		
		
	if mana < prev_mana:
		timer.start()
	else: 
		damage_bar.value = mana
		
		
func init_mana(_mana):
	mana = _mana
	max_value = mana
	value = mana
	damage_bar.max_value = mana
	damage_bar.value = mana
	

func _on_timer_timeout() -> void:
	damage_bar.value = mana
