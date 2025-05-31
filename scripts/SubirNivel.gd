extends Area2D

var player_inside: CharacterBody2D = null # Armazena referência ao jogador dentro da área

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_inside = body

func _on_body_exited(body: Node2D) -> void:
	if body == player_inside:
		player_inside = null

func _process(delta: float) -> void:
	if player_inside and player_inside.current_action == "use":
		change_to_next_level()

func change_to_next_level():
	var current_scene_path := get_tree().current_scene.scene_file_path

	var regex := RegEx.new()
	regex.compile("^res://scenes/levels/level_(\\d+)\\.tscn")

	var result := regex.search(current_scene_path)

	if result:
		var current_level := int(result.get_string(1))
		var next_level := current_level - 1

		var next_scene_path := "res://scenes/levels/level_%d.tscn" % next_level

		if ResourceLoader.exists(next_scene_path):
			get_tree().change_scene_to_file(next_scene_path)
		else:
			print("Level %d não existe: %s" % [next_level, next_scene_path])
	else:
		print("Nome da cena atual não segue o padrão 'level_X.tscn'")
