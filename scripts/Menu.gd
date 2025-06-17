extends Control


func _on_play_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/levels/level_1.tscn")

func _on_settings_button_button_up() -> void:
	#get_tree().change_scene_to_file("res://Scenes/config") 
	pass

func _on_quit_button_button_up() -> void:
	get_tree().quit()
