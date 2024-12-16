extends Control
@onready var main = $"../../.."
func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_resume_pressed() -> void:
	main.PauseMenu()

func _on_saves_pressed() -> void:
	main.Save()


func _on_load_pressed() -> void:
	main.Load()
