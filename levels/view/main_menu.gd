extends Control


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/view/test_level.tscn")


			
func _on_load_pressed() -> void:
	var packed_scene = preload("res://levels/view/test_level.tscn")
	
	# Instancia a cena
	var new_scene = packed_scene.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = new_scene

	new_scene.call("Load")
	
