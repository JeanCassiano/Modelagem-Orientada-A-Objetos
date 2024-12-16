extends Node2D

@onready var pausemenu = $Ysort/Character/PauseMenu
var paused = false
func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		PauseMenu()


func PauseMenu() -> void:
	if paused:
		pausemenu.hide()
		Engine.time_scale = 1
	else:
		pausemenu.show()
		Engine.time_scale = 0
		
	paused = !paused
	
func Save() -> void:
	var file = FileAccess.open("res://savegame.dat", FileAccess.WRITE)
	
	# Salvar posição do personagem
	file.store_var($Ysort/Character.position)
	
	# Salvar vida do personagem
	file.store_var($Ysort/Character.get_health())
	file.store_var($Ysort/Character.get_score())
	# Salvar posições e vidas dos inimigos
	var enemy_data = []
	for enemy in $Ysort/Enemies.get_children():
		if enemy is Enemy:
			enemy_data.append({"position": enemy.position, "health": enemy.get_health()})
	file.store_var(enemy_data)
	
	file.close()


func Load() -> void:
	var file = FileAccess.open("res://savegame.dat", FileAccess.READ)
	
	# Carregar posição do personagem
	$Ysort/Character.position = file.get_var()
	
	# Carregar vida do personagem
	$Ysort/Character.set_health(file.get_var())
	$Ysort/Character.set_score(file.get_var())
	# Carregar posições e vidas dos inimigos
	var enemy_data = file.get_var()
	var enemies = $Ysort/Enemies.get_children()
	var index = 0
	
	for enemy in enemies:
		if enemy is Enemy and index < enemy_data.size():
			enemy.position = enemy_data[index]["position"]
			enemy.set_health(enemy_data[index]["health"])
			index += 1
	
	file.close()
